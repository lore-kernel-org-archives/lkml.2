Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab1KXP3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 10:29:21 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:21665
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754522Ab1KXP2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 10:28:48 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bh8275dhz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: <linux-kernel@vger.kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Wolfgang Grandegger <wg@grandegger.com>, <linux-can@vger.kernel.org>
Subject: [PATCH 11/11] can: Remove redundant spi driver bus initialization
Date: Thu, 24 Nov 2011 16:29:21 +0100
Message-ID: <1322148561-25138-11-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1322148561-25138-1-git-send-email-lars@metafoo.de>
References: <1322148561-25138-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ancient times it was necessary to manually initialize the bus field of an
spi_driver to spi_bus_type. These days this is done in spi_driver_register(),
so we can drop the manual assignment.

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
---
 drivers/net/can/mcp251x.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/can/mcp251x.c b/drivers/net/can/mcp251x.c
index 330140e..5e10da5 100644
--- a/drivers/net/can/mcp251x.c
+++ b/drivers/net/can/mcp251x.c
@@ -1185,7 +1185,6 @@ MODULE_DEVICE_TABLE(spi, mcp251x_id_table);
 static struct spi_driver mcp251x_can_driver = {
 	.driver = {
 		.name = DEVICE_NAME,
-		.bus = &spi_bus_type,
 		.owner = THIS_MODULE,
 	},
 
-- 
1.7.7.1


