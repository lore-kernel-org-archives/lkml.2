Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab2JHQTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 12:19:25 -0400
Received: from shrek-modem1.podlesie.net ([83.18.25.171]:40904 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab2JHQTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 12:19:23 -0400
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Mazur <krzysiek@podlesie.net>
Subject: [PATCH] menuconfig: fix extended colors ncurses support
Date: Mon,  8 Oct 2012 18:18:22 +0200
Message-Id: <1349713102-3301-1-git-send-email-krzysiek@podlesie.net>
X-Mailer: git-send-email 1.7.12.2.2.g1c3c581
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ncurses library allows for extended colors. The support for extended
colors support depends on wide-character support. ncurses headers
enable extended colors (NCURSES_EXT_COLORS) only when wide-character
support is enabled (NCURSES_WIDECHAR).

The "make menuconfig" uses wide-character ncursesw library, which can be
compiled with wide-character support, but does not define NCURSES_WIDECHAR
and it's using headers without wide-character (and extended colors) support.

This fixes problems with colors on systems with enabled extended colors
(like PLD Linux). Without this patch "make menuconfig" is hard to use.

Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
---
 scripts/kconfig/lxdialog/check-lxdialog.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
index e3b12c0..5a70e8b 100644
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -21,6 +21,7 @@ ccflags()
 {
 	if [ -f /usr/include/ncursesw/curses.h ]; then
 		echo '-I/usr/include/ncursesw -DCURSES_LOC="<ncursesw/curses.h>"'
+		echo ' -DNCURSES_WIDECHAR=1'
 	elif [ -f /usr/include/ncurses/ncurses.h ]; then
 		echo '-I/usr/include/ncurses -DCURSES_LOC="<ncurses.h>"'
 	elif [ -f /usr/include/ncurses/curses.h ]; then
-- 
1.7.12.2.2.g1c3c581

