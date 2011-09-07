Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab1IGRkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:40:17 -0400
Received: from unicorn.mansr.com ([78.86.181.103]:49493 "EHLO
	unicorn.mansr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab1IGRkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:40:15 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dave Martin <dave.martin@linaro.org>,
        John Ogness <john.ogness@linutronix.de>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: alignment: setup alignment handler earlier
References: <87ehzstr07.fsf@vostro.fn.ogness.net>
	<20110907144016.GA30719@e102109-lin.cambridge.arm.com>
	<20110907162857.GB2327@n2100.arm.linux.org.uk>
	<yw1xipp4cnis.fsf@unicorn.mansr.com>
	<20110907170452.GC2327@n2100.arm.linux.org.uk>
Date: Wed, 07 Sep 2011 18:40:11 +0100
In-Reply-To: <20110907170452.GC2327@n2100.arm.linux.org.uk> (Russell King's
	message of "Wed, 7 Sep 2011 18:04:52 +0100")
Message-ID: <yw1xehzsckuc.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> On Wed, Sep 07, 2011 at 05:42:19PM +0100, Måns Rullgård wrote:
>> There are such instructions (ldrd, ldm), but gcc will not emit those
>> unless the address is known to be aligned.  For ARMv6 and later, gcc 4.6
>> *will* emit potentially unaligned ldr and ldrh since these very clearly
>> allow an unaligned address and are faster than the alternatives in all
>> implementations to date.  This is unless strict alignment checking is
>> explicitly enabled, which unfortunately the Linux kernel does for no
>> apparent reason at all.
>
> "no apparant reason at all" heh.  The reason is to keep the code
> simple and free from bugs.

Some people, myself included, consider the current behaviour a bug.

> To do otherwise means that each of the CPU files needs to be littered
> with ifdefs to deal with the alignment fault configuration, of which
> there are 16 of them (ignoring v6 and v7.)
>
> If you think code maintanence of the same thing in 16 places is efficient
> then I guess there is "no apparant reason".  I beg to differ, being one
> of those folk who have had to edit 18 different places several times.
>
> So no, I do not intend to move this:
>
> #ifdef CONFIG_ALIGNMENT_TRAP
>         orr     r0, r0, #CR_A
> #else
>         bic     r0, r0, #CR_A
> #endif
>
> into 16 separate places in the kernel.

So change that condition to also depend on !CPU_V6 && !CPU_V7 or
something equivalent.

-- 
Måns Rullgård
mans@mansr.com
