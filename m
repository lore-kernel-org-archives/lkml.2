Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab1EIFwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 01:52:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:13292 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab1EIFwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 01:52:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,338,1301900400"; 
   d="scan'208";a="432757043"
Subject: Re: [PATCH V4 3/5] dmaengine/dw_dmac: Divide one sg to many desc,
 if sg len is greater than DWC_MAX_COUNT
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        armando.visconti@st.com, shiraz.hashim@st.com,
        linux-arm-kernel@lists.infradead.org, viresh.linux@gmail.com,
        linux@arm.linux.org.uk
In-Reply-To: <f3150fa0fb160c70760b95ac72423ebba354f188.1304596524.git.viresh.kumar@st.com>
References: <cover.1304596524.git.viresh.kumar@st.com>
	 <f3150fa0fb160c70760b95ac72423ebba354f188.1304596524.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 10:50:25 +0530
Message-ID: <1304918425.32447.20.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-05 at 17:30 +0530, Viresh Kumar wrote:
> If len passed in sg for slave_sg transfers is greater than DWC_MAX_COUNT, then
> driver programmes controller incorrectly.  This patch adds code to handle this
> situation by allocation more than one desc for same sg.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/dma/dw_dmac.c |   65 +++++++++++++++++++++++++++++++++----------------
>  1 files changed, 44 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 75b32e1..1662452 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -695,9 +695,15 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>  		reg = dws->tx_reg;
>  		for_each_sg(sgl, sg, sg_len, i) {
>  			struct dw_desc	*desc;
> -			u32		len;
> -			u32		mem;
> +			u32		len, dlen, mem;
>  
> +			mem = sg_phys(sg);
> +			len = sg_dma_len(sg);
> +			mem_width = 2;
hardcoding mem_width doesn't make sense, you should take this from input
params

-- 
~Vinod

