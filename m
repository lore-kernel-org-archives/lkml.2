Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab1DLPPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:15:51 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:33410 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756503Ab1DLPPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:15:49 -0400
Date: Tue, 12 Apr 2011 17:15:48 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: pavel@ucw.cz, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org, marek.vasut@gmail.com
Subject: zaurus: mmcblk0: error -110
Message-ID: <20110412151547.GC20815@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
When I insert the mmc card to zaurus, it gets properly detected and prints some
info into console. Mounting reading/writing files works fine.

However when the card is removed (doesn't need to be mounted before), the
removal is most likely not detected, so when I insert it again, no info is
printed into console and moreover when I try to mount it zaurus goes into
infinite loop printing:

Buffer I/O error on device mmcblk0p1, logical block 9
mmcblk0: error -110 sending status command
mmcblk0: error -110 sending read/write command, response 0xb00, card status 0xb00
end_request: I/O error, dev mmcblk0, sector 257
Buffer I/O error on device mmcblk0p1, logical block 10
mmcblk0: error -110 sending status command
mmcblk0: error -110 sending read/write command, response 0xb00, card status 0xb00
end_request: I/O error, dev mmcblk0, sector 258
Buffer I/O error on device mmcblk0p1, logical block 11
mmcblk0: error -110 sending status command
mmcblk0: error -110 sending read/write command, response 0xb00, card status 0xb00
end_request: I/O error, dev mmcblk0, sector 259
Buffer I/O error on device mmcblk0p1, logical block 12
mmcblk0: error -110 sending status command
mmcblk0: error -110 sending read/write command, response 0xb00, card status 0xb00
...

Related part of the .config:

#
# OTG and related infrastructure
#
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ULPI is not set
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_UNSAFE_RESUME=y
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_PXA=y

-- 
metan
