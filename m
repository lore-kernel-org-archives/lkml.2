Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab0G2ROo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 13:14:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61098 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758107Ab0G2ROi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 13:14:38 -0400
Date: Thu, 29 Jul 2010 10:14:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, davem@davemloft.net
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: [PATCH -next] net: ks8842 depends on DMA_ENGINE
Message-Id: <20100729101427.2aafd6e7.randy.dunlap@oracle.com>
In-Reply-To: <20100729143211.9e7edaed.sfr@canb.auug.org.au>
References: <20100729143211.9e7edaed.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C51B6F9.01D7:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

ks8842 uses dma channel functions, so it should depend on DMA_ENGINE.

ERROR: "__dma_request_channel" [drivers/net/ks8842.ko] undefined!
ERROR: "dma_release_channel" [drivers/net/ks8842.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100729.orig/drivers/net/Kconfig
+++ linux-next-20100729/drivers/net/Kconfig
@@ -1751,7 +1751,7 @@ config TLAN
 
 config KS8842
 	tristate "Micrel KSZ8841/42 with generic bus interface"
-	depends on HAS_IOMEM
+	depends on HAS_IOMEM && DMA_ENGINE
 	help
 	 This platform driver is for KSZ8841(1-port) / KS8842(2-port)
 	 ethernet switch chip (managed, VLAN, QoS) from Micrel or
