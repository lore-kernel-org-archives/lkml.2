Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab2GXUMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:12:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48091 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab2GXUMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:12:31 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH v2 2/2] nconf: add u, d command keys in scroll windows
Date: Tue, 24 Jul 2012 16:12:03 -0400
Message-Id: <1343160723-14308-2-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1343160723-14308-1-git-send-email-bpoirier@suse.de>
References: <500EDDAF.4040506@xenotime.net>
 <1343160723-14308-1-git-send-email-bpoirier@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They function just like they do in less(1).
Also correct some discrepancy between the help text and the code wrt
function keys.

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
---
 scripts/kconfig/nconf.c     |    6 +++---
 scripts/kconfig/nconf.gui.c |    8 +++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 8c0eb65..8087e4d 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -83,10 +83,10 @@ static const char nconf_readme[] = N_(
 "Text Box    (Help Window)\n"
 "--------\n"
 "o  Use the cursor keys to scroll up/down/left/right.  The VI editor\n"
-"   keys h,j,k,l function here as do <SPACE BAR> for those\n"
-"   who are familiar with less and lynx.\n"
+"   keys h,j,k,l function here as do <u>, <d> and <SPACE BAR> for\n"
+"   those who are familiar with less and lynx.\n"
 "\n"
-"o  Press <Enter>, <F1>, <F5>, <F7> or <Esc> to exit.\n"
+"o  Press <Enter>, <F1>, <F5>, <F9>, <q> or <Esc> to exit.\n"
 "\n"
 "\n"
 "Alternate Configuration Files\n"
diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
index 3b18dd8..379003c 100644
--- a/scripts/kconfig/nconf.gui.c
+++ b/scripts/kconfig/nconf.gui.c
@@ -604,9 +604,11 @@ void show_scroll_win(WINDOW *main_window,
 		switch (res) {
 		case KEY_NPAGE:
 		case ' ':
+		case 'd':
 			start_y += text_lines-2;
 			break;
 		case KEY_PPAGE:
+		case 'u':
 			start_y -= text_lines+2;
 			break;
 		case KEY_HOME:
@@ -632,10 +634,10 @@ void show_scroll_win(WINDOW *main_window,
 			start_x++;
 			break;
 		}
-		if (res == 10 || res == 27 || res == 'q'
-		    || res == KEY_F(F_BACK) || res == KEY_F(F_EXIT)) {
+		if (res == 10 || res == 27 || res == 'q' ||
+			res == KEY_F(F_HELP) || res == KEY_F(F_BACK) ||
+			res == KEY_F(F_EXIT))
 			break;
-		}
 		if (start_y < 0)
 			start_y = 0;
 		if (start_y >= total_lines-text_lines)
-- 
1.7.7

