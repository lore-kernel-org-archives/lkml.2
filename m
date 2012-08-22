Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab2HVDnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 23:43:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:60843 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386Ab2HVDnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 23:43:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,807,1336374000"; 
   d="scan'208";a="183788597"
Subject: Re: [PATCH v2 3/3] spi: spi-davinci: convert to DMA engine API
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Matt Porter <mporter@ti.com>
Cc: cjb@laptop.org, grant.likely@secretlab.ca,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1345574589-24757-4-git-send-email-mporter@ti.com>
References: <1345574589-24757-1-git-send-email-mporter@ti.com>
	 <1345574589-24757-4-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Aug 2012 09:15:22 +0530
Message-ID: <1345607122.1895.44.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-21 at 14:43 -0400, Matt Porter wrote:
> Removes use of the DaVinci EDMA private DMA API and replaces
> it with use of the DMA engine API.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---

> +		struct dma_slave_config dma_rx_conf = {
> +			.direction = DMA_DEV_TO_MEM,
> +			.src_addr = (unsigned long)dspi->pbase + SPIBUF,
> +			.src_addr_width = data_type,
> +			.src_maxburst = 1,
what does 1 mean in this context? We define as number of units that
needs to be transfered, so are you sure that you want only one unit to
be dma'ed in a single burst. that seems like killing your dmac,
shouldn't you be using larger bursts for a better dma performance?


-- 
~Vinod

