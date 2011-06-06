Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab1FFGJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 02:09:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:58445 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab1FFGJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 02:09:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,325,1304319600"; 
   d="scan'208";a="9861329"
Subject: Re: [PATCH 1/3] dmaengine: add new dma API for max_segment_number
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
In-Reply-To: <20110602055614.GA18508@S2100-06.ap.freescale.net>
References: <1306391493-29425-1-git-send-email-shawn.guo@linaro.org>
	 <1306914144.10976.4.camel@vkoul-udesk3>
	 <20110602055614.GA18508@S2100-06.ap.freescale.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 11:05:01 +0530
Message-ID: <1307338501.10976.77.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-02 at 13:56 +0800, Shawn Guo wrote:
> On Wed, Jun 01, 2011 at 01:12:24PM +0530, Koul, Vinod wrote:
> > On Thu, 2011-05-26 at 14:31 +0800, Shawn Guo wrote:
> > > Like dma_set(get)_max_seg_size for max_segment_size, the patch adds
> > > max_segment_number into device_dma_parameters and creates the
> > > corresponding dmaengine API dma_set(get)_max_seg_number for it.
> > > 
> > > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> > > ---
> > >  include/linux/device.h      |    1 +
> > >  include/linux/dma-mapping.h |   15 +++++++++++++++
> > >  2 files changed, 16 insertions(+), 0 deletions(-)
> > Can you explain me why this change is required, the patch description
> > isn't helping for this.
> > 
> > If you satisfy me with above then I am okay with it, but I need ACK from
> > Dan before applying...
> > 
> I recently saw you people are trying to sort out the slave dma api
> document.  This reminds me there is small piece missing, which the
> patch here is trying to add.
> 
> Here is the user story.  The mxs-mmc is the mmc host controller for
> Freescale MXS architecture.  There are a pair of  mmc host specific
> parameters max_seg_size and max_segs that mxs-mmc host driver needs
> to tell mmc core, so that mmc core can know how big each data segment
> could be and how many segments could be handled one time in a scatter
> list by host driver.
> 
> The mxs-mmc driver is one user of dmaengine mxs-dma, and it will call
> mxs-dma to transfer data in scatter list.  That is to say mxs-mmc has
> not idea of what max_seg_size and max_segs should be, because they are
> all mxs-dma capability parameters, and mxs-mmc needs to query them
> from mxs-dma.
> 
> Right now, there is well defined dma api (dma_get_max_seg_size) for
> mmc to query max_seg_size from dma driver, but the one for max_segs is
> missing.  That's why mxs-mmc driver has to hard-code it.
> 
> The mxs-mmc is just one example to demonstrate the need of the new
> api, and I'm sure there are other mmc host drivers (mxcmmc on imx-dma
> is another example) and possibly even other dmaengine users need this
> new api to know the maximum segments that dma driver can handle per
> dma call.
> 
Looks fine, care to add above in your patch description.
Few years down it will be really helpful to know why this was added.

-- 
~Vinod

