Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0EZTJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:09:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754632Ab0EZTJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:09:53 -0400
Date: Wed, 26 May 2010 12:09:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rabin VINCENT <rabin.vincent@stericsson.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Virupax SADASHIVPETIMATH 
	<virupax.sadashivpetimath@stericsson.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH] rtc: AB8500 RTC driver
Message-Id: <20100526120904.00fe134c.akpm@linux-foundation.org>
In-Reply-To: <20100526121150.GA17197@bnru02.bnr.st.com>
References: <1274453796-9141-1-git-send-email-rabin.vincent@stericsson.com>
	<20100525135159.166d91c6.akpm@linux-foundation.org>
	<20100526121150.GA17197@bnru02.bnr.st.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 17:41:51 +0530
Rabin VINCENT <rabin.vincent@stericsson.com> wrote:

> All your other comments should be addressed in the updated patch below.
> Thanks.

<generates the diff>


> diff -puN drivers/rtc/Kconfig~rtc-ab8500-rtc-driver-update drivers/rtc/Kconfig
> --- a/drivers/rtc/Kconfig~rtc-ab8500-rtc-driver-update
> +++ a/drivers/rtc/Kconfig
> @@ -614,7 +614,6 @@ config RTC_DRV_AB3100
>  config RTC_DRV_AB8500
>  	tristate "ST-Ericsson AB8500 RTC"
>  	depends on AB8500_CORE
> -	default y
>  	help
>  	  Select this to enable the ST-Ericsson AB8500 power management IC RTC
>  	  support. This chip contains a battery- and capacitor-backed RTC.
> diff -puN drivers/rtc/rtc-ab8500.c~rtc-ab8500-rtc-driver-update drivers/rtc/rtc-ab8500.c
> --- a/drivers/rtc/rtc-ab8500.c~rtc-ab8500-rtc-driver-update
> +++ a/drivers/rtc/rtc-ab8500.c
> @@ -46,16 +46,25 @@
>  #define COUNTS_PER_SEC			(0xF000 / 60)
>  #define AB8500_RTC_EPOCH		2000
>  
> +static const unsigned long ab8500_rtc_time_regs[] = {
> +	AB8500_RTC_WATCH_TMIN_HI_REG, AB8500_RTC_WATCH_TMIN_MID_REG,
> +	AB8500_RTC_WATCH_TMIN_LOW_REG, AB8500_RTC_WATCH_TSECHI_REG,
> +	AB8500_RTC_WATCH_TSECMID_REG
> +};
> +
> +static const unsigned long ab8500_rtc_alarm_regs[] = {
> +	AB8500_RTC_ALRM_MIN_HI_REG, AB8500_RTC_ALRM_MIN_MID_REG,
> +	AB8500_RTC_ALRM_MIN_LOW_REG
> +};

Well, it wasn't necessary to move these into file-global scope.  It
would be nicer to leave them in function scope, really.  I was just
pointing out that the `static' was missing, although unnecessary due to
compiler magic.


