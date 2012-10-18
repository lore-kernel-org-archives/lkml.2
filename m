Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab2JRTn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:43:59 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:19173 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab2JRTn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:43:58 -0400
Date: Thu, 18 Oct 2012 21:43:55 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Daniel Cotey <puff65537@bansheeslibrary.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: silicom: Fix up version.h includes
Message-ID: <alpine.LNX.2.00.1210182142050.17217@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/silicom/bypasslib/bplibk.h actually uses stuff from
version.h so it should include the header.
drivers/staging/silicom/bp_proc.c and
drivers/staging/silicom/bypasslib/bypass.c currently include the
header but use nothing from it so they don't need to.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/silicom/bp_proc.c          |    1 -
 drivers/staging/silicom/bypasslib/bplibk.h |    1 +
 drivers/staging/silicom/bypasslib/bypass.c |    1 -
 3 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/silicom/bp_proc.c b/drivers/staging/silicom/bp_proc.c
index 6ad4b27..32799c7 100644
--- a/drivers/staging/silicom/bp_proc.c
+++ b/drivers/staging/silicom/bp_proc.c
@@ -10,7 +10,6 @@
 /*                                                                            */
 /******************************************************************************/
 
-#include <linux/version.h>
 #if defined(CONFIG_SMP) && ! defined(__SMP__)
 #define __SMP__
 #endif
diff --git a/drivers/staging/silicom/bypasslib/bplibk.h b/drivers/staging/silicom/bypasslib/bplibk.h
index a1c85ee..e9db2d1 100644
--- a/drivers/staging/silicom/bypasslib/bplibk.h
+++ b/drivers/staging/silicom/bypasslib/bplibk.h
@@ -15,6 +15,7 @@
 
 #include "bp_ioctl.h"
 #include "libbp_sd.h"
+#include <linux/version.h>
 
 #define IF_NAME            "eth"
 #define SILICOM_VID        0x1374
diff --git a/drivers/staging/silicom/bypasslib/bypass.c b/drivers/staging/silicom/bypasslib/bypass.c
index 527829d..95a1f18 100644
--- a/drivers/staging/silicom/bypasslib/bypass.c
+++ b/drivers/staging/silicom/bypasslib/bypass.c
@@ -11,7 +11,6 @@
 /*                                                                            */
 /******************************************************************************/
 
-#include <linux/version.h>
 #if defined(CONFIG_SMP) && ! defined(__SMP__)
 #define __SMP__
 #endif
-- 
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

