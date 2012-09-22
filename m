Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab2IVBKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 21:10:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41108 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab2IVBK1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 21:10:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Boyd <sboyd@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
References: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org>
Message-ID: <20120922011024.12878.64598@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [PATCH 00/10] Convert MSM to common clock framework
Date: Fri, 21 Sep 2012 18:10:24 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Boyd (2012-09-20 19:26:48)
> This patchset moves the existing MSM clock code and affected drivers to the
> common clock framework. A prerequisite of moving to the common clock
> framework is to use clk_prepare() and clk_enable() so the first
> few patches migrate drivers to that call (clk_prepare() is a no-op on MSM
> right now). It also removes some custom clock APIs that MSM provides
> and finally moves the proc_comm clock code to the common struct clock.
> 
> This patch series will be used as the foundation of the MSM 8660/8960
> clock code that I plan to send out soon.
> 
> These patches have one dependency on the devm_clk_register() function
> which I already posted to the list[1]. They're based on linux-next-20120917.
> 

Hi Stephen,

Thanks for sending this!  It is too much churn to take in for the 3.7
merge window.  As such I'll put reviewing this on my TODO list, but it
might wait until after the merge window settles down.


Regards,
Mike

> Stephen Boyd (10):
>   usb: otg: msm: Convert to clk_prepare/unprepare
>   msm_sdcc: Convert to clk_prepare/unprepare
>   msm: iommu: Convert to clk_prepare/unprepare
>   msm: iommu: Use clk_set_rate() instead of clk_set_min_rate()
>   ARM: msm: Remove custom clk_set_flags() API
>   ARM: msm: Remove custom clk_set_{max,min}_rate() API
>   ARM: msm: Remove clock-7x30.h include file
>   ARM: msm: Prepare clk_get() users in mach-msm for clock-pcom driver
>   ARM: msm: Make proc_comm clock control into a platform driver
>   ARM: msm: Migrate to common clock framework
> 
>  arch/arm/Kconfig                       |   1 +
>  arch/arm/mach-msm/Makefile             |  10 +-
>  arch/arm/mach-msm/board-halibut.c      |   2 +-
>  arch/arm/mach-msm/board-msm7x30.c      |   2 +-
>  arch/arm/mach-msm/board-qsd8x50.c      |   2 +-
>  arch/arm/mach-msm/board-trout-panel.c  |  19 ++--
>  arch/arm/mach-msm/board-trout.c        |   3 +-
>  arch/arm/mach-msm/clock-7x30.h         | 155 ------------------------------
>  arch/arm/mach-msm/clock-debug.c        | 130 --------------------------
>  arch/arm/mach-msm/clock-pcom.c         | 149 ++++++++++++++++++-----------
>  arch/arm/mach-msm/clock-pcom.h         |  31 +++---
>  arch/arm/mach-msm/clock.c              | 166 +--------------------------------
>  arch/arm/mach-msm/clock.h              |  51 +++-------
>  arch/arm/mach-msm/devices-msm7x00.c    |  12 ++-
>  arch/arm/mach-msm/devices-msm7x30.c    |  13 ++-
>  arch/arm/mach-msm/devices-qsd8x50.c    |  11 ++-
>  arch/arm/mach-msm/devices.h            |  15 +--
>  arch/arm/mach-msm/dma.c                |   5 +-
>  arch/arm/mach-msm/include/mach/board.h |   5 -
>  arch/arm/mach-msm/include/mach/clk.h   |   9 --
>  drivers/iommu/msm_iommu_dev.c          |  20 ++--
>  drivers/mmc/host/msm_sdcc.c            |  14 ++-
>  drivers/usb/otg/msm_otg.c              |  38 ++++----
>  23 files changed, 222 insertions(+), 641 deletions(-)
>  delete mode 100644 arch/arm/mach-msm/clock-7x30.h
>  delete mode 100644 arch/arm/mach-msm/clock-debug.c
> 
> [1] https://lkml.org/lkml/2012/9/19/28
> 
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
