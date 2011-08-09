Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab1HICQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 22:16:33 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:2257
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953Ab1HICQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 22:16:32 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Liu Gang <b34182@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <akpm@linux-foundation.org>, <linuxppc-dev@ozlabs.org>,
        <mporter@kernel.crashing.org>, <r58472@freescale.com>,
        <B11780@freescale.com>, <r61911@freescale.com>,
        Liu Gang <b34182@freescale.com>, Liu Gang <Gang.Liu@freescale.com>
Subject: [PATCH] rio: Use discovered bit to test if enumeration is complete
Date: Tue, 9 Aug 2011 10:17:06 +0800
Message-ID: <1312856226-3695-1-git-send-email-b34182@freescale.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The discovered bit in PGCCSR register indicates if the device has
been discovered by system host. In Rapidio system, some agent devices
can also be master devices. They can issue requests into the system.

Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
---
 drivers/rapidio/rio-scan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index ee89358..2dac1f0 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -924,7 +924,7 @@ static int __devinit rio_enum_peer(struct rio_net *net, struct rio_mport *port,
  * rio_enum_complete- Tests if enumeration of a network is complete
  * @port: Master port to send transaction
  *
- * Tests the Component Tag CSR for non-zero value (enumeration
+ * Tests the PGCCSR discovered bit for non-zero value (enumeration
  * complete flag). Return %1 if enumeration is complete or %0 if
  * enumeration is incomplete.
  */
@@ -934,7 +934,7 @@ static int rio_enum_complete(struct rio_mport *port)
 
 	rio_local_read_config_32(port, port->phys_efptr + RIO_PORT_GEN_CTL_CSR,
 				 &regval);
-	return (regval & RIO_PORT_GEN_MASTER) ? 1 : 0;
+	return (regval & RIO_PORT_GEN_DISCOVERED) ? 1 : 0;
 }
 
 /**
-- 
1.7.3.1


