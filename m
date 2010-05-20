Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab0ETUkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 16:40:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37921 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab0ETUkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 16:40:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=L1wVmqJarCUQ7euMqXqQYksK4i3EX1HLC4pac80Te3IK0HHaaLlyR8vhswZsh8ZLmC
         +HoiFWtRcqz49E4VDszxnhoeYM3EiZu6iCggtiE3f3MaNbxfxZ54cyE9C08GD7OjW6iS
         /oFRCrFlOSRdIPjiUOLDW38/zImCfyRtrQPtQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-pcmcia@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]pacmcia:yena_socket.c Remove extra #ifdef CONFIG_YENTA_TI
Date: Thu, 20 May 2010 13:40:02 -0700
Message-Id: <1274388002-2132-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems pointless to have two #ifdef's with the same
CONFIG_YENTA_TI.. Remove the extra one and
move CARDBUS_TYPE_ENE with the others.

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/pcmcia/yenta_socket.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index 83ace27..5a09bbb 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -880,6 +880,12 @@ static struct cardbus_type cardbus_type[] = {
 		.restore_state	= ti_restore_state,
 		.sock_init	= ti_init,
 	},
+	[CARDBUS_TYPE_ENE]	= {
+		.override	= ene_override,
+		.save_state	= ti_save_state,
+		.restore_state	= ti_restore_state,
+		.sock_init	= ti_init,
+	},
 #endif
 #ifdef CONFIG_YENTA_RICOH
 	[CARDBUS_TYPE_RICOH]	= {
@@ -902,14 +908,6 @@ static struct cardbus_type cardbus_type[] = {
 		.restore_state	= o2micro_restore_state,
 	},
 #endif
-#ifdef CONFIG_YENTA_TI
-	[CARDBUS_TYPE_ENE]	= {
-		.override	= ene_override,
-		.save_state	= ti_save_state,
-		.restore_state	= ti_restore_state,
-		.sock_init	= ti_init,
-	},
-#endif
 };
 
 
-- 
1.6.5.2.180.gc5b3e

