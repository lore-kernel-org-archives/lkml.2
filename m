Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab2GXBiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 21:38:16 -0400
Received: from marvin.crapouillou.net ([109.190.31.181]:56571 "EHLO
	marvin.crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab2GXBiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 21:38:12 -0400
From: Paul Cercueil <paul@crapouillou.net>
To: FlorianSchandinat@gmx.de
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>
Subject: [PATCH 2/4] fbcon: prevent possible buffer overflow.
Date: Tue, 24 Jul 2012 03:00:24 +0200
Message-Id: <1343091626-11435-2-git-send-email-paul@crapouillou.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1343091626-11435-1-git-send-email-paul@crapouillou.net>
References: <1343091626-11435-1-git-send-email-paul@crapouillou.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/video/console/fbcon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index a0b1818..3ffab97 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -442,7 +442,7 @@ static int __init fb_console_setup(char *this_opt)
 
 	while ((options = strsep(&this_opt, ",")) != NULL) {
 		if (!strncmp(options, "font:", 5))
-			strcpy(fontname, options + 5);
+			strlcpy(fontname, options + 5, sizeof(fontname));
 		
 		if (!strncmp(options, "scrollback:", 11)) {
 			char *k;
-- 
1.7.10.4

