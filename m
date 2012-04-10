Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab2DJDjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 23:39:36 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:36512 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758477Ab2DJDjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 23:39:15 -0400
Message-ID: <4F83AAFD.1030507@st.com>
Date: Tue, 10 Apr 2012 09:07:33 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Alim Akhtar <alim.akhtar@gmail.com>
Subject: Re: [PATCH 1/2] dma/amba-pl08x: check for terminal count status only
References: <1334004801-20185-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1334004801-20185-1-git-send-email-linus.walleij@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/2012 2:23 AM, Linus Walleij wrote:
> For some reason I can't figure out we're reading the PL080_INT_STATUS
> register instead of PL080_TC_STATUS when checking for the terminal
> count. The PL080_INT_STATUS is a logical OR between the error and
> terminal count status register and may not report what we want it
> to, especially if there is an error and a terminal count at the same
> time and the former is not lowered in time for the check in the TC
> register. Make sure we read what we're actually interested in.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> Cc: Alim Akhtar <alim.akhtar@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/dma/amba-pl08x.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
> index c301a8e..08589c6 100644
> --- a/drivers/dma/amba-pl08x.c
> +++ b/drivers/dma/amba-pl08x.c
> @@ -1615,7 +1615,7 @@ static irqreturn_t pl08x_irq(int irq, void *dev)
>  			__func__, err);
>  		writel(err, pl08x->base + PL080_ERR_CLEAR);
>  	}
> -	tc = readl(pl08x->base + PL080_INT_STATUS);
> +	tc = readl(pl08x->base + PL080_TC_STATUS);
>  	if (tc)
>  		writel(tc, pl08x->base + PL080_TC_CLEAR);
>  

Acked-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh
