Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab0HTR6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 13:58:04 -0400
Received: from server103.greatnet.de ([83.133.97.6]:36709 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab0HTR6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 13:58:01 -0400
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: dbrownell@users.sourceforge.net
Cc: gregkh@suse.de, davem@davemloft.net, eric.dumazet@gmail.com,
        henne@nachtwindheim.de, tj@kernel.org, bniebuhr@efjohnson.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rndis: section mismatch fix
Date: Fri, 20 Aug 2010 19:57:50 +0200
Message-Id: <1282327070-5100-1-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the following section mismatch warning,
by moving the function rndis_init() from .init.text to .text.

WARNING: vmlinux.o(.text+0x1aeca5a): Section mismatch in reference from the function rndis_bind_config() to the function .init.text:rndis_init()
The function rndis_bind_config() references
the function __init rndis_init().
This is often because rndis_bind_config lacks a __init
annotation or the annotation of rndis_init is wrong.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
This patch is against Linus tree and tested.

 drivers/usb/gadget/rndis.c |    2 +-
 drivers/usb/gadget/rndis.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/rndis.c b/drivers/usb/gadget/rndis.c
index 020fa5a..ee337f7 100644
--- a/drivers/usb/gadget/rndis.c
+++ b/drivers/usb/gadget/rndis.c
@@ -1148,7 +1148,7 @@ static struct proc_dir_entry *rndis_connect_state [RNDIS_MAX_CONFIGS];
 #endif	/* CONFIG_USB_GADGET_DEBUG_FILES */
 
 
-int __init rndis_init (void)
+int rndis_init(void)
 {
 	u8 i;
 
diff --git a/drivers/usb/gadget/rndis.h b/drivers/usb/gadget/rndis.h
index c236aaa..907c330 100644
--- a/drivers/usb/gadget/rndis.h
+++ b/drivers/usb/gadget/rndis.h
@@ -262,7 +262,7 @@ int  rndis_signal_disconnect (int configNr);
 int  rndis_state (int configNr);
 extern void rndis_set_host_mac (int configNr, const u8 *addr);
 
-int __devinit rndis_init (void);
+int rndis_init(void);
 void rndis_exit (void);
 
 #endif  /* _LINUX_RNDIS_H */
-- 
1.7.0.4

