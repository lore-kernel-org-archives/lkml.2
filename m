Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab2BCHOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:14:46 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41715 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab2BCHOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:14:44 -0500
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-usb@vger.kernel.org
Subject: [Patch] musb: fix a build error on mips
Date: Fri,  3 Feb 2012 15:14:17 +0800
Message-Id: <1328253257-14092-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On mips, we got:

drivers/usb/musb/musb_io.h:44: error: conflicting types for 'readsl'
arch/mips/include/asm/io.h:529: error: previous definition of 'readsl' was here
drivers/usb/musb/musb_io.h:46: error: conflicting types for 'readsw'
arch/mips/include/asm/io.h:528: error: previous definition of 'readsw' was here
drivers/usb/musb/musb_io.h:48: error: conflicting types for 'readsb'

so, should add !defined(CONFIG_MIPS) too.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/drivers/usb/musb/musb_io.h b/drivers/usb/musb/musb_io.h
index e61aa95..1d5eda2 100644
--- a/drivers/usb/musb/musb_io.h
+++ b/drivers/usb/musb/musb_io.h
@@ -39,7 +39,8 @@
 
 #if !defined(CONFIG_ARM) && !defined(CONFIG_SUPERH) \
 	&& !defined(CONFIG_AVR32) && !defined(CONFIG_PPC32) \
-	&& !defined(CONFIG_PPC64) && !defined(CONFIG_BLACKFIN)
+	&& !defined(CONFIG_PPC64) && !defined(CONFIG_BLACKFIN) \
+	&& !defined(CONFIG_MIPS)
 static inline void readsl(const void __iomem *addr, void *buf, int len)
 	{ insl((unsigned long)addr, buf, len); }
 static inline void readsw(const void __iomem *addr, void *buf, int len)
