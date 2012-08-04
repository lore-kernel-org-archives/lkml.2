Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab2HDAj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 20:39:26 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:45822 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754124Ab2HDAjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 20:39:22 -0400
Message-ID: <501C6EEF.3030100@xenotime.net>
Date: Fri, 03 Aug 2012 17:38:07 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kernel@vger.kernel.org, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: [PATCH] cris: fix eth_v10.c build error
References: <1344002771-21072-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1344002771-21072-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build error on cris (not tested, no toolchain here):

drivers/net/cris/eth_v10.c: error: too many arguments to function 'e100rxtx_interrupt'

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Mikael Starvik <starvik@axis.com>
Cc:	Jesper Nilsson <jesper.nilsson@axis.com>
Cc:	linux-cris-kernel@axis.com
---
 drivers/net/cris/eth_v10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-36-rc1.orig/drivers/net/cris/eth_v10.c
+++ lnx-36-rc1/drivers/net/cris/eth_v10.c
@@ -1712,7 +1712,7 @@ e100_set_network_leds(int active)
 static void
 e100_netpoll(struct net_device* netdev)
 {
-	e100rxtx_interrupt(NETWORK_DMA_TX_IRQ_NBR, netdev, NULL);
+	e100rxtx_interrupt(NETWORK_DMA_TX_IRQ_NBR, netdev);
 }
 #endif
 
