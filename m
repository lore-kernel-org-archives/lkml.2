Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934279Ab2HWSz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:55:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37344 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934224Ab2HWSzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:55:52 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Borislav Petkov <bp@alien8.de>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Jean Sacren <sakiwit@gmail.com>, Arnaud Lacombe <lacombar@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Davidlohr Bueso <dave@gnu.org>, Wang YanQing <udknight@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Cheng Renquan <crquan@gmail.com>
Subject: [PATCH v2 1/6] menuconfig: Remove superfluous conditionnal
Date: Thu, 23 Aug 2012 14:55:03 -0400
Message-Id: <1345748108-12206-2-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1345748108-12206-1-git-send-email-bpoirier@suse.de>
References: <1345748108-12206-1-git-send-email-bpoirier@suse.de>
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

