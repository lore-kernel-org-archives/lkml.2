Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab1BCEXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:23:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53528 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704Ab1BCEXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:23:22 -0500
Message-ID: <4D4A2D9C.2040803@zytor.com>
Date: Wed, 02 Feb 2011 20:22:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: Re: [patch] x86, mm: avoid stale tlb entries by clearing prev mm_cpumask
 after switching mm
References: <1296677247.4418.103.camel@sbsiddha-MOBL3.sc.intel.com> <m2d3n9ap1y.fsf@firstfloor.org> <1296698151.4418.464.camel@sbsiddha-MOBL3.sc.intel.com> <20110203021510.GM15569@one.firstfloor.org> <AANLkTi=+VQGKDcMmpCLT87NEpMU99i7iW8cOFzyHFpmn@mail.gmail.com>
In-Reply-To: <AANLkTi=+VQGKDcMmpCLT87NEpMU99i7iW8cOFzyHFpmn@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2011 08:12 PM, Linus Torvalds wrote:
> 
> So right now, we pretty much depend on "asm volatile" (a) not being
> re-ordered wrt other asm volatiles and (b) having that dependency on
> memory.
> 
> Iirc, the gcc people even agreed on this. Peter may remember details better..
> 

Yes, IIRC an "asm volatile" is assumed to be a universal consumer of
memory (it is only a universal producer if the "memory" clobber is
used), as well as being ordered with respect to other volatile operations.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

