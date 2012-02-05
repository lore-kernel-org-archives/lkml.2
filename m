Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab2BEWgE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:36:04 -0500
Received: from 1wt.eu ([62.212.114.60]:62101 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab2BEW06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:58 -0500
Message-Id: <20120205220951.759687876@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:43 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>, Chul Kim <chul.kim@idt.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 54/91] drivers/net/rionet.c: fix ethernet address macros for LE platforms
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit e0c87bd95e8dad455c23bc56513af8dcb1737e55 upstream.

Modify Ethernet addess macros to be compatible with BE/LE platforms

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Chul Kim <chul.kim@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/rionet.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Index: longterm-2.6.27/drivers/net/rionet.c
===================================================================
--- longterm-2.6.27.orig/drivers/net/rionet.c	2012-02-05 22:34:33.389915485 +0100
+++ longterm-2.6.27/drivers/net/rionet.c	2012-02-05 22:34:42.555916186 +0100
@@ -87,8 +87,8 @@
 #define dev_rionet_capable(dev) \
 	is_rionet_capable(dev->pef, dev->src_ops, dev->dst_ops)
 
-#define RIONET_MAC_MATCH(x)	(*(u32 *)x == 0x00010001)
-#define RIONET_GET_DESTID(x)	(*(u16 *)(x + 4))
+#define RIONET_MAC_MATCH(x)	(!memcmp((x), "\00\01\00\01", 4))
+#define RIONET_GET_DESTID(x)	((*((u8 *)x + 4) << 8) | *((u8 *)x + 5))
 
 static int rionet_rx_clean(struct net_device *ndev)
 {


