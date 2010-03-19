Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab0CSUl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:41:59 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63504 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab0CSUly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:41:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=we2gQT6Wj4Ui3IrYmyJlYK9RHnez7oDsz6/e30P8KYS4YNQW4aHNpoCZLSuCJYlKNb
         d8IxphuohbLF5jgcgpp0IPaCWZgJZQdfWkQk1U67OYpfEVfx/0l1BejRZvTP4DnAScO/
         wD6J7xWZ8xBTRWqjOGGy+0/foWv0MMm5E9utM=
From: Sankar P <sankar.curiosity@gmail.com>
To: gregkh@suse.de, pavel@ucw.cz, penberg@cs.helsinki.fi,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       sankar.curiosity@gmail.com
Subject: [PATCH 4/6] staging: winbond: Remove typedef for standard types
Date: Sat, 20 Mar 2010 02:11:02 +0530
Message-Id: <1269031264-2327-5-git-send-email-sankar.curiosity@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269031264-2327-4-git-send-email-sankar.curiosity@gmail.com>
References: <1269031264-2327-1-git-send-email-sankar.curiosity@gmail.com>
 <1269031264-2327-2-git-send-email-sankar.curiosity@gmail.com>
 <1269031264-2327-3-git-send-email-sankar.curiosity@gmail.com>
 <1269031264-2327-4-git-send-email-sankar.curiosity@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the typedef named "fixed" used for the standard type s32

Signed-off-by: Sankar P <sankar.curiosity@gmail.com>
---
 drivers/staging/winbond/phy_calibration.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
index 8c56962..a8334f9 100644
--- a/drivers/staging/winbond/phy_calibration.c
+++ b/drivers/staging/winbond/phy_calibration.c
@@ -25,10 +25,7 @@
 #define FIXED(X)        ((s32)((X) * 32768.0))
 #define DEG2RAD(X)      0.017453 * (X)
 
-/****************** LOCAL TYPE DEFINITION SECTION ***************************/
-typedef s32         fixed; /* 16.16 fixed-point */
-
-static const fixed Angles[]=
+static const s32 Angles[] =
 {
     FIXED(DEG2RAD(45.0)),    FIXED(DEG2RAD(26.565)),  FIXED(DEG2RAD(14.0362)),
     FIXED(DEG2RAD(7.12502)), FIXED(DEG2RAD(3.57633)), FIXED(DEG2RAD(1.78991)),
@@ -300,7 +297,7 @@ u32 _sqrt(u32 sqsum)
 /****************************************************************************/
 void _sin_cos(s32 angle, s32 *sin, s32 *cos)
 {
-    fixed       X, Y, TargetAngle, CurrAngle;
+    s32 X, Y, TargetAngle, CurrAngle;
     unsigned    Step;
 
     X=FIXED(AG_CONST);      // AG_CONST * cos(0)
@@ -310,7 +307,7 @@ void _sin_cos(s32 angle, s32 *sin, s32 *cos)
 
     for (Step=0; Step < 12; Step++)
     {
-        fixed NewX;
+	s32 NewX;
 
         if(TargetAngle > CurrAngle)
         {
-- 
1.6.4.2

