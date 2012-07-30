Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab2G3TW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:22:57 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47581 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2G3TWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:22:55 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 1/6] menuconfig: Remove superfluous conditionnal
Date: Mon, 30 Jul 2012 15:22:05 -0400
Message-Id: <1343676130-29770-2-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1343676130-29770-1-git-send-email-bpoirier@suse.de>
References: <1343676130-29770-1-git-send-email-bpoirier@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because end_reached is set to 0 before the loop, the test "!end_reached" is
always true and can be removed. This structure was perhaps copied from the
similar one in back_lines().

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
---
 scripts/kconfig/lxdialog/textbox.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/scripts/kconfig/lxdialog/textbox.c b/scripts/kconfig/lxdialog/textbox.c
index 4e5de60..264a2b9 100644
--- a/scripts/kconfig/lxdialog/textbox.c
+++ b/scripts/kconfig/lxdialog/textbox.c
@@ -357,10 +357,8 @@ static char *get_line(void)
 	end_reached = 0;
 	while (*page != '\n') {
 		if (*page == '\0') {
-			if (!end_reached) {
-				end_reached = 1;
-				break;
-			}
+			end_reached = 1;
+			break;
 		} else if (i < MAX_LEN)
 			line[i++] = *(page++);
 		else {
@@ -373,7 +371,7 @@ static char *get_line(void)
 	if (i <= MAX_LEN)
 		line[i] = '\0';
 	if (!end_reached)
-		page++;		/* move pass '\n' */
+		page++;		/* move past '\n' */
 
 	return line;
 }
-- 
1.7.7

