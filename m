Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab2LPR5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:57:25 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49994 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab2LPR5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:57:24 -0500
Date: Sun, 16 Dec 2012 18:57:22 +0100
From: Borislav Petkov <bp@alien8.de>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Yinghai Lu <yinghai@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v3 04/10] x86/microcode_core_early.c: Define interfaces
 for early loading ucode
Message-ID: <20121216175722.GA14678@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Fenghua Yu <fenghua.yu@intel.com>, H Peter Anvin <hpa@zytor.com>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	Asit K Mallick <asit.k.mallick@intel.com>,
	Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Borislav Petkov <borislav.petkov@amd.com>,
	Yinghai Lu <yinghai@kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
References: <1355654609-16800-1-git-send-email-fenghua.yu@intel.com>
 <1355654609-16800-5-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355654609-16800-5-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 02:43:23AM -0800, Fenghua Yu wrote:
> +#define QCHAR(a, b, c, d) ((a) + ((b) << 8) + ((c) << 16) + ((d) << 24))
> +#define CPUID_INTEL1 QCHAR('G', 'e', 'n', 'u')
> +#define CPUID_INTEL2 QCHAR('i', 'n', 'e', 'I')
> +#define CPUID_INTEL3 QCHAR('n', 't', 'e', 'l')
> +#define CPUID_AMD1 QCHAR('A', 'u', 't', 'h')
> +#define CPUID_AMD2 QCHAR('e', 'n', 't', 'i')
> +#define CPUID_AMD3 QCHAR('c', 'A', 'M', 'D')
> +
> +#define CPUID_IS(a, b, c) (!((ebx ^ (a))|(edx ^ (b))|(ecx ^ (c))))

What, this macro is relying on external variable names and doesn't have
them as its own macro arguments? Why? This is really fragile and very
much prone to errors.

What's wrong with doing:

#define CPUID_IS(a, b, c, ebx, ecx, edx) (!(((ebx) ^ (a))|((edx) ^ (b))|((ecx) ^ (c))))

?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
