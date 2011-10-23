Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab1JWLf7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 07:35:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56043 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab1JWLf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 07:35:58 -0400
Date: Sun, 23 Oct 2011 13:34:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111023113422.GD5156@elte.hu>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
 <20111007070842.GA27555@hostway.ca>
 <20111007174848.GA11011@hostway.ca>
 <1318010515.398.8.camel@twins>
 <20111008005035.GC22843@hostway.ca>
 <1318060551.8395.0.camel@twins>
 <20111012213555.GC24461@hostway.ca>
 <20111013232521.GA5654@hostway.ca>
 <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
 <20111020163609.16816e78@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020163609.16816e78@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> +#define cputime_zero			((__force cputime_t) 0ULL)
> +#define cputime64_zero			((__force cputime64_t) 0ULL)

Hm, why are these still needed?

This:

		if (*newval == cputime_zero)
			return;

Could be written as the much simpler:

		if (!*newval)
 			return;

with no ill effect that i can see.

Thanks,
	Ingo
