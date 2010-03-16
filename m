Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab0CPWhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 18:37:32 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:35372 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab0CPWha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 18:37:30 -0400
X-SENDER-IP: [83.226.251.83]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnI+AG+ln0tT4vtTPGdsb2JhbACHYJMjDAEBAQE3LaxEjXCEdgQ
X-IronPort-AV: E=Sophos;i="4.49,652,1262559600"; 
   d="scan'208";a="51383647"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz,
       diegoliz@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: mds.c: converted long if-else to switch
Date: Tue, 16 Mar 2010 23:37:28 +0100
Message-Id: <1268779048-21397-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I converted the long if-else in function Mds_HeaderCopy() to a switch
instead. It compiles fine but i don't have the hardware to test.
Please check that I didn't do anything bad to it..
The patch applies on top of this patch:
Message-Id: <1268670973-6223-1-git-send-email-lindley@coyote.org>

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/winbond/mds.c |   38 +++++++++++++++++++++++---------------
 1 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index ef08b51..6082fa8 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -400,30 +400,38 @@ static void Mds_HeaderCopy(struct wbsoft_priv *adapter,
 							       * back rate
 							       */
 
-		if (ctmp1 == 108)
+		switch (ctmp1) {
+		case 108:
 			ctmp2 = 7;
-		else if (ctmp1 == 96)
+			break;
+		case 96:
 			ctmp2 = 6;	/* Rate convert for USB */
-		else if (ctmp1 == 72)
+			break;
+		case 72:
 			ctmp2 = 5;
-		else if (ctmp1 == 48)
+			break;
+		case 48:
 			ctmp2 = 4;
-		else if (ctmp1 == 36)
+			break;
+		case 36:
+		case 22:
 			ctmp2 = 3;
-		else if (ctmp1 == 24)
+			break;
+		case 24:
+		case 11:
 			ctmp2 = 2;
-		else if (ctmp1 == 18)
+			break;
+		case 18:
+		case 4:
 			ctmp2 = 1;
-		else if (ctmp1 == 12)
+			break;
+		case 12:
 			ctmp2 = 0;
-		else if (ctmp1 == 22)
-			ctmp2 = 3;
-		else if (ctmp1 == 11)
-			ctmp2 = 2;
-		else if (ctmp1 == 4)
-			ctmp2 = 1;
-		else
+			break;
+		default:
 			ctmp2 = 0;	/* if (ctmp1 == 2) or default */
+			break;
+		}
 
 		if (i == 0)
 			pT01->T01_transmit_rate = ctmp2;
-- 
1.7.0.2

