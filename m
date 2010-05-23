Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab0EWCpO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 22:45:14 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55922 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755678Ab0EWCpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 22:45:12 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-usb@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>
Cc: Cliff Cai <cliff.cai@analog.com>, uclinux-dist-devel@blackfin.uclinux.org,
       stable@kernel.org, stable-review@kernel.org,
       linux-kernel@vger.kernel.org, Ian Jeffray <ian@jeffray.co.uk>
Subject: [PATCH] USB: musb: fix Blackfin building after power updates
Date: Sat, 22 May 2010 22:49:08 -0400
Message-Id: <1274582948-11499-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Jeffray <ian@jeffray.co.uk>

The new MUSB power code needs musb_read_txhubport() to return a value (so
stub it as 0 like the other Blackfin hub funcs).  It also needs new helper
functions for saving/restoring context, so change the apparently unused
musb_platform_{suspend,resume} to musb_platform_{save,restore}_context in
the Blackfin code.

Signed-off-by: Ian Jeffray <ian@jeffray.co.uk>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
Note: this is for 2.6.34.x and 2.6.35
Note: i believe this is what we want, but Cliff is free to correct me ;)

 drivers/usb/musb/blackfin.c  |   12 ++++++++++++
 drivers/usb/musb/musb_regs.h |    3 ++-
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index b611420..b5f1d17 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -392,6 +392,18 @@ int __init musb_platform_init(struct musb *musb, void *board_data)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+void musb_platform_save_context(struct musb *musb,
+			struct musb_context_registers *musb_context)
+{
+}
+
+void musb_platform_restore_context(struct musb *musb,
+			struct musb_context_registers *musb_context)
+{
+}
+#endif
+
 int musb_platform_exit(struct musb *musb)
 {
 
diff --git a/drivers/usb/musb/musb_regs.h b/drivers/usb/musb/musb_regs.h
index 2442675..5a727c5 100644
--- a/drivers/usb/musb/musb_regs.h
+++ b/drivers/usb/musb/musb_regs.h
@@ -633,8 +633,9 @@ static inline u8  musb_read_txhubaddr(void __iomem *mbase, u8 epnum)
 	return 0;
 }
 
-static inline void  musb_read_txhubport(void __iomem *mbase, u8 epnum)
+static inline u8 musb_read_txhubport(void __iomem *mbase, u8 epnum)
 {
+	return 0;
 }
 
 #endif /* CONFIG_BLACKFIN */
-- 
1.7.1

