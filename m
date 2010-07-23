Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760342Ab0GWPpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:45:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:44017 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759017Ab0GWPpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:45:50 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+cVXVd+2OcJfQkThrZ3eQJ2dXjc9a93Nq77vsjyG
	oLoXDU9RTsV8H/
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: [PATCH 11/11] viafb: fix accel_flags check_var bug
Date: Fri, 23 Jul 2010 15:55:52 +0000
Message-Id: <1279900553-4525-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1279899566-4359-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1279899566-4359-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: fix accel_flags check_var bug

In check_var we should check and modify the var given and not the
one which is currently active. So this code was obviously wrong.
Probably this was doing no harm because all acceleration functions
also check whether acceleration is possible. (otherwise I would
expect this to lead to a null pointer dereference)

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
---
 drivers/video/via/viafbdev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 0f56eb2..bdd0e41 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -216,9 +216,9 @@ static int viafb_check_var(struct fb_var_screeninfo *var,
 
 	/* Adjust var according to our driver's own table */
 	viafb_fill_var_timing_info(var, viafb_refresh, vmode_entry);
-	if (info->var.accel_flags & FB_ACCELF_TEXT &&
+	if (var->accel_flags & FB_ACCELF_TEXT &&
 		!ppar->shared->vdev->engine_mmio)
-		info->var.accel_flags = 0;
+		var->accel_flags = 0;
 
 	return 0;
 }
-- 
1.6.3.2

