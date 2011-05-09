Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab1EIGTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 02:19:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:56149 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab1EIGTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 02:19:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,338,1301900400"; 
   d="scan'208";a="432768432"
Subject: Re: [PATCH V4 3/5] dmaengine/dw_dmac: Divide one sg to many desc,
 if sg len is greater than DWC_MAX_COUNT
From: "Koul, Vinod" <vinod.koul@intel.com>
To: viresh kumar <viresh.kumar@st.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
In-Reply-To: <4DC783A9.5060802@st.com>
References: <cover.1304596524.git.viresh.kumar@st.com>
	 <f3150fa0fb160c70760b95ac72423ebba354f188.1304596524.git.viresh.kumar@st.com>
	 <1304918425.32447.20.camel@vkoul-udesk3>  <4DC783A9.5060802@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 11:17:21 +0530
Message-ID: <1304920041.32447.33.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-09 at 11:33 +0530, viresh kumar wrote:
> On 05/09/2011 10:50 AM, Koul, Vinod wrote:
> >> > @@ -695,9 +695,15 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
> >> >  		reg = dws->tx_reg;
> >> >  		for_each_sg(sgl, sg, sg_len, i) {
> >> >  			struct dw_desc	*desc;
> >> > -			u32		len;
> >> > -			u32		mem;
> >> > +			u32		len, dlen, mem;
> >> >  
> >> > +			mem = sg_phys(sg);
> >> > +			len = sg_dma_len(sg);
> >> > +			mem_width = 2;
> > hardcoding mem_width doesn't make sense, you should take this from input
> > params
> 
> Firstly, this change is not introduced in this patch, i have just rearranged this.
> So, will send separate patch if this change is required.
> 
> Secondly, peripheral width is taken from chan->private. And by 2 for mem_width,
> we meant word-by-word here. Shouldn't we always try word-by-word here?
> How should we pass width for memory?
Ah, then there is another todo for this driver. Move from chan->private
to DMA_SLAVE_CONFIG.

struct dma_slave_config has dedicated fields for both source and
destination widths, src_addr_width & dst_addr_width please use them...
You should pass this structure to device control API as:
dmaengine_device_control(
	chan, DMA_SLAVE_CONFIG, (unsigned long)&slave_config);

-- 
~Vinod

