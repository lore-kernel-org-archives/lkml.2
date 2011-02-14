Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab1BNHzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 02:55:17 -0500
Received: from gate.eia.be ([194.78.71.18]:28428 "EHLO mail.eia.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab1BNHzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 02:55:14 -0500
Date: Mon, 14 Feb 2011 08:55:07 +0100
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: [PATCH] net/can/softing: make CAN_SOFTING_CS depend on CAN_SOFTING
Message-ID: <20110214075507.GB374@e-circ.dyndns.org>
References: <201102110100.p1B10sDx029244@imap1.linux-foundation.org>
 <20110211223312.be571303.randy.dunlap@oracle.com>
 <20110212111344.GA328@e-circ.dyndns.org>
 <4D56AF22.4070803@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4D56AF22.4070803@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 14 Feb 2011 07:55:09.0637 (UTC) FILETIME=[80731F50:01CBCC1C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The statement 'select CAN_SOFTING' may ignore the dependancies
for CAN_SOFTING while selecting CAN_SOFTING_CS, as is therefore a bad choice.

Signed-off-by: Kurt Van Dijck <kurt.van.dijck@eia.be>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
---
diff --git a/drivers/net/can/softing/Kconfig b/drivers/net/can/softing/Kconfig
index 92bd6bd..55dd3e4 100644
--- a/drivers/net/can/softing/Kconfig
+++ b/drivers/net/can/softing/Kconfig
@@ -18,7 +18,7 @@ config CAN_SOFTING
 config CAN_SOFTING_CS
 	tristate "Softing Gmbh CAN pcmcia cards"
 	depends on PCMCIA
-	select CAN_SOFTING
+	depends on CAN_SOFTING
 	---help---
 	  Support for PCMCIA cards from Softing Gmbh & some cards
 	  from Vector Gmbh.
