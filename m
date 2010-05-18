Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab0ERUzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:55:06 -0400
Received: from www.tglx.de ([62.245.132.106]:40252 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab0ERUzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:55:04 -0400
Date: Tue, 18 May 2010 22:54:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alek Du <alek.du@intel.com>,
       Alan Cox <alan@linux.intel.com>, Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH 1/2] v4 x86/mrst: add cpu type detection
In-Reply-To: <1274184166-17242-2-git-send-email-jacob.jun.pan@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1005182250460.3368@localhost.localdomain>
References: <1274184166-17242-1-git-send-email-jacob.jun.pan@linux.intel.com> <1274184166-17242-2-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010, Jacob Pan wrote:
>  
> +int mrst_identify_cpu(void)
> +{
> +	u32 mrst_cpu_chip;
> +
> +	if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 0x27)
> +		mrst_cpu_chip = MRST_CPU_CHIP_PENWELL;
> +	else if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 0x26)
> +		mrst_cpu_chip = MRST_CPU_CHIP_LINCROFT;
> +	else {
> +		pr_err("Unknown Moorestown CPU (%d:%d), default to Lincroft\n",
> +			boot_cpu_data.x86, boot_cpu_data.x86_model);
> +		mrst_cpu_chip = MRST_CPU_CHIP_LINCROFT;
> +	}
> +	pr_debug("Moorestown CPU %s identified\n",
> +		(mrst_cpu_chip == MRST_CPU_CHIP_LINCROFT) ?
> +		"Lincroft" : "Penwell");

  Do you really want a printk for each call ?

  Aside of that wouldn't it make more sense to do the chip
  identification only once from mrst_init() and cache the result and
  change mrst_identify_cpu()

int mrst_indetify_cpu(void)
{
	return mrst_cpu_chip;
}
EXPORT_SYMBOL_GPL(mrst_identify_cpu);

I think one of your earlier versions did that, but was not consistent
in it's behaviour.

Thanks,

	tglx
