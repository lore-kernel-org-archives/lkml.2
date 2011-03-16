Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab1CPKUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 06:20:49 -0400
Received: from fifo99.com ([67.223.236.141]:49986 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab1CPKUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 06:20:43 -0400
Subject: Re: [PATCH 2/3] msm: Peripheral Image Loader (PIL) driver
From: Daniel Walker <dwalker@fifo99.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
In-Reply-To: <1299732274-10742-3-git-send-email-sboyd@codeaurora.org>
References: <1299732274-10742-1-git-send-email-sboyd@codeaurora.org>
	 <1299732274-10742-3-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain
Date: Wed, 16 Mar 2011 03:20:19 -0700
Message-Id: <1300270820.13755.14.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 20:44 -0800, Stephen Boyd wrote:
> On 8660, the modem, dsp, and sensors peripherals require their
> firmware to be loaded into memory before they can be properly
> taken out of reset.
> 
> Drivers are expected to call pil_get() when they wish to load a
> peripheral. This will initiate multiple firmware_request()s for
> the metadata and image blobs for a peripheral. Once the image has
> been loaded into memory, it is validated and brought out of reset
> via the peripheral reset driver.

Why can't this be part of the generic firmware request API ?

> Change-Id: I041139464bbd3b646b82370ab540f40b0ac9af6b

Can't have Change-Id's ..

> Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/mach-msm/Kconfig                          |   13 +
>  arch/arm/mach-msm/Makefile                         |    2 +
>  arch/arm/mach-msm/include/mach/peripheral-loader.h |   23 +
>  arch/arm/mach-msm/peripheral-loader.c              |  402
> +++++++++++++++
>  arch/arm/mach-msm/peripheral-loader.h              |   38 ++
>  arch/arm/mach-msm/peripheral-reset.c               |  528
> ++++++++++++++++++++
>  6 files changed, 1006 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-msm/include/mach/peripheral-loader.h
>  create mode 100644 arch/arm/mach-msm/peripheral-loader.c
>  create mode 100644 arch/arm/mach-msm/peripheral-loader.h
>  create mode 100644 arch/arm/mach-msm/peripheral-reset.c
> 
> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index 997c5bd..25b73b0 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -210,4 +210,17 @@ config IOMMU_API
>  
>  config MSM_SCM
>         bool
> +
> +config MSM_PIL
> +       bool "Peripheral image loading (PIL)"
> +       select FW_LOADER
> +       select MSM_SCM
> +       depends on ARCH_MSM8X60
> +       help
> +         Some peripherals need to be loaded into memory before they
> can be
> +         brought out of reset.
> +
> +         Say yes to support these devices.
> +
> +

You shouldn't be adding anything like this to the Kconfig. To me if you
add stuff like this it's a big red flag.

I didn't review the rest sign it might be wasted effort on my part..

Daniel


