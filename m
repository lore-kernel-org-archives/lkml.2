Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab2FNSCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 14:02:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48900 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962Ab2FNSCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 14:02:01 -0400
Date: Thu, 14 Jun 2012 20:02:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com,
        peterz@infradead.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/4] x86: Detect model/family mismatches for common
 microcode revision
Message-ID: <20120614180202.GD13629@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
	linux-kernel@vger.kernel.org, eranian@google.com,
	peterz@infradead.org, Andi Kleen <ak@linux.intel.com>
References: <1339618842-26636-1-git-send-email-andi@firstfloor.org>
 <1339618842-26636-5-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1339618842-26636-5-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 01:20:42PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> When the model/family don't match force the common microcode to zero.
> On such configurations there is no sane way to check for microcode
> revisions, so don't even try.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/common.c |   26 ++++++++++++++++++++------
>  1 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index cfc50e0..9642929 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1183,12 +1183,26 @@ __cpuinit void boot_update_min_microcode(struct cpuinfo_x86 *c)
>  	if (!boot_min_microcode) {
>  		boot_min_microcode = c->microcode;
>  		boot_cpu_data.microcode = c->microcode;
> -	} else if (c->microcode < boot_min_microcode) {
> -		pr_warn("CPU %d has lower microcode revision %x at boot than boot CPU (%x)\n",
> -			smp_processor_id(), 
> -			c->microcode,
> -			boot_min_microcode);
> -		boot_cpu_data.microcode = c->microcode;
> +	} else {
> +		if (c->microcode < boot_min_microcode) {
> +			pr_warn("CPU %d has lower microcode revision %x at boot than boot CPU (%x)\n",
> +				smp_processor_id(), 
> +				c->microcode,
> +				boot_min_microcode);
> +			boot_cpu_data.microcode = c->microcode;
> +		}
> +		/* Assume steppings have common microcode version numbers */
> +		if (c->x86 != boot_cpu_data.x86 || 


Apply? [y]es/[n]o/[e]dit/[v]iew patch/[a]ccept all y
Applying: x86: Detect model/family mismatches for common microcode revision
/home/boris/kernel/.git/rebase-apply/patch:22: trailing whitespace.
                                smp_processor_id(), 
/home/boris/kernel/.git/rebase-apply/patch:28: trailing whitespace.
                if (c->x86 != boot_cpu_data.x86 || 
warning: 2 lines add whitespace errors.

-- 
Regards/Gruss,
Boris.
