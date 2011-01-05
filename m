Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab1AEQ4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 11:56:22 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34141 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab1AEQ4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 11:56:21 -0500
Date: Wed, 5 Jan 2011 16:55:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Hong XU <hong.xu@atmel.com>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>
Subject: Re: Hit BUG_ON in dma-mapping.c:425
Message-ID: <20110105165551.GE8638@n2100.arm.linux.org.uk>
References: <4D24A108.2080609@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D24A108.2080609@atmel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 05:49:12PM +0100, Nicolas Ferre wrote:
> Hi,
> 
> While running mtd_stresstest on a dataflash (atmel_spi 
> + mtd_dataflash drivers) I hit the BUG_ON directive that 
> is at the beginning of ___dma_single_cpu_to_dev() function.
> This function is called from the SPI driver that do a 
> dma_map_single() before DMA operations on the buffer 
> transmitted from upper layers.
> 
> It seems that this address is above "high_memory" limit because 
> it is allocated by vmalloc (in mtd_stresstest.c:285)...

Well, its telling you is that you're not allowed to DMA to vmalloc
addresses.  Whether that's the fault of the map driver or not is a
question for mtd folk.
