Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab2FKJN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:13:28 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38783 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab2FKJN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:13:27 -0400
Date: Mon, 11 Jun 2012 11:13:15 +0200
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: [PATCH 2/2] drivers: usb: gadget: add multiple definition guards
In-reply-to: <Pine.LNX.4.44L0.1206071646360.1185-100000@iolanthe.rowland.org>
To: linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mnazarewicz@gmail.com>,
        Benoit Goby <benoit@android.com>, Mike Lockwood <lockwood@android.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Message-id: <1339405995-6298-1-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
Content-transfer-encoding: 7BIT
References: <Pine.LNX.4.44L0.1206071646360.1185-100000@iolanthe.rowland.org>
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If f_fs.c and u_serial.c are combined together using #include, which has
been a common practice so far, the pr_vdebug macro is defined multiple
times. Define it only once.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/f_fs.c     |    4 ++++
 drivers/usb/gadget/u_serial.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index dcd1c7f..27c841d 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -33,11 +33,15 @@
 /* Debugging ****************************************************************/
 
 #ifdef VERBOSE_DEBUG
+#ifndef pr_vdebug
 #  define pr_vdebug pr_debug
+#endif /* pr_vdebug */
 #  define ffs_dump_mem(prefix, ptr, len) \
 	print_hex_dump_bytes(pr_fmt(prefix ": "), DUMP_PREFIX_NONE, ptr, len)
 #else
+#ifndef pr_vdebug
 #  define pr_vdebug(...)                 do { } while (0)
+#endif /* pr_vdebug */
 #  define ffs_dump_mem(prefix, ptr, len) do { } while (0)
 #endif /* VERBOSE_DEBUG */
 
diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
index 5b3f5ff..da6d479 100644
--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -132,11 +132,15 @@ static unsigned	n_ports;
 
 
 #ifdef VERBOSE_DEBUG
+#ifndef pr_vdebug
 #define pr_vdebug(fmt, arg...) \
 	pr_debug(fmt, ##arg)
+#endif /* pr_vdebug */
 #else
+#ifndef pr_vdebig
 #define pr_vdebug(fmt, arg...) \
 	({ if (0) pr_debug(fmt, ##arg); })
+#endif /* pr_vdebug */
 #endif
 
 /*-------------------------------------------------------------------------*/
-- 
1.7.0.4

