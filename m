Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab1KPQ0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:26:49 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32981 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab1KPQY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:24:57 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Juergen Beisert <jbe@pengutronix.de>, Matthias Fuchs <mfuchs@ma-fu.de>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: =?UTF-8?q?=5BPATCH=200/8=5D=20serial=3A=208250=3A=20support=20hw-based=20RS485=20direction=20control=20=28finally!=29?=
Date: Wed, 16 Nov 2011 17:24:37 +0100
Message-Id: <1321460685-15753-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some 8250-variants control the direction pin for RS485 in hardware. Linux has
RS485 support these days, so update the 8250-driver to adhere to that. There
have been attempts for mainlining this before. So, I started with the version
from Matthias which got no further comments, a proof-of-concept for the 16V2750
from Jürgen, and reworked it to match the current state of RS485 in Linux. Some
minor cleanup patches came along the way. Really looking forward to
comments/tags, because I think it is really time to get this functionality into
mainline once and for all ;)

Code is based on 3.2-rc2, tested on a OMAP-based custom board with a 16V2750.
A git tree can be found here:

	git://git.pengutronix.de/git/wsa/linux-2.6.git 8250_rs485

Thanks and regards,

   Wolfram

Matthias Fuchs (1):
  serial: 8250: Add ioctl to enable auto rs485 mode with some Exar UARTs

Wolfram Sang (7):
  serial: 8250: replace hardcoded 0xbf with #define
  serial: 8250: save rs485_flags per instance
  serial: 8250: add RX_DURING_TX capability to RS485 mode
  serial: 8250: reject delaying RTS with RS485
  serial: 8250: update rs485 flags with polarity settings
  serial: 8250: add Exar 16V2750 support
  serial: 8250: fix comment about accessing EMSR

 drivers/tty/serial/8250.c   |  143 +++++++++++++++++++++++++++++++++++++++---
 include/linux/serial_core.h |    3 +-
 include/linux/serial_reg.h  |    4 +-
 3 files changed, 137 insertions(+), 13 deletions(-)

-- 
1.7.7.1

