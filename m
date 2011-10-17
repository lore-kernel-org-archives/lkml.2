Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab1JQVdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:33:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33121 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab1JQVdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:33:20 -0400
Date: Mon, 17 Oct 2011 23:31:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111017213143.GA8502@elte.hu>
References: <20111008005035.GC22843@hostway.ca>
 <1318060551.8395.0.camel@twins>
 <20111012213555.GC24461@hostway.ca>
 <20111013232521.GA5654@hostway.ca>
 <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
 <20111017045806.GA11561@elte.hu>
 <alpine.LFD.2.02.1110171101250.3240@ionos>
 <20111017184916.GA5545@elte.hu>
 <4E9C917B.2050802@zytor.com>
 <20111017211951.GA8043@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017211951.GA8043@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> If we used a scalar 64-bit form for all kernel internal time 
> representations:
> 
> 	s64	nsecs;
> 
> then conversions back to timespec/timeval would involve dividing 
> this 64-bit value with 1000000000 or 1000000.
> 
> Is there no faster approximation for those than bit by bit?
> 
> In particular we could try something like:
> 
> 	(high*2^32 + low)/1e9 ~==  ( high * (2^64/1e9) ) / 2^32
> 
> ... which reduces it all to a 64-bit multiplication (or two 32-bit 
> multiplications) with a known constant, at the cost of 1 nsec 
> imprecision of the result - but that's an OK approximation in my 
> opinion.

Hm, no, the numeric error would be in the *seconds* result, and would 
be 0-3 seconds - which is obviously not acceptable.

Thanks,

	Ingo
