Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373Ab0JYXjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:39:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52932 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab0JYXjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:39:42 -0400
Date: Mon, 25 Oct 2010 16:25:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, davem@davemloft.net
Subject: [PATCH -next] pch_can: depends on PCI
Message-Id: <20101025162524.570fc82a.randy.dunlap@oracle.com>
In-Reply-To: <20101025145834.9b68e026.sfr@canb.auug.org.au>
References: <20101025145834.9b68e026.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix pch_can build when CONFIG_PCI is not enabled.  It uses pci interfaces
and data structures, so it should depend on PCI.

drivers/net/can/pch_can.c:1044: error: implicit declaration of function 'pci_enable_msi'
drivers/net/can/pch_can.c:1079: error: implicit declaration of function 'pci_disable_msi'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/can/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20101025.orig/drivers/net/can/Kconfig
+++ linux-next-20101025/drivers/net/can/Kconfig
@@ -84,7 +84,7 @@ config CAN_FLEXCAN
 
 config PCH_CAN
 	tristate "PCH CAN"
-	depends on  CAN_DEV
+	depends on CAN_DEV && PCI
 	---help---
 	  This driver is for PCH CAN of Topcliff which is an IOH for x86
 	  embedded processor.
