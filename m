Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab1BWCM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 21:12:26 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63888 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab1BWCMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 21:12:24 -0500
Subject: [PATCH] tty/serial: Relax the device_type restriction from of_serial
To: devicetree-discuss@lists.ozlabs.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 22 Feb 2011 19:12:21 -0700
Message-ID: <20110223021221.17638.42707.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to test for a device_type property in ns8250
compatible serial ports.  device_type is an OpenFirmware property that
is not required when using the flattened tree representation.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/tty/serial/of_serial.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index 5c7abe4..6a18ca6 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -160,17 +160,17 @@ static int of_platform_serial_remove(struct platform_device *ofdev)
  * A few common types, add more as needed.
  */
 static struct of_device_id __devinitdata of_platform_serial_table[] = {
-	{ .type = "serial", .compatible = "ns8250",   .data = (void *)PORT_8250, },
-	{ .type = "serial", .compatible = "ns16450",  .data = (void *)PORT_16450, },
-	{ .type = "serial", .compatible = "ns16550a", .data = (void *)PORT_16550A, },
-	{ .type = "serial", .compatible = "ns16550",  .data = (void *)PORT_16550, },
-	{ .type = "serial", .compatible = "ns16750",  .data = (void *)PORT_16750, },
-	{ .type = "serial", .compatible = "ns16850",  .data = (void *)PORT_16850, },
+	{ .compatible = "ns8250",   .data = (void *)PORT_8250, },
+	{ .compatible = "ns16450",  .data = (void *)PORT_16450, },
+	{ .compatible = "ns16550a", .data = (void *)PORT_16550A, },
+	{ .compatible = "ns16550",  .data = (void *)PORT_16550, },
+	{ .compatible = "ns16750",  .data = (void *)PORT_16750, },
+	{ .compatible = "ns16850",  .data = (void *)PORT_16850, },
 #ifdef CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL
-	{ .type = "serial", .compatible = "ibm,qpace-nwp-serial",
-					.data = (void *)PORT_NWPSERIAL, },
+	{ .compatible = "ibm,qpace-nwp-serial",
+		.data = (void *)PORT_NWPSERIAL, },
 #endif
-	{ .type = "serial",			      .data = (void *)PORT_UNKNOWN, },
+	{ .type = "serial",         .data = (void *)PORT_UNKNOWN, },
 	{ /* end of list */ },
 };
 

