Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354Ab2IGDRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 23:17:23 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53316 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab2IGDRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 23:17:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6827"; a="231592878"
Message-ID: <50496741.8000305@codeaurora.org>
Date: Thu, 06 Sep 2012 20:17:21 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Rohit Vaswani <rvaswani@codeaurora.org>
CC: Olof Johansson <olof@lixom.net>, David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCHv2 2/2] msm: io: Change the default static iomappings to
 be shared
References: <CAOesGMgC2OxEs-wGRQku-GeoiaO2Wa_dZ2AuwnKd3Nze4gknqQ@mail.gmail.com> <1346951799-9415-1-git-send-email-rvaswani@codeaurora.org>
In-Reply-To: <1346951799-9415-1-git-send-email-rvaswani@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/12 10:16, Rohit Vaswani wrote:
>  static struct map_desc msm_io_desc[] __initdata = {
> -	MSM_DEVICE(VIC),
> -	MSM_CHIP_DEVICE(CSR, MSM7X00),
> -	MSM_DEVICE(DMOV),
> -	MSM_CHIP_DEVICE(GPIO1, MSM7X00),
> -	MSM_CHIP_DEVICE(GPIO2, MSM7X00),
> -	MSM_DEVICE(CLK_CTL),
> +	MSM_DEVICE_TYPE(VIC, MT_DEVICE_NONSHARED),
> +	MSM_CHIP_DEVICE_TYPE(CSR, MSM7X00, MT_DEVICE_NONSHARED),
> +	MSM_DEVICE_TYPE(DMOV, MT_DEVICE_NONSHARED),
> +	MSM_CHIP_DEVICE_TYPE(GPIO1, MSM7X00, MT_DEVICE_NONSHARED),
> +	MSM_CHIP_DEVICE_TYPE(GPIO2, MSM7X00, MT_DEVICE_NONSHARED),
> +	MSM_CHIP_DEVICE_TYPE(CLK_CTL, MSM7X00, MT_DEVICE_NONSHARED),

This one is supposed to be MSM_DEVICE_TYPE.

Please squash this in:

diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index 35d6926..d908a37 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -52,7 +52,7 @@ static struct map_desc msm_io_desc[] __initdata = {
        MSM_DEVICE_TYPE(DMOV, MT_DEVICE_NONSHARED),
        MSM_CHIP_DEVICE_TYPE(GPIO1, MSM7X00, MT_DEVICE_NONSHARED),
        MSM_CHIP_DEVICE_TYPE(GPIO2, MSM7X00, MT_DEVICE_NONSHARED),
-       MSM_CHIP_DEVICE_TYPE(CLK_CTL, MSM7X00, MT_DEVICE_NONSHARED),
+       MSM_DEVICE_TYPE(CLK_CTL, MT_DEVICE_NONSHARED),
 #if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
        defined(CONFIG_DEBUG_MSM_UART3)
        MSM_DEVICE_TYPE(DEBUG_UART, MT_DEVICE_NONSHARED),

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

