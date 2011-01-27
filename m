Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab1A0MsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 07:48:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60435 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab1A0MsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 07:48:11 -0500
Date: Thu, 27 Jan 2011 13:47:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 4/4] x86, amd: Support L3 Cache Partitioning on AMD
 family 0x15 CPUs
Message-ID: <20110127124756.GA16094@elte.hu>
References: <20110126105637.GA27809@elte.hu>
 <1296061716-185599-1-git-send-email-hans.rosenfeld@amd.com>
 <20110126205608.GA14361@elte.hu>
 <20110127115017.GH877@escobedo.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110127115017.GH877@escobedo.osrc.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.8 required=5.9 tests=BAYES_00,SUBJECT_FUZZY_TION autolearn=no SpamAssassin version=3.2.5
	0.2 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:

> On Wed, Jan 26, 2011 at 03:56:08PM -0500, Ingo Molnar wrote:
> > * Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:
> > > +#ifdef CONFIG_SMP
> > > +int amd_get_subcaches(int cpu)
> > 
> > Well, sprinkling it with CONFIG_SMP is pretty ugly. Also, there's no fundamental 
> > reason why this shouldnt work with UP. Yes, it makes most sense on SMP but such code 
> > should be SMP-invariant.
> 
> True, it is pretty ugly. And while the feature is pretty useless for UP,
> it would still work for compute_unit_id 0 in that case.
> 
> The problem is that cpuinfo_x86.compute_unit_id etc. don't exist unless
> CONFIG_SMP is enabled. I don't think there is any reason why this should
> be that way, but changing this just for this particular L3 feature seems
> too intrusive. Do you really want me to do that?

All the CONFIG_X86_HT #ifdefs in arch/x86/kernel/cpu/amd.c look pretty ugly too - 
and it's not really a properly modularized solution.

We generally want to unify the SMP and UP kernels as much as possible. 'CONFIG_SMP' 
is not really a property of the hardware, it's a property of the software.

If some topology information should be excluded then it can already be done by 
turning off CONFIG_CPU_SUP_AMD under CONFIG_EXPERT.

Thanks,

	Ingo
