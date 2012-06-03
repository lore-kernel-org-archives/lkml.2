Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab2FCUiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 16:38:09 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50111 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab2FCUiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 16:38:04 -0400
Date: Sun, 3 Jun 2012 21:37:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roland Stigge <stigge@antcom.de>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        dwmw2@infradead.org, kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, hechtb@googlemail.com,
        lars@metafoo.de, b32955@freescale.com, leiwen@marvell.com,
        dedekind1@gmail.com
Subject: Re: [PATCH v4] MTD: LPC32xx SLC NAND driver
Message-ID: <20120603203749.GD23368@n2100.arm.linux.org.uk>
References: <1338748689-29645-1-git-send-email-stigge@antcom.de> <20120603190932.GB23368@n2100.arm.linux.org.uk> <4FCBBFD4.9090401@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCBBFD4.9090401@antcom.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2012 at 09:49:40PM +0200, Roland Stigge wrote:
> Hi!
> 
> Thanks for the suggestions!
> 
> On 03/06/12 21:09, Russell King - ARM Linux wrote:
> >> +	dma_async_issue_pending(host->dma_chan);
> >> +
> >> +	wait_for_completion_timeout(&host->comp, msecs_to_jiffies(1000));
> > 
> > What about unmapping the buffer upon completion?
> 
> OK - by not specifying DMA_COMPL_SKIP_*_UNMAP in flags, I was thinking
> that this happens somehow magically. ;-) But maybe I was just confused.

Slave transfers should never be automatically unmapped by the DMA engine
driver.
