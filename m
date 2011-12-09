Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab1LIRJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:09:31 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49422 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab1LIRHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:07:35 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH RESEND 0/8] serial: 8250: support hw-based RS485 direction control
Date: Fri,  9 Dec 2011 18:07:12 +0100
Message-Id: <1323450440-414-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.7.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some 8250-variants control the direction pin for RS485 in hardware. Linux has
RS485 support these days, so update the 8250-driver to adhere to that.

Code is based on 3.2-rc4, tested on a OMAP-based custom board with a 16V2750.
A git tree can be found here:

	git://git.pengutronix.de/git/wsa/linux-2.6.git 8250_rs485

There is no code change since the initial post of this series. I updated some
of the patch descriptions, though. A kind-of-ack from Claudio can be found here
[1]. Please consider for inclusion.

Thanks and regards,

   Wolfram

[1] http://lkml.org/lkml/2011/11/24/201

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
1.7.7.3

