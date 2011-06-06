Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab1FFJlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:41:47 -0400
Received: from sh.osrg.net ([192.16.179.4]:52200 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab1FFJlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:41:45 -0400
Date: Mon, 6 Jun 2011 18:41:09 +0900
To: linux@arm.linux.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, shawn.guo@linaro.org, patches@linaro.org,
        vinod.koul@intel.com, gregkh@suse.de, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dan.j.williams@intel.com, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] dmaengine: add new dma API for
	max_segment_number
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20110606091410.GB10508@n2100.arm.linux.org.uk>
References: <1307345414-26872-1-git-send-email-shawn.guo@linaro.org>
	<20110606170420I.fujita.tomonori@lab.ntt.co.jp>
	<20110606091410.GB10508@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110606183925D.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 06 Jun 2011 18:41:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jun 2011 10:14:10 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Mon, Jun 06, 2011 at 05:06:03PM +0900, FUJITA Tomonori wrote:
> > max_segs isn't unrelated with the dma mapping API. I explained above,
> > IOMMUs doesn't increase the number of segments (could decrease the
> > number of segments by merging).
> > 
> > The limitation about the number of segment already lives elsewhere
> > (e.g. queue's limits.max_segments).
> 
> I think you're missing the point entirely.
> 
> Lets take the problem at hand: you have two devices.  One of them is
> handled by the DMA engine code.  One of them is a block device.
> 
> The block layer needs to know the various parameters of what is
> allowable for DMA, including such things as the maximum size of a
> segment, and the _number_ of segments that can be placed into any
> one request.
> 
> As the DMA provider is _entirely_ separate and unknown to the block
> device driver, the block device driver has no way to sanely provide
> these parameters to the block layer - they are not a property of the
> block device driver, but of the DMA provider.

struct device_dma_parameters is used for a property of the block
device drivers (and scsi HBA drivers, etc). Not DMA provider. Right?

The drivers calls dma_set_seg_boundary() and the subsystems call
dma_get_seg_boundary to set the value to queues.

This patch is trying to use struct device_dma_parameters in a
different way. It adds a new DMA parameter but for the DMA parameter
for a different layer. I'm not sure about different-layer stuff in 
one structure and using similar API.
