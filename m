Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab1IZNtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 09:49:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45942 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab1IZNtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 09:49:07 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <CAOtvUMdfGsPq2aaW2SOXkVvhpOKk8nLhjKGU90YGp07w_vy9Vw@mail.gmail.com>
References: <1316940890-24138-1-git-send-email-gilad@benyossef.com>
	<1316940890-24138-6-git-send-email-gilad@benyossef.com>
	<1317022420.9084.57.camel@twins>
	<CAOtvUMeMsd0Jk1k4wP9Y+7NW3FYZZAqV1-cRj5Zt4+eaugWoPg@mail.gmail.com>
	<1317030352.9084.76.camel@twins>
	<CAOtvUMdfGsPq2aaW2SOXkVvhpOKk8nLhjKGU90YGp07w_vy9Vw@mail.gmail.com>
Date: Mon, 26 Sep 2011 16:49:06 +0300
Message-ID: <CAOtvUMeC=XMCQaa8TyyWEcE6jjb0sQr1WTKkv=orTxZ9907hPQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] slub: Only IPI CPUs that have per cpu obj to flush
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 3:05 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:


>> The problem with a per-cpu cpumask is that you need to disable
>> preemption over the whole for_each_online_cpu() scan and that's not
>> really sane on very large machines as that can easily take a very long
>> time indeed.
>
> hmm... I might be thick, but why disable the preemption with the
> per-cpu cpumask at all?
...
>
> Does that makes sense or have I've gone over board with this concept? :-)

Scratch that. The cpumask must be per cache or the patch doesn't make
sense at all.
So sadly the only sane place to put it is in struct kmem_cache.

I think we can still update the cpumask field without caring about
preemption for the reasons
stated above, but the per cache memory overhead is still there I'm afraid.

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
