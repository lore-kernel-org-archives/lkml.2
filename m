Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab2CKBqz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 20:46:55 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:44656 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752010Ab2CKBqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 20:46:52 -0500
From: Roland Stigge <stigge@antcom.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        kevin.wells@nxp.com, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v6 0/3] USB: OHCI-HCD: Support for LPC32xx
Date: Sun, 11 Mar 2012 02:46:12 +0100
Message-Id: <1331430375-31227-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the LPC32xx to the ohci-pnx4008 driver.

As discussed with Greg-KH on the USB mailing list, the ohci-pnx4008 driver is
first renamed to reflect its multi-platform support. The second patch also
renames the respective pnx4008_* symbols accordingly. The third and final patch
adds the actual lpc32xx support.

Applies to v3.3-rc6

Since v5, i2c_read16() has been removed in favour of i2c_smbus_read_word_data()

Thanks to Wolfram Sang for reviewing!

Signed-off-by: Roland Stigge <stigge@antcom.de>

---

Roland Stigge (3):
 USB: OHCI-HCD: Rename ohci-pnx4008 to ohci-nxp
 USB: ohci-nxp: Rename symbols from pnx4008 to nxp
 USB: ohci-nxp: Support for LPC32xx

 Documentation/i2c/instantiating-devices |    6 
 drivers/usb/host/ohci-hcd.c             |    6 
 drivers/usb/host/ohci-nxp.c             |  652 ++++++++++++++++++++++++++++----
 drivers/usb/host/ohci-pnx4008.c         |  453 ----------------------
 4 files changed, 596 insertions(+), 521 deletions(-)
