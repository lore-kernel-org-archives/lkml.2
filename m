Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab0EPWwI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 18:52:08 -0400
Received: from www.tglx.de ([62.245.132.106]:34581 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657Ab0EPWwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 18:52:04 -0400
Date: Mon, 17 May 2010 00:51:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 3/8] x86/mrst: add more timer options to include
 Medfield
In-Reply-To: <1273873281-17489-4-git-send-email-jacob.jun.pan@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1005170048420.3368@localhost.localdomain>
References: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273873281-17489-4-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010, Jacob Pan wrote:
>  
> -/*
> - * the secondary clock in Moorestown can be APBT or LAPIC clock, default to
> - * APBT but cmdline option can also override it.
> - */
>  static void __cpuinit mrst_setup_secondary_clock(void)
>  {
> -	/* restore default lapic clock if disabled by cmdline */
> -	if (disable_apbt_percpu)
> -		return setup_secondary_APIC_clock();
> +	if ((mrst_timer_options == MRST_TIMER_APBT_ONLY))
> +		return apbt_setup_secondary_clock();

  Did you compile this ?

> +	if (cpu_has(&current_cpu_data, X86_FEATURE_ARAT)
> +		||  (mrst_timer_options == MRST_TIMER_LAPIC_APBT)) {
> +		pr_info("using lapic timers for secondary clock\n");
> +		setup_secondary_APIC_clock();
> +		return;
> +	}

  As I said before, this function sucks. The decision logic is just
  obscure. It's not rocket science to make it understandable.

>  	apbt_setup_secondary_clock();
>  }

Thanks,

	tglx
