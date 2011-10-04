Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab1JDKoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 06:44:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:25317 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755895Ab1JDKoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 06:44:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,484,1312182000"; 
   d="scan'208";a="74283573"
Date: Tue, 4 Oct 2011 12:47:13 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Balaji T K <balajitk@ti.com>,
        Hemanth V <hemanthv@ti.com>, Bill Gatliff <bgat@billgatliff.com>
Subject: Re: [PATCH 22/30] mfd: build twl6030 only on omap2
Message-ID: <20111004104713.GY4118@sortiz-mobl>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <1317566760-25681-23-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317566760-25681-23-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Sun, Oct 02, 2011 at 04:45:52PM +0200, Arnd Bergmann wrote:
> We can only have one pwm driver built into the kernel,
I seem to remember that Bill Gatliff was working on a PWM subsystem that would
get rid of the current pwm.h ugliness. Do we have any updates on this one ?

The patch below looks like a hack to me, trying to work around the current
lack of such subsystem.

Cheers,
Samuel.

> so make sure
> that this one is only available on omap2 to avoid conflicts with
> pwm drivers of other platforms.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Cc: Balaji T K <balajitk@ti.com>
> Cc: Hemanth V <hemanthv@ti.com>
> ---
>  drivers/mfd/Kconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 48cce35..26bebe8 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -256,8 +256,8 @@ config MFD_TWL4030_AUDIO
>  	default n
>  
>  config TWL6030_PWM
> -	tristate "TWL6030 PWM (Pulse Width Modulator) Support"
> -	depends on TWL4030_CORE
> +	bool "TWL6030 PWM (Pulse Width Modulator) Support"
> +	depends on TWL4030_CORE && ARCH_OMAP2
>  	select HAVE_PWM
>  	default n
>  	help
> -- 
> 1.7.5.4
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
