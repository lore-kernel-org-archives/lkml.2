Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760466Ab2BJWkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:40:55 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50022 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab2BJWkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:40:53 -0500
MIME-Version: 1.0
Message-Id: <20120210222946.371567467@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Arnd Bergmann <arnd@arndb.de>, Arthur Taylor <art@ified.ca>,
        Jiri Slaby <jslaby@suse.cz>, Jiri Olsa <jolsa@redhat.com>
Subject: [patch 15/86] drivers/tty/vt/vt_ioctl.c: fix KDFONTOP 32bit compatibility layer
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit cbcb8346054073d000ecac324763372d6abd44ac upstream.

KDFONTOP(GET) currently fails with EIO when being run in a 32bit userland
with a 64bit kernel if the font width is not 8.

This is because of the setting of the KD_FONT_FLAG_OLD flag, which makes
con_font_get return EIO in such case.

This flag should *not* be set for KDFONTOP, since it's actually the whole
point of this flag (see comment in con_font_set for instance).

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Arthur Taylor <art@ified.ca>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/vt_ioctl.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -1463,7 +1463,6 @@ compat_kdfontop_ioctl(struct compat_cons
 	if (!perm && op->op != KD_FONT_OP_GET)
 		return -EPERM;
 	op->data = compat_ptr(((struct compat_console_font_op *)op)->data);
-	op->flags |= KD_FONT_FLAG_OLD;
 	i = con_font_op(vc, op);
 	if (i)
 		return i;


