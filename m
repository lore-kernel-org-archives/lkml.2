Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab0HHRIx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 13:08:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54331 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab0HHRIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 13:08:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hyEvHCvoK7c4wUTgwYcJydKgfet/PUb8HitiNb3z9Gako0lrLKKK/zIeiGDw3M6Z9V
         F+xH6Z9Q/xrTK0HklwuRrxmo7le9f/pHmpO7ZONWfMAAD3y7yoNLHqOVEpQpTmcv7mnT
         lH3bVySuWHimIDL3joZg0bMsNAe3oPSeKYIwc=
From: nir.tzachar@gmail.com
To: sam@ravnborg.org, mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        nir.tzachar@gmail.com
Subject: [PATCH] nconfig: properly map function keys.
Date: Sun,  8 Aug 2010 20:08:39 +0300
Message-Id: <1281287319-32281-1-git-send-email-nir.tzachar@gmail.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <20100808154233.GB4205@merkur.ravnborg.org>
References: <20100808154233.GB4205@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nir Tzachar <nir.tzachar@gmail.com>

Hi Sam. Please try the following patch and see if it helps.


Subject: [PATCH] nconfig: properly map function keys.
When $TERM=xterm,xterm-color,vt220 map function keys properly.

Signed-off-by: Nir Tzachar <nir.tzachar@gmail.com>
---
 scripts/kconfig/nconf.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index c6feb41..a641a66 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -1537,13 +1537,13 @@ int main(int ac, char **av)
 
 	/* Initialize curses */
 	initscr();
-	/* set color theme */
-	set_colors();
-
 	cbreak();
 	noecho();
 	keypad(stdscr, TRUE);
 	curs_set(0);
+	/* set color theme */
+	set_colors();
+
 
 	if (COLS < 75 || LINES < 20) {
 		endwin();
@@ -1552,6 +1552,23 @@ int main(int ac, char **av)
 		return 1;
 	}
 
+	const char *term = getenv("TERM");
+	if (strcmp(term, "xterm") == 0 ||
+	    strcmp(term, "xterm-color") == 0 ||
+	    strcmp(term, "vt220") == 0) {
+		define_key("\033[H", KEY_HOME);
+		define_key("\033[F", KEY_END);
+		define_key("\033OP", KEY_F(1));
+		define_key("\033OQ", KEY_F(2));
+		define_key("\033OR", KEY_F(3));
+		define_key("\033OS", KEY_F(4));
+		define_key("\033[16~", KEY_F(5));
+		define_key("\033[17~", KEY_F(6));
+		define_key("\033[18", KEY_F(7));
+		define_key("\033[19~", KEY_F(8));
+		define_key("\033[20~", KEY_F(9));
+	}
+
 	notimeout(stdscr, FALSE);
 	ESCDELAY = 1;
 
-- 
1.6.4.4

