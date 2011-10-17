Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab1JQJDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 05:03:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:53429 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab1JQJDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 05:03:23 -0400
Date: Mon, 17 Oct 2011 11:03:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: Linux 3.1-rc9
In-Reply-To: <20111017045806.GA11561@elte.hu>
Message-ID: <alpine.LFD.2.02.1110171101250.3240@ionos>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com> <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca> <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca> <1318060551.8395.0.camel@twins>
 <20111012213555.GC24461@hostway.ca> <20111013232521.GA5654@hostway.ca> <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com> <20111017045806.GA11561@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> For the record, i absolutely hate much of the other time related type 
> obfuscation we do as well.
> 
> For example the ktime_t obfuscation - we only do it to avoid a divide 
> on 32-bit architectures that cannot do fast 64/32 divisions ...
> 
> It makes the time code a *lot* less obvious than it could be.
> 
> I think we should use one flat u64 nanoseconds time type in the 
> kernel (preparing it with using KTIME_SCALAR on all architectures for 
> a release or so), used with very simple and obvious C arithmetics.

It'd be nice, but this simply will not fly.
 
> That simple time type could then trickle down as well: we could use 
> it everywhere in kernel code and limit the hodge-podge of ABI time 
> units to the syscall boundary. (and convert the internal time unit to 
> whatever ABI unit there is close to the syscall boundary)
> 
> There's a point where micro-optimized 32-bit support related 
> maintenance overhead (and the resulting loss of 
> robustness/flexibility) becomes too expensive IMO.

That's not a micro optimization, it's a massive performance hit if you
force those 32bit archs to do 64/32 all over the place.

Thanks,

	tglx
