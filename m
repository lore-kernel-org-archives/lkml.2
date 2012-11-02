Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965833Ab2KBJtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:49:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54962 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933559Ab2KBJtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:49:12 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-serial@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 3/3] serial: i.MX: evaluate linux,stdout-path property
Date: Fri,  2 Nov 2012 10:48:54 +0100
Message-Id: <1351849734-9836-4-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1351849734-9836-1-git-send-email-s.hauer@pengutronix.de>
References: <1351849734-9836-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devicetrees may have the linux,stdout-path property to specify the
console. This patch adds support to the i.MX serial driver for this.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/tty/serial/imx.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 3a9337e..41be237 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -47,6 +47,7 @@
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/of_stdout.h>
 #include <linux/pinctrl/consumer.h>
 
 #include <asm/io.h>
@@ -1421,6 +1422,9 @@ static int serial_imx_probe_dt(struct imx_port *sport,
 
 	sport->devdata = of_id->data;
 
+	if (of_device_is_stdout_path(np))
+		add_preferred_console(imx_reg.cons->name, sport->port.line, 0);
+
 	return 0;
 }
 #else
-- 
1.7.10.4

