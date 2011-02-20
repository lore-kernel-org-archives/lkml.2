Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab1BTQyH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 11:54:07 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61256 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab1BTQxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 11:53:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ujbGpJlJIoc03Kk328rmrtOR7QObMIXDnUsNxG2l7cDbIVdHKOJUS4SYRdnckIRhcN
         0grv5+cxIQ1LPRSUmWfkqteJTI3PcU/IewhpwVlm2ek8J2yYS/wesGJ1Zy79CuzMEJcm
         q6JXpTvzvYeXnCEjX1qkcs0UOFLsJKTPgoNb0=
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bill Pemberton <wfp5p@virginia.edu>, Arnaud Patard <apatard@mandriva.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: [PATCH 2/2] Staging: xgifb: Removes CRIT[FLAGS | BEGIN | END] defines and conditional spinlock compilation logic
Date: Sun, 20 Feb 2011 17:53:18 +0100
Message-Id: <1298220798-2942-3-git-send-email-martinez.javier@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1298220798-2942-1-git-send-email-martinez.javier@gmail.com>
References: <1298220798-2942-1-git-send-email-martinez.javier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/xgifb/XGI_accel.h |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_accel.h b/drivers/staging/xgifb/XGI_accel.h
index 5a0395b..786ac24 100644
--- a/drivers/staging/xgifb/XGI_accel.h
+++ b/drivers/staging/xgifb/XGI_accel.h
@@ -18,19 +18,8 @@
 #ifndef _XGIFB_ACCEL_H
 #define _XGIFB_ACCEL_H
 
-/* Guard accelerator accesses with spin_lock_irqsave? Works well without. */
-#undef XGIFB_USE_SPINLOCKS
 
-#ifdef XGIFB_USE_SPINLOCKS
 #include <linux/spinlock.h>
-#define CRITBEGIN  spin_lock_irqsave(&xgi_video_info.lockaccel), critflags);
-#define CRITEND	   spin_unlock_irqrestore(&xgi_video_info.lockaccel), critflags);
-#define CRITFLAGS  unsigned long critflags;
-#else
-#define CRITBEGIN
-#define CRITEND
-#define CRITFLAGS
-#endif
 
 /* Definitions for the XGI engine communication. */
 
-- 
1.7.2.3

