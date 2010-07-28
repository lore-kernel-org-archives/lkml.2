Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab0G1Ohl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:37:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60317 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795Ab0G1Ogb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:36:31 -0400
From: Ernesto Ramos <ernesto@ti.com>
To: gregkh@suse.de
Cc: omar.ramirez@ti.com, ohad@wizery.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, fernando.lugo@ti.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, nm@ti.com,
        linux-omap@vger.kernel.org, Ernesto Ramos <ernesto@ti.com>
Subject: [PATCH 5/5] staging:ti dspbridge: replace simple_strtoul by strict_strtoul
Date: Wed, 28 Jul 2010 09:40:52 -0500
Message-Id: <1280328052-31292-6-git-send-email-ernesto@ti.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1280328052-31292-5-git-send-email-ernesto@ti.com>
References: <1280328052-31292-1-git-send-email-ernesto@ti.com>
 <1280328052-31292-2-git-send-email-ernesto@ti.com>
 <1280328052-31292-3-git-send-email-ernesto@ti.com>
 <1280328052-31292-4-git-send-email-ernesto@ti.com>
 <1280328052-31292-5-git-send-email-ernesto@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace simple_strtoul by strict_strtoul in atoi function.

Signed-off-by: Ernesto Ramos <ernesto@ti.com>
---
 drivers/staging/tidspbridge/rmgr/dbdcd.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/dbdcd.c b/drivers/staging/tidspbridge/rmgr/dbdcd.c
index cceceb9..b96aea7 100644
--- a/drivers/staging/tidspbridge/rmgr/dbdcd.c
+++ b/drivers/staging/tidspbridge/rmgr/dbdcd.c
@@ -1012,6 +1012,8 @@ static s32 atoi(char *psz_buf)
 {
 	char *pch = psz_buf;
 	s32 base = 0;
+	unsigned long res;
+	int ret_val;
 
 	while (isspace(*pch))
 		pch++;
@@ -1023,7 +1025,9 @@ static s32 atoi(char *psz_buf)
 		base = 16;
 	}
 
-	return simple_strtoul(pch, NULL, base);
+	ret_val = strict_strtoul(pch, base, &res);
+
+	return ret_val ? : res;
 }
 
 /*
-- 
1.5.4.5

