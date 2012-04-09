Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2DIMhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 08:37:13 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:34819 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab2DIMhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 08:37:09 -0400
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@frijolero.org>,
        Tso Ted <tytso@mit.edu>, Keith Packard <keithp@keithp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ralf Baechle <ralf@linux-mips.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arend Van Spriel <arend@broadcom.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v3] module: Clarify usage of MODULE_LICENSE()
Date: Mon,  9 Apr 2012 05:37:04 -0700
Message-Id: <1333975024-9491-1-git-send-email-mcgrof@frijolero.org>
X-Mailer: git-send-email 1.7.10.rc1.22.gf5241
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@frijolero.org>

While the kernel is GPLv2 individual the MODULE_LICENSE() has allowed for
these tag to be used:

  * Dual BSD/GPL
  * Dual MIT/GPL
  * Dual MPL/GPL

This is done for historical reasons, namely questioning the compatibilty
between the GPL and some old BSD licenses. Some developers and maintainers
tend to use assume the macro is also used to help clarify if the module
source code could be shared with the BSD family, but that is not the case.
The MODULE_LICENSE() declares the module's license at run time and even for
the dual tags the run time license that applies is the GPL.

If sharing share between Linux and permissive licensed Operating Systems such
as the BSDs is desired developers should review the license on the top of
each file being considered to be shared.

Cc: Tso Ted <tytso@mit.edu>
Cc: Keith Packard <keithp@keithp.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arend Van Spriel <arend@broadcom.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---

Space / tab fixup.

 include/linux/module.h |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index fbcafe2..dc7e284 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -112,11 +112,20 @@ extern const struct gtype##_id __mod_##gtype##_table		\
  *
  *	"Proprietary"			[Non free products]
  *
- * There are dual licensed components, but when running with Linux it is the
- * GPL that is relevant so this is a non issue. Similarly LGPL linked with GPL
- * is a GPL combined work.
+ * The idea of dual licensing with what today are considered valid
+ * GPL-Comatible licenses is due to historical questions on GPL-Compatibility
+ * betwen the GPL and some BSD licenses. The purpose of MODULE_LICENSE() is
+ * to clarify the license of the module at run time. Despite the few
+ * GPL-Compatible dual licensed tags, when running with Linux the GPL
+ * license is the one that holds. Even if a module has all of its files
+ * under a BSD license, the MODULE_LICENSE("GPL v2") can still reasonably be
+ * used, and all files of that module could be shared with the BSD family. If
+ * the goal is to share files with the BSDs the top level license header should
+ * be read for each file that is to be shared. Each file's own license is
+ * maintaned through the usage of the Signed-of-by tag.
  *
- * This exists for several reasons
+ * The MODULE_LICENSE() exists for several reasons:
+ * 0.	So EXPORT_SYMBOL_GPL() allows the module to use its symbols
  * 1.	So modinfo can show license info for users wanting to vet their setup 
  *	is free
  * 2.	So the community can ignore bug reports including proprietary modules
-- 
1.7.10.rc1.22.gf5241

