Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140Ab1D1RLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 13:11:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56177 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932867Ab1D1RLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 13:11:32 -0400
Date: Thu, 28 Apr 2011 18:11:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, armando.visconti@st.com,
        linux-kernel@vger.kernel.org, shiraz.hashim@st.com,
        viresh.linux@gmail.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 3/7] dmaengine/dw_dmac: don't call callback routine
	in case dmaengine_terminate_all() is called
Message-ID: <20110428171118.GC17290@n2100.arm.linux.org.uk>
References: <cover.1303896566.git.viresh.kumar@st.com> <b5e9038ecac3f44d265c7321de551bd9b66cdddd.1303896567.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5e9038ecac3f44d265c7321de551bd9b66cdddd.1303896567.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 03:06:45PM +0530, Viresh Kumar wrote:
> If dmaengine_terminate_all() is called for dma channel, then it doesn't make
> much sense to call registered callback routine. While in case of success or
> failure it must be called.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/dma/dw_dmac.c |   27 ++++++++++++++-------------
>  1 files changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index b6dfc39..f590109 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -198,7 +198,8 @@ static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
>  /*----------------------------------------------------------------------*/
>  
>  static void
> -dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
> +dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc,
> +		bool callback_required)

If you're using 'bool' then using 'true' and 'false' with it rather than
'1' and '0' is a good idea.
