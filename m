Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab2DWMpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:45:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:59466 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387Ab2DWMps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:45:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="132824441"
Subject: Re: [PATCH] dmaengine/amba-pl08x : reset phychan_hold on terminate
 all
From: Vinod Koul <vinod.koul@linux.intel.com>
To: ciminaghi@gnudd.com, Linus Walleij <linus.walleij@linaro.org>,
        Viresh Kumar <viresh.kumar@st.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        pgeninatti@soft-in.com, acolosimo@soft-in.com,
        alarosa@openintellect.eu
In-Reply-To: <1334830824-10908-1-git-send-email-ciminaghi@gnudd.com>
References: <1334830824-10908-1-git-send-email-ciminaghi@gnudd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Apr 2012 18:12:20 +0530
Message-ID: <1335184940.31825.115.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-19 at 12:20 +0200, ciminaghi@gnudd.com wrote:
> From: Davide Ciminaghi <ciminaghi@gnudd.com>
> 
> When a client calls pl08x_control with DMA_TERMINATE_ALL, it is correct
> to terminate and release the phy channel currently in use (if one is in use),
> but the phychan_hold counter must also be reset (otherwise it could get
> trapped in an unbalanced state).
> 
> Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
> ---
>  drivers/dma/amba-pl08x.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
> index c301a8e..3d704ab 100644
> --- a/drivers/dma/amba-pl08x.c
> +++ b/drivers/dma/amba-pl08x.c
> @@ -1429,6 +1429,7 @@ static int pl08x_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>  			 * signal
>  			 */
>  			release_phy_channel(plchan);
> +			plchan->phychan_hold = 0;
>  		}
>  		/* Dequeue jobs and free LLIs */
>  		if (plchan->at) {

Linus, Viresh... Any tested-by for this before I apply to fixes.

-- 
~Vinod

