Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab1EZHgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 03:36:35 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56784 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab1EZHgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 03:36:33 -0400
Date: Thu, 26 May 2011 08:36:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Dan <dan.j.williams@intel.com>, Per Forlin <per.forlin@linaro.org>
Subject: Re: [PATCH 2/2] dmaengine: add TODO items for future work on dma
	drivers
Message-ID: <20110526073620.GF24876@n2100.arm.linux.org.uk>
References: <1306323570-11133-1-git-send-email-vinod.koul@intel.com> <1306323570-11133-3-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306323570-11133-3-git-send-email-vinod.koul@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 05:09:30PM +0530, Koul, Vinod wrote:
> +1. Move remaining drivers to use new slave interface
> +2. Remove old slave pointer machansim
> +3. Make issue_pending to start the transaction in below drivers
> +	- mpc512x_dma
> +	- imx-dma
> +	- imx-sdma
> +	- mxs-dma.c
> +	- dw_dmac
> +	- intel_mid_dma
> +	- ste_dma40

I'd suggest adding some more to this:

4. Remove dma_slave_config's dma direction.

It's pointless that dma_slave_config carries the DMA direction (to/from
device) and the prepare function does too.  It leads to DMA engine drivers
having to verify that the two match, and DMA engine users having to issue
two calls every time they change direction.

Instead, lets specify that dma_slave_config carries the _device_ side
parameters, which are selected according to the direction given to the
prepare function.  The memory-side parameters should be selected by the
DMA engine driver according to its knowledge of the system.

This is sensible as M2M transfers don't allow configuration and therefore
already have to select these parameters internally.
