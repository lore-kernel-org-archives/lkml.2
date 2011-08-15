Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab1HOOk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:40:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41735 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab1HOOkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:40:25 -0400
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kconfig: fix set but not used variables
Date: Mon, 15 Aug 2011 11:41:09 -0300
Message-Id: <1313419269-3860-1-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some variables were being set but never used, which was triggering
warnings in recent versions of GCC.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---
 scripts/kconfig/lxdialog/textbox.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/lxdialog/textbox.c b/scripts/kconfig/lxdialog/textbox.c
index c704712..154c2dd 100644
--- a/scripts/kconfig/lxdialog/textbox.c
+++ b/scripts/kconfig/lxdialog/textbox.c
@@ -320,7 +320,6 @@ static void print_page(WINDOW * win, int height, int width)
  */
 static void print_line(WINDOW * win, int row, int width)
 {
-	int y, x;
 	char *line;
 
 	line = get_line();
@@ -329,10 +328,10 @@ static void print_line(WINDOW * win, int row, int width)
 	waddch(win, ' ');
 	waddnstr(win, line, MIN(strlen(line), width - 2));
 
-	getyx(win, y, x);
 	/* Clear 'residue' of previous line */
 #if OLD_NCURSES
 	{
+		int x = getcurx(win);
 		int i;
 		for (i = 0; i < width - x; i++)
 			waddch(win, ' ');
-- 
1.7.6

