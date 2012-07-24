Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab2GXBiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 21:38:17 -0400
Received: from marvin.crapouillou.net ([109.190.31.181]:56916 "EHLO
	marvin.crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab2GXBiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 21:38:14 -0400
From: Paul Cercueil <paul@crapouillou.net>
To: FlorianSchandinat@gmx.de
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>
Subject: [PATCH 3/4] fbcon: continue parsing parameters after an error.
Date: Tue, 24 Jul 2012 03:00:25 +0200
Message-Id: <1343091626-11435-3-git-send-email-paul@crapouillou.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1343091626-11435-1-git-send-email-paul@crapouillou.net>
References: <1343091626-11435-1-git-send-email-paul@crapouillou.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/video/console/fbcon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 3ffab97..9b83b75 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -481,9 +481,9 @@ static int __init fb_console_setup(char *this_opt)
 				}
 
 				fbcon_map_override();
+			} else {
+				pr_warn("fbcon: map: incorrect value.\n");
 			}
-
-			return 1;
 		}
 
 		if (!strncmp(options, "vc:", 3)) {
-- 
1.7.10.4

