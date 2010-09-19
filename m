Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab0ISCZu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 22:25:50 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:37374 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab0ISCZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 22:25:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:cc:subject
	:from:date:message-id:mime-version:content-type; q=dns; s=sasl; b=
	Ns5Gr+98SNjoBpYDlFh2ZO+YG80MpD4nLOBGoiHiwZohXpZ7po5FbaU/pTv+VCEN
	yQYIODFobUPrM1uL9Vn/58hXrzJuyaIJY2V387/eUKSkAxUb8c2U9+BZ98KmjXTj
	pFv+rLpIGbHkXgdN8urtvswW9yJ6Lm+oBVWtqBUqXr4=
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Michal Marek <mmarek@suse.cz>,
        Li Zefan <lizf@cn.fujitsu.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] 
From: Junio C Hamano <gitster@pobox.com>
Date: Sat, 18 Sep 2010 19:25:32 -0700
Message-ID: <7vhbhmxyeb.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 32A95C60-C395-11DF-9B33-030CEE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 60f33b8 (kconfig: get rid of stray a.o, support ncursesw, 2006-01-15),
support to link menuconfig with ncursesw library was added.  To compute
the linker command option -l, we check "libncursesw.{so,a,dylib}" to allow
ncursesw to be used as a replacement ncurses.  However, when checking what
header file to include, we do not check /usr/include/ncursesw directory.

Add /usr/include/ncursesw to the list of directories that are checked.
With this patch, on my Debian Lenny box with libncursesw5-dev package but
not libncurses5-dev package, I can say "make menuconfig".

Signed-off-by: Junio C Hamano <gitster@pobox.com>
---
 * There is no /usr/include/ncurses/ directory but /usr/include/ncursesw
   exists, and has curses.h in it.

 scripts/kconfig/lxdialog/check-lxdialog.sh |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
index fcef0f5..82cc3a8 100644
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -23,6 +23,8 @@ ccflags()
 		echo '-I/usr/include/ncurses -DCURSES_LOC="<ncurses.h>"'
 	elif [ -f /usr/include/ncurses/curses.h ]; then
 		echo '-I/usr/include/ncurses -DCURSES_LOC="<ncurses/curses.h>"'
+	elif [ -f /usr/include/ncursesw/curses.h ]; then
+		echo '-I/usr/include/ncursesw -DCURSES_LOC="<ncursesw/curses.h>"'
 	elif [ -f /usr/include/ncurses.h ]; then
 		echo '-DCURSES_LOC="<ncurses.h>"'
 	else
