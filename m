Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933462Ab2HPW3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 18:29:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39994 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab2HPW3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 18:29:43 -0400
Date: Thu, 16 Aug 2012 23:29:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Matt Porter <mporter@ti.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, cjb@laptop.org,
        grant.likely@secretlab.ca,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] dmaengine: add TI EDMA DMA engine driver
Message-ID: <20120816222912.GA15883@n2100.arm.linux.org.uk>
References: <1345153471-22757-1-git-send-email-mporter@ti.com> <1345153471-22757-2-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345153471-22757-2-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 05:44:29PM -0400, Matt Porter wrote:
> Add a DMA engine driver for the TI EDMA controller. This driver
> is implemented as a wrapper around the existing DaVinci private
> DMA implementation. This approach allows for incremental conversion
> of each peripheral driver to the DMA engine API. The EDMA driver
> supports slave transfers but does not yet support cyclic transfers.

Have you looked at the virt-dma support?  That should allow you to
avoid some common errors, like forgetting that stuff submitted but
not issued should not be started even if the channel is currently
running.
