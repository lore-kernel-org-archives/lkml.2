Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461Ab2DJUtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 16:49:20 -0400
Received: from smtp-out-106.synserver.de ([212.40.185.106]:1099 "EHLO
	smtp-out-105.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755473Ab2DJUtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 16:49:18 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1983
From: Lars-Peter Clausen <lars@metafoo.de>
To: linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org
Subject: [PATCH 2/4] can: Remove redundant spi driver bus initialization
Date: Tue, 10 Apr 2012 22:51:27 +0200
Message-Id: <1334091089-10138-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334091089-10138-1-git-send-email-lars@metafoo.de>
References: <1334091089-10138-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ancient times it was necessary to manually initialize the bus field of an
spi_driver to spi_bus_type. These days this is done in spi_driver_register() so
we can drop the manual assignment.

The patch was generated using the following coccinelle semantic patch:
// <smpl>
@@
identifier _driver;
@@
struct spi_driver _driver = {
	.driver = {
-		.bus = &spi_bus_type,
	},
};
// </smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: linux-can@vger.kernel.org
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/mcp251x.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/mcp251x.c b/drivers/net/can/mcp251x.c
index 346785c..2bccaf7 100644
--- a/drivers/net/can/mcp251x.c
+++ b/drivers/net/can/mcp251x.c
@@ -1184,7 +1184,6 @@ MODULE_DEVICE_TABLE(spi, mcp251x_id_table);
 static struct spi_driver mcp251x_can_driver = {
 	.driver = {
 		.name = DEVICE_NAME,
-		.bus = &spi_bus_type,
 		.owner = THIS_MODULE,
 	},
 
-- 
1.7.9.5

