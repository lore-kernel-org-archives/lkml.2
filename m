Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab0CYFRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:17:37 -0400
Received: from mail.perches.com ([173.55.12.10]:1105 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab0CYFRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:17:35 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 11/13] drivers/staging/vt6655: Hoist assign from if
Date: Wed, 24 Mar 2010 22:17:05 -0700
Message-Id: <8628ca12402a0806eebb7fee9c8cb980e0448401.1269493047.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1269493047.git.joe@perches.com>
References: <cover.1269493047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/vt6655/desc.h        |    6 ++++--
 drivers/staging/vt6655/device.h      |    6 ++++--
 drivers/staging/vt6655/device_main.c |    3 ++-
 drivers/staging/vt6655/iwctl.c       |    3 ++-
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index b573ef7..78c863a 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -232,7 +232,8 @@ typedef struct tagDEVICE_RD_INFO {
 /*
 static inline PDEVICE_RD_INFO alloc_rd_info(void) {
     PDEVICE_RD_INFO  ptr;
-    if ((ptr = kmalloc(sizeof(DEVICE_RD_INFO), GFP_ATOMIC)) == NULL)
+    ptr = kmalloc(sizeof(DEVICE_RD_INFO), GFP_ATOMIC);
+    if (ptr == NULL)
         return NULL;
     else {
         memset(ptr,0,sizeof(DEVICE_RD_INFO));
@@ -361,7 +362,8 @@ typedef struct tagDEVICE_TD_INFO{
 /*
 static inline PDEVICE_TD_INFO alloc_td_info(void) {
     PDEVICE_TD_INFO  ptr;
-    if ((ptr = kmalloc(sizeof(DEVICE_TD_INFO),GFP_ATOMIC))==NULL)
+    ptr = kmalloc(sizeof(DEVICE_TD_INFO),GFP_ATOMIC);
+    if (ptr==NULL)
         return NULL;
     else {
         memset(ptr,0,sizeof(DEVICE_TD_INFO));
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index cde44d2..7a9f406 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -898,7 +898,8 @@ inline static BOOL device_get_ip(PSDevice pInfo) {
 
 static inline PDEVICE_RD_INFO alloc_rd_info(void) {
     PDEVICE_RD_INFO  ptr;
-    if ((ptr = (PDEVICE_RD_INFO)kmalloc((int)sizeof(DEVICE_RD_INFO), (int)GFP_ATOMIC)) == NULL)
+    ptr = (PDEVICE_RD_INFO)kmalloc((int)sizeof(DEVICE_RD_INFO), (int)GFP_ATOMIC);
+    if (ptr == NULL)
         return NULL;
     else {
         memset(ptr,0,sizeof(DEVICE_RD_INFO));
@@ -908,7 +909,8 @@ static inline PDEVICE_RD_INFO alloc_rd_info(void) {
 
 static inline PDEVICE_TD_INFO alloc_td_info(void) {
     PDEVICE_TD_INFO  ptr;
-    if ((ptr = (PDEVICE_TD_INFO)kmalloc((int)sizeof(DEVICE_TD_INFO), (int)GFP_ATOMIC))==NULL)
+    ptr = (PDEVICE_TD_INFO)kmalloc((int)sizeof(DEVICE_TD_INFO), (int)GFP_ATOMIC);
+    if (ptr == NULL)
         return NULL;
     else {
         memset(ptr,0,sizeof(DEVICE_TD_INFO));
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 1d64365..66fe7ba 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -637,7 +637,8 @@ byValue1 = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_ANTENNA);
 //2008-8-4 <add> by chester
 //zonetype initial
  pDevice->byOriginalZonetype = pDevice->abyEEPROM[EEP_OFS_ZONETYPE];
- if((zonetype=Config_FileOperation(pDevice,FALSE,NULL)) >= 0) {         //read zonetype file ok!
+ zonetype = Config_FileOperation(pDevice,FALSE,NULL);
+ if (zonetype >= 0) {         //read zonetype file ok!
   if ((zonetype == 0)&&
         (pDevice->abyEEPROM[EEP_OFS_ZONETYPE] !=0x00)){          //for USA
     pDevice->abyEEPROM[EEP_OFS_ZONETYPE] = 0;
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 78b4983..2f26c6d 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -1702,7 +1702,8 @@ int iwctl_giwpower(struct net_device *dev,
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWPOWER \n");
 
 
-	if ((wrq->disabled = (mode == WMAC_POWER_CAM)))
+	wrq->disabled = (mode == WMAC_POWER_CAM);
+	if (wrq->disabled)
 	    return 0;
 
 	if ((wrq->flags & IW_POWER_TYPE) == IW_POWER_TIMEOUT) {
-- 
1.7.0.14.g7e948

