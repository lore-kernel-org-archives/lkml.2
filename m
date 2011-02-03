Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab1BCTtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 14:49:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756588Ab1BCTtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 14:49:06 -0500
MIME-Version: 1.0
In-Reply-To: <1296761671.4418.1558.camel@sbsiddha-MOBL3.sc.intel.com>
References: <1296677247.4418.103.camel@sbsiddha-MOBL3.sc.intel.com>
 <AANLkTi=P+aoY4GY32xa8D8gHbDP73QpPmzvKbB4VM7g2@mail.gmail.com>
 <AANLkTinvQatNF0ZJqmvuKYNq7oKXqfR5Ke1FuaSLFNEF@mail.gmail.com>
 <1296757637.4418.1482.camel@sbsiddha-MOBL3.sc.intel.com> <AANLkTimuSV273ksidN_vQ4o1rLr6D--9Q3dNnBiB13-K@mail.gmail.com>
 <1296761671.4418.1558.camel@sbsiddha-MOBL3.sc.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 Feb 2011 11:48:41 -0800
Message-ID: <AANLkTimjYAYPLf=QG22hFHm7yhABCQj7q=kOpB6HcB5e@mail.gmail.com>
Subject: Re: [patch] x86, mm: avoid stale tlb entries by clearing prev
 mm_cpumask after switching mm
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 3, 2011 at 11:34 AM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
>
> True. 'stale' is the wrong word. Do you want me to send a corrected one
> by replacing it with 'bogus'?

Please.

> my understanding is that unless we end up using that TLB entry, we will
> not have the issues like machine checks due to cacheability issues etc.
> If it is not global, upcoming cr3 change will flush it and meanwhile I
> don't think there is a scenario where we refer to these user-addresses.

Quite possible. The situation I envisioned was the same speculative
memory access that causes the TLB fill to also cause a cache fill -
for a noncacheable region (because the bogus TLB entry sets the random
address to cacheable).

And then what happens when somebody else accesses the same memory
noncacheably (through a valid TLB entry), and finds it in the cache?

I dunno. Not really important. The important part is the "possible
random bogus TLB entry", the fact that the CPU can act strangely after
that is pretty much a given.

                            Linus
