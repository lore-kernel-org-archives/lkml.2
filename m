Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab1EPWCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 18:02:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:38457 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab1EPWCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 18:02:14 -0400
Date: Tue, 17 May 2011 00:01:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fenghua Yu <fenghua.yu@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] x86/kernel/common.c: Disable SMEP by kernel option
 nosmep
In-Reply-To: <1305581685-5144-5-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.LFD.2.02.1105162359500.3078@ionos>
References: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com> <1305581685-5144-5-git-send-email-fenghua.yu@intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 May 2011, Fenghua Yu wrote:
> +/*
> + * If SMEP is supported by the processor, SMEP has been enabled in CR4 earlier.
> + * But if kernel option "nosmep" is given, we disable SMEP here.
> + */
> +static __init void config_smep(struct cpuinfo_x86 *c)
> +{
> +	if (cpu_has(c, X86_FEATURE_SMEP) && unlikely(disable_smep)) {

That unlikely() is completely pointless. This is init code and inside
of a if() already. Where is the point ?

> +		setup_clear_cpu_cap(X86_FEATURE_SMEP);
> +		clear_in_cr4(X86_CR4_SMEP);
> +	}
> +}

Thanks,

	tglx
