Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab1GKIT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 04:19:28 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:37547 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301Ab1GKIT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 04:19:27 -0400
Date: Mon, 11 Jul 2011 10:19:13 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/3] x86, intel: Use cpu_update for Atom errata check
Message-ID: <20110711101913.652c07cc@endymion.delvare>
In-Reply-To: <1309996623-23108-2-git-send-email-andi@firstfloor.org>
References: <1309996623-23108-1-git-send-email-andi@firstfloor.org>
	<1309996623-23108-2-git-send-email-andi@firstfloor.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  6 Jul 2011 16:57:02 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Now that the cpu update level is available the Atom PSE errata
> check can use it directly without reading the MSR again.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/intel.c |   15 ++++-----------
>  1 files changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index ebedd27..6f75c45 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -55,17 +55,10 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
>  	 * need the microcode to have already been loaded... so if it is
>  	 * not, recommend a BIOS update and disable large pages.
>  	 */
> -	if (c->x86 == 6 && c->x86_model == 0x1c && c->x86_mask <= 2) {
> -		u32 ucode, junk;
> -
> -		wrmsr(MSR_IA32_UCODE_REV, 0, 0);
> -		sync_core();
> -		rdmsr(MSR_IA32_UCODE_REV, junk, ucode);
> -
> -		if (ucode < 0x20e) {
> -			printk(KERN_WARNING "Atom PSE erratum detected, BIOS microcode update recommended\n");
> -			clear_cpu_cap(c, X86_FEATURE_PSE);
> -		}
> +	if (c->x86 == 6 && c->x86_model == 0x1c && c->x86_mask <= 2 &&
> +	    c->microcode < 0x20e) {
> +		printk(KERN_WARNING "Atom PSE erratum detected, BIOS microcode update recommended\n");
> +		clear_cpu_cap(c, X86_FEATURE_PSE);
>  	}
>  
>  #ifdef CONFIG_X86_64

Looks good.

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
