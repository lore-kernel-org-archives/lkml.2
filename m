Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab2H3Omk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 10:42:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34437 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab2H3Omi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 10:42:38 -0400
Date: Thu, 30 Aug 2012 10:43:07 -0400
From: Matt Porter <mporter@ti.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        vinod.koul@intel.com, Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        grant.likely@secretlab.ca,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        cjb@laptop.org,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 3/3] spi: spi-davinci: convert to DMA engine API
Message-ID: <20120830144307.GA26737@beef>
References: <1345684176-21472-1-git-send-email-mporter@ti.com>
 <1345684176-21472-4-git-send-email-mporter@ti.com>
 <503F75C0.1050507@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503F75C0.1050507@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 07:46:32PM +0530, Sekhar Nori wrote:
> Hi Matt,
> 
> On 8/23/2012 6:39 AM, Matt Porter wrote:
> > Removes use of the DaVinci EDMA private DMA API and replaces
> > it with use of the DMA engine API.
> > 
> > Signed-off-by: Matt Porter <mporter@ti.com>
> 
> I tried testing this patch on my OMAP-L138 EVM, but SPI fails to 
> initialize after applying the patch.
> 
> root@arago:~# dmesg | grep -i spi                                               
> spi_davinci spi_davinci.1: request RX DMA channel failed                        

Hi Sekhar,

Most likely CONFIG_TI_EDMA is off as it defaults to off in the v3
series. Try enabling this and if it's the problem then this error
path can be fixed to properly fallback to PIO only or fail to
initialize as needed.

-Matt
