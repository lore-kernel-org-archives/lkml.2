Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab2JEQN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:13:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42870 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab2JEQNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:13:24 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-serial@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        <linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 3/3] serial: i.MX: evaluate linux,stdout-path property
Date: Fri,  5 Oct 2012 18:13:01 +0200
Message-Id: <1349453581-1685-4-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349453581-1685-1-git-send-email-s.hauer@pengutronix.de>
References: <1349453581-1685-1-git-send-email-s.hauer@pengutronix.de>
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
 drivers/tty/serial/imx.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 3a9337e..bc8a7bfa 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1421,6 +1421,9 @@ static int serial_imx_probe_dt(struct imx_port *sport,
 
 	sport->devdata = of_id->data;
 
+	if (of_uart_is_stdoutpath(&pdev->dev))
+		add_preferred_console(imx_reg.cons->name, sport->port.line, 0);
+
 	return 0;
 }
 #else
-- 
1.7.10.4

