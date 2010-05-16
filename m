Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab0EPW5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 18:57:25 -0400
Received: from www.tglx.de ([62.245.132.106]:54084 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab0EPW5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 18:57:24 -0400
Date: Mon, 17 May 2010 00:57:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jacob Pan <jacob.jun.pan@intel.com>
Subject: Re: [PATCH 4/8] x86/apbt: support more timer configurations on
 mrst
In-Reply-To: <1273873281-17489-5-git-send-email-jacob.jun.pan@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1005170052350.3368@localhost.localdomain>
References: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273873281-17489-5-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010, Jacob Pan wrote:
>  
> -int disable_apbt_percpu __cpuinitdata;
> -
>  static DEFINE_PER_CPU(struct apbt_dev, cpu_apbt_dev);
>  
>  #ifdef CONFIG_SMP
> @@ -204,9 +203,9 @@ static inline int __init setup_x86_mrst_timer(char *arg)
>  		return -EINVAL;
>  
>  	if (strcmp("apbt_only", arg) == 0)
> -		disable_apbt_percpu = 0;
> +		mrst_timer_options = MRST_TIMER_APBT_ONLY;
>  	else if (strcmp("lapic_and_apbt", arg) == 0)
> -		disable_apbt_percpu = 1;
> +		mrst_timer_options = MRST_TIMER_LAPIC_APBT;

  You changed the selection from disable_apbt_percpu to
  mrst_timer_options in the previous patch and now you change the
  command line options to take effect.

  That means the previous patch is not testable by itself. Neither is
  the current one, so there is no point in having separate
  patches. Please fold them into one.

Thanks,

	tglx
