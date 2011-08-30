Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab1H3S3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:29:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48472 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab1H3S3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:29:51 -0400
From: Pelle Windestam <iceaway@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>, Pelle Windestam <iceaway@gmail.com>
Subject: [PATCH 1/1] staging: panel: Fixed checkpatch warning about simple_strtoul()
Date: Tue, 30 Aug 2011 20:29:24 +0200
Message-Id: <1314728964-20863-1-git-send-email-iceaway@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning about sing simple_strtoul instead of
kstrtoul() in panel.c.

Signed-off-by: Pelle Windestam <iceaway@gmail.com>
---
 drivers/staging/panel/panel.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index b303b7e..4683d5f 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1179,16 +1179,14 @@ static inline int handle_lcd_special_code(void)
 			break;
 
 		while (*esc) {
-			char *endp;
-
 			if (*esc == 'x') {
 				esc++;
-				lcd_addr_x = simple_strtoul(esc, &endp, 10);
-				esc = endp;
+				if (kstrtoul(esc, 10, &lcd_addr_x) < 0)
+					break;
 			} else if (*esc == 'y') {
 				esc++;
-				lcd_addr_y = simple_strtoul(esc, &endp, 10);
-				esc = endp;
+				if (kstrtoul(esc, 10, &lcd_addr_y) < 0)
+					break;
 			} else
 				break;
 		}
-- 
1.7.3.4

