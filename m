Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab0DOD7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 23:59:13 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:37804 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974Ab0DOD7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 23:59:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=yIIqkbwPwI+U0R40K9RcIwTXyRqLoayn47mC5PTpvUC33Rx2K4s3kDmu0vl5Ishd6+
         5I+Vf7vstgh0e4I3i5ck+c9LKlg9RQsbwr7LSu8/uPsOuI71FL7BZOIOdbvMUB6bI6We
         s4CJ7VhtPDMCVcX+xlfvO5Iwaqfoxg1J7WVzc=
MIME-Version: 1.0
Date: Thu, 15 Apr 2010 15:59:10 +1200
X-Google-Sender-Auth: 18e193a02997e317
Message-ID: <u2l7dc909981004142059p9a453a0gf761e496a65a77d3@mail.gmail.com>
Subject: [PATCH] fixed book E watchdog period register mask.
From: Luuk Paulussen <luuk.paulussen@alliedtelesis.co.nz>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Chris Friesen <cfriesen@nortel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Luuk Paulussen <luuk.paulussen@alliedtelesis.co.nz>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A previous fix changed the WDTP function to use the period directly,
rather than subtracting from 63.  However the mask generation was
not changed, so the mask was coming out as 0.  This patch fixes it.

Signed-off-by: Luuk Paulussen <luuk.paulussen@alliedtelesis.co.nz>
---
 drivers/watchdog/booke_wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index 8b724aa..500d383 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -44,7 +44,7 @@ u32 booke_wdt_period = WDT_PERIOD_DEFAULT;

 #ifdef	CONFIG_FSL_BOOKE
 #define WDTP(x)		((((x)&0x3)<<30)|(((x)&0x3c)<<15))
-#define WDTP_MASK	(WDTP(0))
+#define WDTP_MASK	(WDTP(0x3f))
 #else
 #define WDTP(x)		(TCR_WP(x))
 #define WDTP_MASK	(TCR_WP_MASK)
-- 
1.6.3.4
