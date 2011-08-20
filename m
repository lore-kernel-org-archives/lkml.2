Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab1HTF15 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 01:27:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56670 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1HTF14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 01:27:56 -0400
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: Arnaud Lacombe <lacombar@gmail.com>, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH] kconfig: fix set but not used variables
Date: Sat, 20 Aug 2011 02:28:53 -0300
Message-Id: <1313818133-25087-1-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <CACqU3MWoa5eNpgODqAKDSBZOL61OFWVqaKe_cH=bOMbxjRM0rA@mail.gmail.com>
References: <CACqU3MWoa5eNpgODqAKDSBZOL61OFWVqaKe_cH=bOMbxjRM0rA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some variables were being set but never used, which was triggering
warnings in GCC >= 4.6.

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

