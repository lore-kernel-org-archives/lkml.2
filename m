Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab1EUKnY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 06:43:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39381 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab1EUKnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 06:43:22 -0400
Date: Sat, 21 May 2011 12:43:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/smep] x86, cpu: Enable/disable Supervisor Mode
 Execution Protection
Message-ID: <20110521104310.GC26447@elte.hu>
References: <1305157865-31727-1-git-send-email-fenghua.yu@intel.com>
 <tip-de5397ad5b9ad22e2401c4dacdf1bb3b19c05679@git.kernel.org>
 <4DD6D965.4010606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD6D965.4010606@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> > +static __init void setup_smep(struct cpuinfo_x86 *c)
> > +{
> > +	if (cpu_has(c, X86_FEATURE_SMEP)) {
> > +		if (unlikely(disable_smep)) {
> > +			setup_clear_cpu_cap(X86_FEATURE_SMEP);
> > +			clear_in_cr4(X86_CR4_SMEP);
> > +		} else
> > +			set_in_cr4(X86_CR4_SMEP);
> > +	}
> > +}
> 
> should be __cpuinit for this function.
> 
> otherwise got:
> 
> WARNING: arch/x86/built-in.o(.cpuinit.text+0x1b10): Section mismatch in reference from the function identify_cpu() to the function .init.text:setup_smep()
> The function __cpuinit identify_cpu() references
> a function __init setup_smep().
> If setup_smep is only used by identify_cpu then
> annotate setup_smep with a matching annotation.

Yeah, indeed, and it might in fact crash with certain .config's. Mind sending a 
tested patch?

Thanks,

	Ingo
