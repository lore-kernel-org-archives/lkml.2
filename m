Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416Ab0KSWWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:22:10 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:59202 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab0KSV6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:54 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: thomas@winischhofer.net, aaro.koskinen@iki.fi
Subject: [PATCH 7/9] sisfb: replace SiS_SetMemory with memset_io
Date: Fri, 19 Nov 2010 23:58:49 +0200
Message-Id: <1290203931-25188-8-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1290203931-25188-1-git-send-email-aaro.koskinen@iki.fi>
References: <1290203931-25188-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of one more wrapper.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/init.c  |    4 ++--
 drivers/video/sis/osdef.h |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/sis/init.c b/drivers/video/sis/init.c
index bfc6a1a..31137ad 100644
--- a/drivers/video/sis/init.c
+++ b/drivers/video/sis/init.c
@@ -1578,7 +1578,7 @@ SiS_ClearBuffer(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
 
    if(SiS_Pr->SiS_ModeType >= ModeEGA) {
       if(ModeNo > 0x13) {
-	 SiS_SetMemory(memaddr, memsize, 0);
+	 memset_io(memaddr, 0, memsize);
       } else {
 	 pBuffer = (unsigned short SISIOMEMTYPE *)memaddr;
 	 for(i = 0; i < 0x4000; i++) writew(0x0000, &pBuffer[i]);
@@ -1587,7 +1587,7 @@ SiS_ClearBuffer(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
       pBuffer = (unsigned short SISIOMEMTYPE *)memaddr;
       for(i = 0; i < 0x4000; i++) writew(0x0720, &pBuffer[i]);
    } else {
-      SiS_SetMemory(memaddr, 0x8000, 0);
+      memset_io(memaddr, 0, 0x8000);
    }
 }
 
diff --git a/drivers/video/sis/osdef.h b/drivers/video/sis/osdef.h
index be7f306..af5e9a2 100644
--- a/drivers/video/sis/osdef.h
+++ b/drivers/video/sis/osdef.h
@@ -63,6 +63,4 @@
 #warning sisfb will not work!
 #endif
 
-#define SiS_SetMemory(MemoryAddress,MemorySize,value) memset_io(MemoryAddress, value, MemorySize)
-
 #endif  /* _OSDEF_H_ */
-- 
1.5.6.5

