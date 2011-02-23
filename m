Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1BWNKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 08:10:19 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53338 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab1BWNKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:10:17 -0500
Date: Wed, 23 Feb 2011 13:09:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 01/13] mfd: pruss mfd driver.
Message-ID: <20110223130952.GJ29559@n2100.arm.linux.org.uk>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <1297435892-28278-2-git-send-email-subhasish@mistralsolutions.com> <20110221163027.GF10686@sortiz-mobl> <37B3755C4AE64BAA805DFBAEBDC3D9E4@subhasishg> <20110222103127.GC30279@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222103127.GC30279@sortiz-mobl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 11:31:27AM +0100, Samuel Ortiz wrote:
> So, if you have a:
> 
> static u32 reg_offset(struct device *dev, u8 pru_num)
> {
> 	struct da8xx_pruss *pru = dev_get_drvdata(dev->parent);
> 
> 	switch (pru_num) {
> 	case DA8XX_PRUCORE_0:
> 		return (u32) pru->ioaddr + 0x7000;
> 	case DA8XX_PRUCORE_1:
> 		return (u32) pru->ioaddr + 0x7800;
> 	default:
> 		return 0;
> }

No.  Please don't encourage people to have 'u32' as valid cookies for
readl,writel et.al.  Always make the mmio cookies __iomem pointer like.
