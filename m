Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab2HPJBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 05:01:14 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39552 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab2HPJBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 05:01:04 -0400
Date: Thu, 16 Aug 2012 10:00:41 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roland Stigge <stigge@antcom.de>
Cc: artem.bityutskiy@linux.intel.com, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH] dma: amba-pl08x: Export pl08x_filter_id
Message-ID: <20120816090041.GK18957@n2100.arm.linux.org.uk>
References: <1345107396-27079-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345107396-27079-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 10:56:36AM +0200, Roland Stigge wrote:
> This patch fixes the following when compiling a driver module that uses
> amba-pl08x:
> 
> ERROR: "pl08x_filter_id" [drivers/mtd/nand/lpc32xx_slc.ko] undefined!
> ERROR: "pl08x_filter_id" [drivers/mtd/nand/lpc32xx_mlc.ko] undefined!
> 
> (drivers/mtd/nand/lpc32xx_* are still in l2-mtd.git)

It is currently intended that this be passed from platform code into
drivers via platform data, so that drivers can decide which DMA engine
they wish to make use of.

See how all the AMBA drivers work in this regard (because they need to
support more than just a single DMA engine implementation.)
