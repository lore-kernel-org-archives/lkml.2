Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab1A1EFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:05:13 -0500
Received: from mail.perches.com ([173.55.12.10]:3444 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab1A1EEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:04:54 -0500
From: Joe Perches <joe@perches.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/15] staging: ath6kl: Convert BDADDR_Present uses to TRUE/FALSE bugfix
Date: Thu, 27 Jan 2011 20:04:25 -0800
Message-Id: <13959f0f652d5bd17537e669a8cb82560b96a4d5.1296186677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1296186677.git.joe@perches.com>
References: <cover.1296186677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous uses of BDADDR_Present set the initial value to
A_ERROR (-1) when not present and A_OK (0) when present.

A later test for (!BDADDR_Present) was therefore logically inverted.
Convert the values to TRUE/FALSE and the test is now logically correct.

Signed-off-by: Joe Perches <joe@perches.com>
---
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c   |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
index 3b2c0cc..5df1766 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
+++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
@@ -663,7 +663,7 @@ int AthDoParsePS(A_UCHAR *srcbuffer, A_UINT32 srclen)
 {
     int status;
     int i;
-    A_BOOL BDADDR_Present = A_ERROR;
+    A_BOOL BDADDR_Present = FALSE;
 
     Tag_Count = 0;
 
@@ -689,7 +689,7 @@ int AthDoParsePS(A_UCHAR *srcbuffer, A_UINT32 srclen)
         else{
                 for(i=0; i<Tag_Count; i++){
                         if(PsTagEntry[i].TagId == 1){
-                                BDADDR_Present = A_OK;
+                                BDADDR_Present = TRUE;
                                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("BD ADDR is present in Patch File \r\n"));
 
                         }
-- 
1.7.4.rc3

