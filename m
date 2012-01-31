Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2AaDxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 22:53:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:24091 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab2AaDxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 22:53:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="118353465"
Subject: Re: [PATCH V2 02/12] dmaengine: Add flow controller information to
 dma_slave_config
From: Vinod Koul <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: dan.j.williams@intel.com, cjb@laptop.org, rmk+kernel@arm.linux.org.uk,
        linus.walleij@linaro.org, ulf.hansson@stericsson.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        egtvedt@samfundet.no, hskinnemoen@gmail.com, kernel@pengutronix.de,
        perex@perex.cz, linux-arm-kernel@lists.infradead.org,
        armando.visconti@st.com, shiraz.hashim@st.com, vipin.kumar@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com, vipulkumar.samar@st.com,
        amit.virdi@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com,
        viresh.linux@gmail.com, bhavna.yadav@st.com, vincenzo.frascino@st.com,
        mirko.gardi@st.com
In-Reply-To: <5f9ec59562e86536c4123f61891b95590293030f.1326876464.git.viresh.kumar@st.com>
References: <cover.1326876464.git.viresh.kumar@st.com>
	 <5f9ec59562e86536c4123f61891b95590293030f.1326876464.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Jan 2012 09:24:42 +0530
Message-ID: <1327982082.1527.60.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-18 at 14:41 +0530, Viresh Kumar wrote:
> Flow controller is programmable for few controllers and there are few
> intelligent peripherals like, Synopsys JPEG controller, that needs to be a flow
> controller of DMA transfers on dest side.
> 
> For this, currently two drivers, pl08x and dw_dmac, support flow controller to
> be passed from platform to these drivers.
> 
> Perhaps, this should be a part of struct dma_slave_config. This patch adds
> another field device_fc to this structure. User drivers must pass this as true
> if they want to be flow controller of certain transfers.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  include/linux/dmaengine.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 5532bb8..dd1915f 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -25,6 +25,7 @@
>  #include <linux/uio.h>
>  #include <linux/scatterlist.h>
>  #include <linux/bitmap.h>
> +#include <linux/types.h>
>  #include <asm/page.h>
>  
>  /**
> @@ -330,6 +331,9 @@ enum dma_slave_buswidth {
>   * may or may not be applicable on memory sources.
>   * @dst_maxburst: same as src_maxburst but for destination target
>   * mutatis mutandis.
> + * @device_fc: Flow Controller Settings for ccfg register. Only valid for slave
ccfg maybe true for your controller, not others...

> + * channels. Fill with 'true' if peripheral should be flow controller. Direction
> + * will be selected at Runtime.
>   *
>   * This struct is passed in as configuration data to a DMA engine
>   * in order to set up a certain channel for DMA transport at runtime.
> @@ -356,6 +360,7 @@ struct dma_slave_config {
>  	enum dma_slave_buswidth dst_addr_width;
>  	u32 src_maxburst;
>  	u32 dst_maxburst;
> +	bool device_fc;
>  };
>  
>  static inline const char *dma_chan_name(struct dma_chan *chan)


-- 
~Vinod

