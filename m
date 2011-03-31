Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528Ab1CaGOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:14:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:40065 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab1CaGOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:14:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,274,1299484800"; 
   d="scan'208";a="727303732"
Subject: Re: [PATCH] dmaengine/dw_dmac fix: dwc_scan_descriptors must
 compare first desc address also with llp
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jamie@jamieiles.com, shiraz.hashim@st.com, armando.visconti@st.com,
        ajay.khandelwal@st.com, amit.goel@st.com, viresh.linux@gmail.com
In-Reply-To: <d8ab376fabe638f25a66be559e64cc043e8d1dd4.1300946288.git.viresh.kumar@st.com>
References: <d8ab376fabe638f25a66be559e64cc043e8d1dd4.1300946288.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Mar 2011 11:14:56 +0530
Message-ID: <1301550296.18522.7.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 11:32 +0530, Viresh Kumar wrote:
> dwc_scan_descriptors scans all descriptors from active_list in case transfer is
> not completed.  It compares first_desc->lli.llp, and then all childrens of its
> tx_list. But it doesn't compare its own address, i.e. first_desc->txd.phys, as
> this is what we have initially programmed into the controller register. So this
> causes dma to stop and finish a transfer, which was never started. And thus
> fail.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/dma/dw_dmac.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index b95e6d3..1bd4803 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -304,6 +304,11 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
>  	dev_vdbg(chan2dev(&dwc->chan), "scan_descriptors: llp=0x%x\n", llp);
>  
>  	list_for_each_entry_safe(desc, _desc, &dwc->active_list, desc_node) {
> +		/* check first descriptors addr */
> +		if (desc->txd.phys == llp)
> +			return;
> +
> +		/* check first descriptors llp */
>  		if (desc->lli.llp == llp)
>  			/* This one is currently in progress */
>  			return;

Applied, Thanks

-- 
~Vinod

