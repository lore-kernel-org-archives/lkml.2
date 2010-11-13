Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab0KMX2r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 18:28:47 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45376 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab0KMX2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 18:28:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Doub5GceOCQnyk4O6xg4OX/eCgTek6TqyB/0q+JHV4Dst7M8GxH/e9IWv60X1BZfA1
         Sb/R+J3kThlONjWt7MlpUHAmU2uHguhnX7JPpkiFsrYKW0m6Gg6E7XsmNW/846TY6vaT
         aLpR+0mUWZ790RUoOSiX/EQZCdlE4xI9oQ7co=
From: Tracey Dent <tdent48227@gmail.com>
To: len.brown@intel.com
Cc: pavel@ucw.cz, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, akpm@linux-foundation.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH] kernel/power/: Changed Makefile to use proper ccflag flag
Date: Sat, 13 Nov 2010 18:28:34 -0500
Message-Id: <1289690914-3752-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the ccflags-$ flag instead of EXTRA_CFLAGS because EXTRA_CFLAGS is
deprecated and should now be switched. According to (documentation/kbuild/makefiles.txt).

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 kernel/power/Makefile |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index f9063c6..b755972 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -1,7 +1,4 @@
-
-ifeq ($(CONFIG_PM_DEBUG),y)
-EXTRA_CFLAGS	+=	-DDEBUG
-endif
+ccflags-$(CONFIG_PM_DEBUG)	:=	-DDEBUG
 
 obj-$(CONFIG_PM)		+= main.o
 obj-$(CONFIG_PM_SLEEP)		+= console.o
-- 
1.7.3.2.164.g6f10c

