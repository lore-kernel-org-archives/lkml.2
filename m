Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab1JXIFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 04:05:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65024 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab1JXIFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 04:05:05 -0400
MIME-Version: 1.0
X-Originating-IP: [109.66.38.240]
In-Reply-To: <CAOtvUMfVFV3_2wtT-qNpcHxzsTW-1j3wGUqt+O5GhayZHxW1mg@mail.gmail.com>
References: <1319384922-29632-1-git-send-email-gilad@benyossef.com>
	<1319384922-29632-7-git-send-email-gilad@benyossef.com>
	<m2obx755md.fsf@firstfloor.org>
	<CAOtvUMfVFV3_2wtT-qNpcHxzsTW-1j3wGUqt+O5GhayZHxW1mg@mail.gmail.com>
Date: Mon, 24 Oct 2011 10:05:05 +0200
Message-ID: <CAOtvUMe-V5YiDVJ15LcLchzKqpv1YW_W7HyT5iiSyPXp0OWaXg@mail.gmail.com>
Subject: Fwd: [PATCH v2 6/6] slub: only preallocate cpus_with_slabs if offstack
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re-sending to the list due to some foul up with LKML address on my part]


On Mon, Oct 24, 2011 at 7:19 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Gilad Ben-Yossef <gilad@benyossef.com> writes:
>
> > We need a cpumask to track cpus with per cpu cache pages
> > to know which cpu to whack during flush_all. For
> > CONFIG_CPUMASK_OFFSTACK=n we allocate the mask on stack.
> > For CONFIG_CPUMASK_OFFSTACK=y we don't want to call kmalloc
> > on the flush_all path, so we preallocate per kmem_cache
> > on cache creation and use it in flush_all.
>
> What's the problem with calling kmalloc in flush_all?
> That's a slow path anyways, isn't it?
>
> I believe the IPI functions usually allocate anyways.
>
> So maybe you can do that much simpler.

That was what the first version of the patch did (use
alloc_cpumask_var in flush_all).

Pekka Enberg pointed out that calling kmalloc on the kmem_cache
shrinking code path is not a good idea
and it does sound like a deadlock waiting to happen.

Gilad

--
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"I've seen things you people wouldn't believe. Goto statements used to
implement co-routines. I watched C structures being stored in
registers. All those moments will be lost in time... like tears in
rain... Time to die. "



-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"I've seen things you people wouldn't believe. Goto statements used to
implement co-routines. I watched C structures being stored in
registers. All those moments will be lost in time... like tears in
rain... Time to die. "
