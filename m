Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab1JBIoL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 04:44:11 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42569 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab1JBIoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 04:44:01 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <4E831A79.1030402@tilera.com>
References: <1316940890-24138-1-git-send-email-gilad@benyossef.com>
	<4E831A79.1030402@tilera.com>
Date: Sun, 2 Oct 2011 10:44:00 +0200
Message-ID: <CAOtvUMdGeBfbLpSqonzLTT6+JUiabDjBG5bpd1_RPykt3x+5Hw@mail.gmail.com>
Subject: Re: [PATCH 0/5] Reduce cross CPU IPI interference
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 3:00 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> On 9/25/2011 4:54 AM, Gilad Ben-Yossef wrote:
>
> I strongly concur with your motivation in looking for and removing sources
> of unnecessary cross-cpu interrupts.

Thanks for the support :-)

> We have some code in our tree (not yet
> returned to the community) that tries to deal with some sources of interrupt
> jitter on tiles that are running isolcpu and want to be 100% in user space.

Yes, I think this work will benefit this kind of use case (CPU/user
space bound on a dedicated CPU)
the most, although other use cases can benefit as well (e.g. power
management with idle cores).

Btw, do you have any plan to share the patches you mentioned? it could
save me a lot of time. Not wanting to
re-invent the wheel and all that...


>> This first version creates an on_each_cpu_mask infrastructure API (derived
>> from
>> existing arch specific versions in Tile and Arm) and uses it to turn two
>> global
>> IPI invocation to per CPU group invocations.
>
> The global version looks fine; I would probably make on_each_cpu() an inline
> in the !SMP case now that you are (correctly, I suspect) disabling
> interrupts when calling the function.
>

Good point. Will do.

I will take this email as an ACK to the tile relevant changes, if that
is OK with you.

Thanks!
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
