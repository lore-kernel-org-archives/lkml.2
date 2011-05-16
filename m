Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab1EPQja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:39:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:14079 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab1EPQj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:39:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,375,1301900400"; 
   d="scan'208";a="436931465"
Subject: Re: [PATCH] dw_dmac: Replace subsys_init() with arch_initcall()
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: dan.j.williams@intel.com, linus.walleij@linaro.org,
        armando.visconti@st.com, shiraz.hashim@st.com, viresh.linux@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <f06f05e982c6182565a7fee1f7d6396cae895133.1305521318.git.viresh.kumar@st.com>
References: <f06f05e982c6182565a7fee1f7d6396cae895133.1305521318.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 21:36:33 +0530
Message-ID: <1305561993.28926.73.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 10:20 +0530, Viresh Kumar wrote:
> In some cases users of dw_dmac, amba-pl022, are initialized before dw_dmac, and
> if they try to use dw_dmac, they simply fail. So its better we register init()
> routine of driver using arch_initcall() instead of subsys_init(), so that dma
> driver is available at the earliest possible.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/dma/dw_dmac.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 54d72a8..4b580e7 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1566,7 +1566,7 @@ static int __init dw_init(void)
>  {
>  	return platform_driver_probe(&dw_driver, dw_probe);
>  }
> -subsys_initcall(dw_init);
> +arch_initcall(dw_init);
arch_init is usually kept for subystem initialization.
Why cant you move the amba-pl022 init to module_init, that should take
care of this.

-- 
~Vinod

