Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab0K1VAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 16:00:36 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:37403 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab0K1VAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 16:00:17 -0500
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 02/13] w35und: Kill _USE_FALLBACK_RATE_ macro
Date: Sun, 28 Nov 2010 22:59:57 +0200
Message-Id: <1290978008-29095-2-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290978008-29095-1-git-send-email-penberg@kernel.org>
References: <1290978008-29095-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The _USE_FALLBACK_RATE_ macro parametrizes DEFAULT_RATE_RETRY_LIMIT. It's only
used in Mxx_initial() in reg.c where _USE_FALLBACK_RATE_ is always defined
because the reg.c file includes sysdef.h at the top. It's therefore safe to
remove the _USE_FALLBACK_RATE_ macro.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/sysdef.h    |    2 --
 drivers/staging/winbond/wb35reg_s.h |    4 ----
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/winbond/sysdef.h b/drivers/staging/winbond/sysdef.h
index 7198708..f8d8606 100644
--- a/drivers/staging/winbond/sysdef.h
+++ b/drivers/staging/winbond/sysdef.h
@@ -3,8 +3,6 @@
 #ifndef SYS_DEF_H
 #define SYS_DEF_H
 
-#define _USE_FALLBACK_RATE_
-
 #define _WPA2_
 
 /* debug print options, mark what debug you don't need */
diff --git a/drivers/staging/winbond/wb35reg_s.h b/drivers/staging/winbond/wb35reg_s.h
index 9d5993b..9b782ed 100644
--- a/drivers/staging/winbond/wb35reg_s.h
+++ b/drivers/staging/winbond/wb35reg_s.h
@@ -51,11 +51,7 @@ struct hw_data;
 #define DEFAULT_CWMAX			1023	/* (M2C) CWmax. Its value is in the range 0-1023. */
 #define DEFAULT_AID			1	/* (M34) AID. Its value is in the range 1-2007. */
 
-#ifdef _USE_FALLBACK_RATE_
 #define DEFAULT_RATE_RETRY_LIMIT	2	/* (M38) as named */
-#else
-#define DEFAULT_RATE_RETRY_LIMIT	7	/* (M38) as named */
-#endif
 
 #define DEFAULT_LONG_RETRY_LIMIT	7	/* (M38) LongRetryLimit. Its value is in the range 0-15. */
 #define DEFAULT_SHORT_RETRY_LIMIT	7	/* (M38) ShortRetryLimit. Its value is in the range 0-15. */
-- 
1.7.0.4

