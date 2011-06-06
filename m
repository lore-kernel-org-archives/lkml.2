Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab1FFJOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:14:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43585 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab1FFJOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:14:50 -0400
Date: Mon, 6 Jun 2011 10:14:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: shawn.guo@linaro.org, patches@linaro.org, vinod.koul@intel.com,
        gregkh@suse.de, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dan.j.williams@intel.com, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] dmaengine: add new dma API for
	max_segment_number
Message-ID: <20110606091410.GB10508@n2100.arm.linux.org.uk>
References: <1307345414-26872-1-git-send-email-shawn.guo@linaro.org> <20110606170420I.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606170420I.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 05:06:03PM +0900, FUJITA Tomonori wrote:
> max_segs isn't unrelated with the dma mapping API. I explained above,
> IOMMUs doesn't increase the number of segments (could decrease the
> number of segments by merging).
> 
> The limitation about the number of segment already lives elsewhere
> (e.g. queue's limits.max_segments).

I think you're missing the point entirely.

Lets take the problem at hand: you have two devices.  One of them is
handled by the DMA engine code.  One of them is a block device.

The block layer needs to know the various parameters of what is
allowable for DMA, including such things as the maximum size of a
segment, and the _number_ of segments that can be placed into any
one request.

As the DMA provider is _entirely_ separate and unknown to the block
device driver, the block device driver has no way to sanely provide
these parameters to the block layer - they are not a property of the
block device driver, but of the DMA provider.

However, the DMA provider can't know that it'll be interacting with
the block layer, so there's no way for the DMA provider to tell the
block layer about its parameters.

The only way this can happen is for there to be some way for the DMA
provider to export this information to the block device driver, so
the block device driver can then inform its upper layers what the DMA
capabilities are.

So to say that "it lives elsewhere" is completely missing the problem
trying to be addressed by these patches.
