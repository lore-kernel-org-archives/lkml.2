Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab2CNUTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 16:19:33 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60205 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab2CNUTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 16:19:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6648"; a="172502987"
Date: Wed, 14 Mar 2012 13:19:29 -0700
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Ravi Kumar V <kumarrav@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bryan Huntsman <bryanh@codeaurora.org>,
        gregkh@linuxfoundation.org, Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/2] DMAEngine: Add DMAEngine driver based on old MSM
 DMA APIs
Message-ID: <20120314201929.GA17259@codeaurora.org>
References: <1331548364-27845-1-git-send-email-kumarrav@codeaurora.org>
 <20120312201421.GA3459@fifo99.com>
 <4F5F41AF.1090907@codeaurora.org>
 <20120314150533.GA8757@fifo99.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314150533.GA8757@fifo99.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 08:05:53AM -0700, Daniel Walker wrote:
> On Tue, Mar 13, 2012 at 06:16:39PM +0530, Ravi Kumar V wrote:
> > On 3/13/2012 1:44 AM, Daniel Walker wrote:
> > >On Mon, Mar 12, 2012 at 04:02:44PM +0530, Ravi Kumar V wrote:
> > >>Add DMAEngine based driver using the old MSM DMA APIs internally.
> > >
> > >What do you mean by this?
> > >
> > There is a MSM DMA driver in arch/arm/mach-msm/ which is not in
> > dmaengine framework standards, but that driver is been used by
> > client drivers nand, eMMC and serial drivers. Now if we implement
> > the whole dma driver using dmaengine framework then nand, eMMC like
> > drivers will be failed as they are using old dma driver API's, so
> > instead of implementing new driver from scratch we are keeping the
> > old dma API's as it is and using those API's in new dmaengine
> > framework.So that we can convert clients drivers to use dma engine
> > framework.
> 
> Did you investigate converting the drivers (nand, eMMC, serial) ? It
> seems like there would be a 1:1 mapping between the API's , so it might
> only be a find->replace operation.

Only at a very superficial level--they both do DMA.  The ADM driver
wants its scatterlists constructed manually by the caller (in DMA-able
memory) and just the pointer handed over.  The drivers will have to be
converted to use the abstracted scatterlists that dmaengine wants.
Drivers like msm_sdcc are currently fairly intimitely tied to flow
that is specific to ADM.  The msm_sdcc driver also needs use of the
ADM's "box" mode, which has to be made to work with DMAEngine as well.

Providing both APIs is really the only practical way to get this in
without having to rewrite several other drivers.

The nand driver (which doesn't seem to have made it in yet,
https://lkml.org/lkml/2011/2/28/570) is much worse.  About half of the
code is constructing ADM specific command blocks.  I'm not even sure
it will be practical to even migrate that driver to DMAEngine, since
the nand controller hardware is so intimately tied to the functioning
of the ADM.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
