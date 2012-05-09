Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab2EIGIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:08:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39014 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756325Ab2EIFxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:35 -0400
Message-Id: <20120509055040.763953802@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:48 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Davide Ciminaghi <ciminaghi@gnudd.com>,
        Raffaele Recalcati <raffaele.recalcati@bticino.it>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 079/167] [PATCH 19/26] net/ethernet: ks8851_mll fix rx frame buffer overflow
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davide Ciminaghi <ciminaghi@gnudd.com>

[ Upstream commit 8a9a0ea6032186e3030419262678d652b88bf6a8 ]

At the beginning of ks_rcv(), a for loop retrieves the
header information relevant to all the frames stored
in the mac's internal buffers. The number of pending
frames is stored as an 8 bits field in KS_RXFCTR.
If interrupts are disabled long enough to allow for more than
32 frames to accumulate in the MAC's internal buffers, a buffer
overflow occurs.
This patch fixes the problem by making the
driver's frame_head_info buffer big enough.
Well actually, since the chip appears to have 12K of
internal rx buffers and the shortest ethernet frame should
be 64 bytes long, maybe the limit could be set to
12*1024/64 = 192 frames, but 255 should be safer.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Signed-off-by: Raffaele Recalcati <raffaele.recalcati@bticino.it>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/micrel/ks8851_mll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index d19c849..77241b6 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -40,7 +40,7 @@
 #define	DRV_NAME	"ks8851_mll"
 
 static u8 KS_DEFAULT_MAC_ADDRESS[] = { 0x00, 0x10, 0xA1, 0x86, 0x95, 0x11 };
-#define MAX_RECV_FRAMES			32
+#define MAX_RECV_FRAMES			255
 #define MAX_BUF_SIZE			2048
 #define TX_BUF_SIZE			2000
 #define RX_BUF_SIZE			2000
-- 
1.7.10



