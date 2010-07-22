Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab0GVQ6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 12:58:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55840 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab0GVQ5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 12:57:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Px3bNo/ojNSfXmiNiUbBYKN/EsUAyfBZkpORFMksJ+WwZYNEibZU49RvRbW6solH9K
         5OxtMIU3qxtFsE09eXWyaip1GmYO3Km/tPALCPFVG7Hg3pJJC14dT67svxTZyac5OLyW
         pa9oxayI0C21OIBOoKRqdNnyQZka4DLJkHL4E=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 3/5] staging: rtl8192su: don't use own isxdigit() method
Date: Thu, 22 Jul 2010 19:57:09 +0300
Message-Id: <86c5a78d51a8d52774ad97ae2cac09d9d1ed0793.1279817399.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <20100722151545.GA6696@suse.de>
References: <20100722151545.GA6696@suse.de>
In-Reply-To: <cover.1279817399.git.andy.shevchenko@gmail.com>
References: <cover.1279817399.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/rtl8192su/r8192S_Efuse.c |   27 +++------------------------
 1 files changed, 3 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/rtl8192su/r8192S_Efuse.c b/drivers/staging/rtl8192su/r8192S_Efuse.c
index 1e1d55e..c4bbe40 100644
--- a/drivers/staging/rtl8192su/r8192S_Efuse.c
+++ b/drivers/staging/rtl8192su/r8192S_Efuse.c
@@ -30,6 +30,7 @@
 #include "r8192S_Efuse.h"
 
 #include <linux/types.h>
+#include <linux/ctype.h>
 
 //typedef  int	INT32;
 //
@@ -1828,26 +1829,6 @@ EFUSE_ProgramMap(struct net_device* dev, char* pFileName,u8	TableType)
 
 #endif
 
-//
-//	Description:
-//		Return TRUE if chTmp is represent for hex digit and
-//		FALSE otherwise.
-//
-//
-bool IsHexDigit(	char chTmp)
-{
-	if( (chTmp >= '0' && chTmp <= '9') ||
-		(chTmp >= 'a' && chTmp <= 'f') ||
-		(chTmp >= 'A' && chTmp <= 'F') )
-	{
-		return TRUE;
-	}
-	else
-	{
-		return FALSE;
-	}
-}
-
 /*-----------------------------------------------------------------------------
  * Function:	efuse_ParsingMap
  *
@@ -1893,10 +1874,8 @@ efuse_ParsingMap(char* szStr,u32* pu4bVal,u32* pu4bMove)
 
 	// Check if szScan is now pointer to a character for hex digit,
 	// if not, it means this is not a valid hex number.
-	if(!IsHexDigit(*szScan))
-	{
+	if (!isxdigit(*szScan))
 		return FALSE;
-	}
 
 	// Parse each digit.
 	do
@@ -1905,7 +1884,7 @@ efuse_ParsingMap(char* szStr,u32* pu4bVal,u32* pu4bMove)
 
 		szScan++;
 		(*pu4bMove)++;
-	} while(IsHexDigit(*szScan));
+	} while (isxdigit(*szScan));
 
 	return TRUE;
 
-- 
1.7.1.1

