Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1HDJMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 05:12:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:25361 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab1HDJMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 05:12:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,315,1309762800"; 
   d="scan'208";a="35035703"
Subject: Re: [PATCH V2 07/20] dmaengine/amba-pl08x: Changing few prints to
 dev_dbg from dev_info
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linus.walleij@linaro.org, pratyush.anand@st.com, rajeev-dlh.kumar@st.com,
        linux@arm.linux.org.uk, bhupesh.sharma@st.com, shiraz.hashim@st.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        viresh.linux@gmail.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <5752f0202ff197d548999395d68131053693e4b3.1312190881.git.viresh.kumar@st.com>
References: <cover.1312190881.git.viresh.kumar@st.com>
	 <5752f0202ff197d548999395d68131053693e4b3.1312190881.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Aug 2011 13:58:47 +0530
Message-ID: <1312446527.1539.2.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-01 at 15:07 +0530, Viresh Kumar wrote:
> For 8 memory and 16 slave channels 35 boot print lines are printed. And that is
> too much. Most of this would be more useful for debugging. So moving few of them
> to dev_dbg instead of dev_info. Now only 3 prints will be printed.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/dma/amba-pl08x.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
> index 6c52959..3fbaf0e 100644
> --- a/drivers/dma/amba-pl08x.c
> +++ b/drivers/dma/amba-pl08x.c
> @@ -1717,7 +1717,7 @@ static int pl08x_dma_init_virtual_channels(struct pl08x_driver_data *pl08x,
>  			kfree(chan);
>  			continue;
>  		}
> -		dev_info(&pl08x->adev->dev,
> +		dev_dbg(&pl08x->adev->dev,
>  			 "initialize virtual channel \"%s\"\n",
>  			 chan->name);
>  
> @@ -1945,7 +1945,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
>  		spin_lock_init(&ch->lock);
>  		ch->serving = NULL;
>  		ch->signal = -1;
> -		dev_info(&adev->dev,
> +		dev_dbg(&adev->dev,
>  			 "physical channel %d is %s\n", i,
>  			 pl08x_phy_channel_busy(ch) ? "BUSY" : "FREE");
>  	}
ahh, this looks ugly, can you pls fix the print to make them look
better. Single line or fmt string is one line should be ok, arg can be
moved to second.

-- 
~Vinod

