Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1FBFvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 01:51:17 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:59310 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab1FBFvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 01:51:16 -0400
X-SpamScore: -2
X-BigFish: VS-2(zz936eK1432N98dK2d6crzz1202hzz8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 2 Jun 2011 13:56:15 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
CC: Shawn Guo <shawn.guo@linaro.org>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <patches@linaro.org>
Subject: Re: [PATCH 1/3] dmaengine: add new dma API for max_segment_number
Message-ID: <20110602055614.GA18508@S2100-06.ap.freescale.net>
References: <1306391493-29425-1-git-send-email-shawn.guo@linaro.org>
 <1306914144.10976.4.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1306914144.10976.4.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 01:12:24PM +0530, Koul, Vinod wrote:
> On Thu, 2011-05-26 at 14:31 +0800, Shawn Guo wrote:
> > Like dma_set(get)_max_seg_size for max_segment_size, the patch adds
> > max_segment_number into device_dma_parameters and creates the
> > corresponding dmaengine API dma_set(get)_max_seg_number for it.
> > 
> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> > ---
> >  include/linux/device.h      |    1 +
> >  include/linux/dma-mapping.h |   15 +++++++++++++++
> >  2 files changed, 16 insertions(+), 0 deletions(-)
> Can you explain me why this change is required, the patch description
> isn't helping for this.
> 
> If you satisfy me with above then I am okay with it, but I need ACK from
> Dan before applying...
> 
I recently saw you people are trying to sort out the slave dma api
document.  This reminds me there is small piece missing, which the
patch here is trying to add.

Here is the user story.  The mxs-mmc is the mmc host controller for
Freescale MXS architecture.  There are a pair of  mmc host specific
parameters max_seg_size and max_segs that mxs-mmc host driver needs
to tell mmc core, so that mmc core can know how big each data segment
could be and how many segments could be handled one time in a scatter
list by host driver.

The mxs-mmc driver is one user of dmaengine mxs-dma, and it will call
mxs-dma to transfer data in scatter list.  That is to say mxs-mmc has
not idea of what max_seg_size and max_segs should be, because they are
all mxs-dma capability parameters, and mxs-mmc needs to query them
from mxs-dma.

Right now, there is well defined dma api (dma_get_max_seg_size) for
mmc to query max_seg_size from dma driver, but the one for max_segs is
missing.  That's why mxs-mmc driver has to hard-code it.

The mxs-mmc is just one example to demonstrate the need of the new
api, and I'm sure there are other mmc host drivers (mxcmmc on imx-dma
is another example) and possibly even other dmaengine users need this
new api to know the maximum segments that dma driver can handle per
dma call.

-- 
Regards,
Shawn

