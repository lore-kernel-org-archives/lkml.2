Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab2DSGLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 02:11:18 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35837 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2DSGLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 02:11:17 -0400
Date: Thu, 19 Apr 2012 09:10:21 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net, grant.likely@secretlab.ca,
        vinod.koul@linux.intel.com
Subject: Re: [PATCH] spi/spi-ep93xx.c: use dma_transfer_direction instead of
 dma_data_direction
Message-ID: <20120419061020.GB18520@mwesterb-mobl.lan>
References: <201204171846.37245.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204171846.37245.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 06:46:36PM -0700, H Hartley Sweeten wrote:
> A new enum indicating the dma channel direction was introduced by:
> 
> commit 49920bc66984a512f4bcc7735a61642cd0e4d6f2
>     dmaengine: add new enum dma_transfer_direction
> 
> The following commit changed spi-ep93xx to use the new enum:
> 
> commit a485df4b4404379786c4bdd258bc528b2617449d
>     spi, serial: move to dma_transfer_direction
> 
> In doing so a sparse warning was introduced: 
> 
> warning: mixing different enum types
>    int enum dma_data_direction  versus
>    int enum dma_transfer_direction
> 
> This is produced because the 'dir' passed in ep93xx_spi_dma_prepare
> is an enum dma_data_direction and is being used to set the
> dma_slave_config 'direction' which is now an enum dma_transfer_direction.
> 
> Fix this by converting spi-ep93xx to use the new enum type in all
> places.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Vinod Koul <vinod.koul@linux.intel.com>

Acked-by: Mika Westerberg <mika.westerberg@iki.fi>
