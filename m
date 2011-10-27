Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab1J0HhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 03:37:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43576 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab1J0HhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 03:37:09 -0400
Date: Thu, 27 Oct 2011 09:35:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/3] Add Numachip APIC support
Message-ID: <20111027073533.GE15923@elte.hu>
References: <1319609230-18897-1-git-send-email-daniel@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319609230-18897-1-git-send-email-daniel@numascale-asia.com>
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


* Daniel J Blueman <daniel@numascale-asia.com> wrote:

> From: Steffen Persvold <sp@numascale.com>
> 
> From: Steffen Persvold <sp@numascale.com>

Please fix these duplicate lines.

> Add support for Numascale's NumaChip APIC mapping mechanism to allow
> booting more than ~168 cores.
> 
> v2:
>  - [Steffen] enumerate only accessible northbridges
>  - [Daniel] rediffed and validated against 3.1-rc10
> 
> Signed-off-by: Steffen Persvold <sp@numascale.com>
> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>

> +/*
> + * Set up the logical destination ID.
> + *
> + * Intel recommends to set DFR, LDR and TPR before enabling
> + * an APIC. See e.g. "AP-388 82489DX User's Manual" (Intel
> + * document number 292116).
> + */
> +static void numachip_init_apic_ldr(void)
> +{
> +	unsigned long val;
> +	unsigned long num, id;
> +
> +	num = smp_processor_id();
> +	id = 1UL << num;
> +	apic_write(APIC_DFR, APIC_DFR_FLAT);
> +	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
> +	val |= SET_APIC_LOGICAL_ID(id);
> +	apic_write(APIC_LDR, val);
> +}

Looks like a flat out copy of arch/x86/kernel/apic/apic_flat_64.c's 
flat_init_apic_ldr(). Please make that function global instead of 
copying it.

Also, when you copy another file to derive your new code from you 
*MUST* refer in your copyright notices to the code you copied from.

Thanks,

	Ingo
