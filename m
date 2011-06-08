Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab1FHRxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 13:53:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43032 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1FHRxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 13:53:19 -0400
Date: Wed, 8 Jun 2011 10:52:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86 idle: APM requires pm_idle/default_idle
 unconditionally when a module
Message-Id: <20110608105255.55afe16c.randy.dunlap@oracle.com>
In-Reply-To: <1307537486-19317-1-git-send-email-apw@canonical.com>
References: <1307537486-19317-1-git-send-email-apw@canonical.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090205.4DEFB703.0082:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  8 Jun 2011 13:51:26 +0100 Andy Whitcroft wrote:

> The commit below removed the export for pm_idle/default_idle unless the
> apm module was modularised and CONFIG_APM_CPU_IDLE was set.  The apm
> module uses pm_idle/default_idle unconditionally, CONFIG_APM_CPU_IDLE
> only affects the bios idle threshold.  Adjust the export accordingly.
> 
>     commit 06ae40ce073daf233607a3c54a489f2c1e44683e
>     Author: Len Brown <len.brown@intel.com>
>     Date:   Fri Apr 1 15:28:09 2011 -0400
> 
> 	x86 idle: EXPORT_SYMBOL(default_idle, pm_idle) only when APM demands it
> 
> Signed-off-by: Andy Whitcroft <apw@canonical.com>

Acked-by: Randy Dunlap <randy.dunalp@oracle.com>

Thanks.

> ---
>  arch/x86/kernel/process.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 2e4928d..b8265d0 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -337,7 +337,7 @@ EXPORT_SYMBOL(boot_option_idle_override);
>   * Powermanagement idle function, if any..
>   */
>  void (*pm_idle)(void);
> -#if defined(CONFIG_APM_MODULE) && defined(CONFIG_APM_CPU_IDLE)
> +#if defined(CONFIG_APM_MODULE)
>  EXPORT_SYMBOL(pm_idle);
>  #endif
>  
> @@ -399,7 +399,7 @@ void default_idle(void)
>  		cpu_relax();
>  	}
>  }
> -#if defined(CONFIG_APM_MODULE) && defined(CONFIG_APM_CPU_IDLE)
> +#if defined(CONFIG_APM_MODULE)
>  EXPORT_SYMBOL(default_idle);
>  #endif
>  
> -- 

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
