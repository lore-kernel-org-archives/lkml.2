Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521Ab2KBJtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:49:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54951 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760091Ab2KBJtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:49:04 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-serial@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH v3] linux,stdout-path helper
Date: Fri,  2 Nov 2012 10:48:51 +0100
Message-Id: <1351849734-9836-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following adds a helper for matching the linux,stdout-path property
in the chosen node and makes use of it in the i.MX serial driver.

changes since v2:

- move helper to OF core and make it independent of serial devices

changes since v1:

- move it out of the i.MX serial driver and make it generic for serial
  devices.

----------------------------------------------------------------
Sascha Hauer (3):
      OF: Add helper for matching against linux,stdout-path
      serial: i.MX: Make console support non optional
      serial: i.MX: evaluate linux,stdout-path property

 drivers/of/Kconfig         |    3 +++
 drivers/of/Makefile        |    1 +
 drivers/of/of_stdout.c     |   27 +++++++++++++++++++++++++++
 drivers/tty/serial/Kconfig |   16 +---------------
 drivers/tty/serial/imx.c   |   12 +++++-------
 include/linux/of_stdout.h  |   24 ++++++++++++++++++++++++
 6 files changed, 61 insertions(+), 22 deletions(-)
 create mode 100644 drivers/of/of_stdout.c
 create mode 100644 include/linux/of_stdout.h
