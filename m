Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab1GAQOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 12:14:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40938 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756772Ab1GAQOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:14:02 -0400
Date: Fri, 1 Jul 2011 18:13:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Petr Tesarik <ptesarik@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary
 physical addresses
Message-ID: <20110701161345.GA29775@elte.hu>
References: <201106171038.25988.ptesarik@suse.cz>
 <20110701144129.GA10052@infradead.org>
 <20110701144641.GA23272@elte.hu>
 <201107011654.06651.ptesarik@suse.cz>
 <20110701153634.GA27407@elte.hu>
 <4E0DEF2C.3040504@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0DEF2C.3040504@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 07/01/2011 08:36 AM, Ingo Molnar wrote:
> > 
> > So we could kill multiple birds with the same stone here:
> > 
> >  - remove various ugly uses of /dev/mem (including the rootkit usage),
> >    with or without strict-devmem
> > 
> >  - extending it to above-4G for inspection purposes
> > 
> >  - allowing to kill /dev/mem access runtime similar to the 
> >    disable_modules lock-down killswitch, for the so inclined.
> > 
> > Would you be interested in modifying your patch-set in such a 
> > fashion?
> > 
> 
> There is another use that I have looked at, as well: for testing 
> purposes, it would be extremely good to be able to dirty and/or 
> flush an arbitrary physical cache line for testing purposes.
> 
> This is very very similar to /dev/mem usage -- access to an 
> arbitrary chunk of memory -- and a fully enabled /dev/mem can of 
> course support this use (just mmap the page with the relevant cache 
> line).  However, it could also be a separate device which could 
> have looser permissions than /dev/mem; or a set of ioctls on 
> /dev/mem with a separate kill switch, because no data would ever be 
> have modified or returned to user space.
> 
> Either way, though, we found that it would share a lot of code with 
> the /dev/mem implementation, and as such fixing up the underlying 
> machinery is the sanest way to upstream this.

To me that cache flush thing sounds obscure (but still useful) enough 
to justify a new ioctl over /dev/mem.

Not sure it even needs a killswitch, unless there's some real 
security problem related to it.

Thanks,

	Ingo
