Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab3AGPXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:23:41 -0500
Received: from mga03.intel.com ([143.182.124.21]:26025 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab3AGPXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:23:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,424,1355126400"; 
   d="scan'208";a="240879151"
Date: Mon, 7 Jan 2013 06:59:25 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 0/8] DMA: COH901318 in-factoring of platform
Message-ID: <20130107145925.GC15804@intel.com>
References: <1357512185-5562-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357512185-5562-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2013 at 11:43:05PM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This patch series moves the big, complex platform data for the U300
> DMA controller COH901318 down into the driver, rids the
> <mach/coh901318.h> header from the global scope, creates a proper
> platform data header for the few things we acually want to
> parametrize from the platform, and all in preparation for device
> tree support.
> 
> Vinod, it'd be great if you could ACK this so I can merge it
> through the ARM SoC tree. The driver is propably more maintainable
> in this shape as well without lots of pieces spread out all over
> the place.
Sure the change look fine and mostly seems to be code reorg and cleanup.
Perhpas the below diffstat could have helped in review if it showed file move

Acked-by: Vinod Koul <vinod.koul@intel.com>
> 
> Linus Walleij (8):
>   dma: coh901318: create a proper platform data file
>   dma: coh901318: push platform data into driver
>   dma: coh901318: remove hardcoded target addresses
>   dma: coh901318: skip hard-coded addresses
>   dma: coh901318: push header down into the DMA subsystem
>   dma: coh901318: push definitions into driver
>   dma: coh901318: merge header files
>   dma: coh901318: cut down on platform data abstraction
> 
>  arch/arm/mach-u300/core.c                   | 1087 +---------------------
>  arch/arm/mach-u300/dma_channels.h           |   60 --
>  arch/arm/mach-u300/include/mach/coh901318.h |  267 ------
>  arch/arm/mach-u300/spi.c                    |    3 +-
>  drivers/dma/coh901318.c                     | 1302 ++++++++++++++++++++++++++-
>  drivers/dma/coh901318.h                     |  141 +++
>  drivers/dma/coh901318_lli.c                 |    4 +-
>  drivers/dma/coh901318_lli.h                 |  124 ---
>  include/linux/platform_data/dma-coh901318.h |   72 ++
>  9 files changed, 1469 insertions(+), 1591 deletions(-)
>  delete mode 100644 arch/arm/mach-u300/dma_channels.h
>  delete mode 100644 arch/arm/mach-u300/include/mach/coh901318.h
>  create mode 100644 drivers/dma/coh901318.h
>  delete mode 100644 drivers/dma/coh901318_lli.h
>  create mode 100644 include/linux/platform_data/dma-coh901318.h
> 
> -- 
> 1.7.11.3
> 
