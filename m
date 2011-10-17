Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab1JQF3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 01:29:39 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:50691 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753087Ab1JQF3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 01:29:37 -0400
Message-ID: <4E9BBCEB.9090204@st.com>
Date: Mon, 17 Oct 2011 10:58:11 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jaswinder.singh@linaro.org" <jaswinder.singh@linaro.org>,
        "21cnbao@gmail.com" <21cnbao@gmail.com>,
        "rmk@arm.linux.org.uk" <rmk@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Shawn Guo <shawn.guo@freescale.com>, Yong Wang <yong.y.wang@intel.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Boojin Kim <boojin.kim@samsung.com>, Barry Song <Baohua.Song@csr.com>
Subject: Re: [PATCH 02/10] dmaengine: move drivers to dma_transfer_direction
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com> <1318570705-17595-3-git-send-email-vinod.koul@intel.com>
In-Reply-To: <1318570705-17595-3-git-send-email-vinod.koul@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 11:08 AM, Vinod Koul wrote:
> From: Vinod Koul <vinod.koul@linux.intel.com>
> 
> Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
> Cc: Jassi Brar <jaswinder.singh@linaro.org>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>
> Cc: H Hartley Sweeten <hartleys@visionengravers.com>
> Cc: Li Yang <leoli@freescale.com>
> Cc: Zhang Wei <zw@zh-kernel.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Shawn Guo <shawn.guo@freescale.com>
> Cc: Yong Wang <yong.y.wang@intel.com>
> Cc: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
> Cc: Boojin Kim <boojin.kim@samsung.com>
> Cc: Barry Song <Baohua.Song@csr.com>
> ---
>  arch/arm/mach-ep93xx/include/mach/dma.h        |    6 ++--
>  arch/arm/plat-nomadik/include/plat/ste_dma40.h |    4 +-
>  drivers/dma/amba-pl08x.c                       |   24 +++++++++++-----------
>  drivers/dma/at_hdmac.c                         |   22 ++++++++++----------
>  drivers/dma/coh901318.c                        |   12 +++++-----
>  drivers/dma/coh901318_lli.c                    |   23 ++++++++++-----------
>  drivers/dma/coh901318_lli.h                    |    4 +-
>  drivers/dma/dw_dmac.c                          |   14 ++++++------
>  drivers/dma/ep93xx_dma.c                       |   22 ++++++++++----------
>  drivers/dma/fsldma.c                           |    4 +-
>  drivers/dma/imx-dma.c                          |   10 ++++----
>  drivers/dma/imx-sdma.c                         |   10 ++++----
>  drivers/dma/intel_mid_dma.c                    |   14 ++++++------
>  drivers/dma/intel_mid_dma_regs.h               |    2 +-
>  drivers/dma/ipu/ipu_idmac.c                    |    4 +-
>  drivers/dma/mxs-dma.c                          |    8 +++---
>  drivers/dma/pch_dma.c                          |   12 +++++-----
>  drivers/dma/pl330.c                            |   18 ++++++++--------
>  drivers/dma/shdma.c                            |   25 +++++++++++------------
>  drivers/dma/ste_dma40.c                        |   26 ++++++++++++------------
>  drivers/dma/timb_dma.c                         |   18 ++++++++--------
>  drivers/dma/txx9dmac.c                         |   12 +++++-----
>  include/linux/amba/pl08x.h                     |    4 +-
>  include/linux/dw_dmac.h                        |    2 +-
>  include/linux/sh_dma.h                         |    2 +-
>  25 files changed, 150 insertions(+), 152 deletions(-)

For amba-pl08x and dw_dmac:

Acked-by: Viresh Kumar <viresh.kumar@st.com>

Can you please add something in the commit message, to explain why is it done.

-- 
viresh
