Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037Ab1BRAhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 19:37:55 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33080 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab1BRAhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 19:37:50 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6260"; a="74925219"
Subject: Re: [PATCH] msm: add single-wire serial bus interface (SSBI) driver
From: Daniel Walker <dwalker@codeaurora.org>
To: Kenneth Heitke <kheitke@codeaurora.org>
Cc: davidb@codeaurora.org, dima@android.com, tsoni@codeaurora.org,
        linux-arm-msm@vger.kernel.org,
        "open list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
In-Reply-To: <1297989299-27320-1-git-send-email-kheitke@codeaurora.org>
References: <1297989299-27320-1-git-send-email-kheitke@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 16:37:12 -0800
Message-ID: <1297989432.9680.50.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 17:34 -0700, Kenneth Heitke wrote:
> SSBI is the Qualcomm single-wire serial bus interface used to connect
> the MSM devices to the PMIC and other devices.
> 
> Since SSBI only supports a single slave, the driver gets the name of the
> slave device passed in from the board file through the master device's
> platform data.
> 
> SSBI registers pretty early (postcore), so that the PMIC can come up
> before the board init. This is useful if the board init requires the
> use of gpios that are connected through the PMIC.
> 
> Based on a patch by Dima Zavin <dima@android.com> that can be found at:
> http://android.git.kernel.org/?p=kernel/msm.git;a=commitdiff;h=eb060bac4
> 
> This patch adds PMIC Arbiter support for the MSM8660. The PMIC Arbiter
> is a hardware wrapper around the SSBI 2.0 controller that is designed to
> overcome concurrency issues and security limitations.  A controller_type
> field is added to the platform data to specify the type of the SSBI
> controller (1.0, 2.0, or PMIC Arbiter).
> 
> Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
> ---
>  arch/arm/mach-msm/Kconfig                 |   16 ++
>  arch/arm/mach-msm/Makefile                |    1 +
>  arch/arm/mach-msm/include/mach/msm_ssbi.h |   38 +++
>  arch/arm/mach-msm/ssbi.c                  |  376 +++++++++++++++++++++++++++++
>  4 files changed, 431 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-msm/include/mach/msm_ssbi.h
>  create mode 100644 arch/arm/mach-msm/ssbi.c
> 
> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index 997c5bd..f35c3d9 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -24,6 +24,7 @@ config ARCH_MSM7X30
>  	select MSM_GPIOMUX
>  	select MSM_PROC_COMM
>  	select HAS_MSM_DEBUG_UART_PHYS
> +	select HAS_MSM_SSBI
>  
>  config ARCH_QSD8X50
>  	bool "QSD8X50"
> @@ -46,6 +47,7 @@ config ARCH_MSM8X60
>  	select MSM_V2_TLMM
>  	select MSM_GPIOMUX
>  	select MSM_SCM if SMP
> +	select HAS_MSM_SSBI
>  
>  config ARCH_MSM8960
>  	bool "MSM8960"
> @@ -56,6 +58,7 @@ config ARCH_MSM8960
>  	select MSM_V2_TLMM
>  	select MSM_GPIOMUX
>  	select MSM_SCM if SMP
> +	select HAS_MSM_SSBI
>  
>  endchoice
>  
> @@ -190,6 +193,16 @@ choice
>  endchoice
>  endif
>  
> +config MSM_SSBI
> +	bool "Qualcomm Single-wire Serial Bus Interface (SSBI)"
> +	depends on HAS_MSM_SSBI
> +	help
> +	  If you say yes to this option, support will be included for the
> +	  built-in SSBI interface on Qualcomm MSM family processors.
> +
> +	  This is required for communicating with Qualcomm PMICs and
> +	  other devices that have the SSBI interface.
> +

Can you put this in drivers/ this doesn't looks like it need to be here.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

