Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab1JBPWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 11:22:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34170 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1JBPWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 11:22:10 -0400
Date: Sun, 2 Oct 2011 16:21:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] ARM: export rtc_lock for nvram driver
Message-ID: <20111002152155.GW11710@n2100.arm.linux.org.uk>
References: <1317496920-7764-1-git-send-email-arnd@arndb.de> <1317496920-7764-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317496920-7764-2-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 09:21:50PM +0200, Arnd Bergmann wrote:
> The rtc_lock is used by both the nvram and rtc drivers, so
> we need to export it if at least one of the two is built,
> not just for the rtc driver.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/kernel/time.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
> index cb634c3..5a54b95 100644
> --- a/arch/arm/kernel/time.c
> +++ b/arch/arm/kernel/time.c
> @@ -39,13 +39,11 @@
>   */
>  static struct sys_timer *system_timer;
>  
> -#if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE)
> +#if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE) || \
> +    defined(CONFIG_NVRAM) || defined(CONFIG_NVRAM_MODULE)
>  /* this needs a better home */
>  DEFINE_SPINLOCK(rtc_lock);
> -
> -#ifdef CONFIG_RTC_DRV_CMOS_MODULE
>  EXPORT_SYMBOL(rtc_lock);
> -#endif
>  #endif	/* pc-style 'CMOS' RTC support */

Some architectures always define this lock and export it irrespective of
the configuration.  Others define it, but never export it.  Some define
it but only export it for 32-bit builds.

One thing springs to mind here - why isn't there a symbol to enable the
presence of rtc_lock in the kernel?  A second related point is why is
this in arch code?

