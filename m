Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863Ab0J2NEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 09:04:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36270 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933836Ab0J2NET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 09:04:19 -0400
From: "Kirill A. Shutsemov" <kirill@shutemov.name>
To: Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH 1/2] kbuild: introduce ARCH_LIST for headers_install_all
Date: Fri, 29 Oct 2010 16:04:00 +0300
Message-Id: <1288357441-23100-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill A. Shutemov <kirill@shutemov.name>

Using ARCH_LIST you can specify subset of architectures you want to get
headers for.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 Documentation/make/headers_install.txt |    5 +++--
 scripts/headers.sh                     |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/make/headers_install.txt b/Documentation/make/headers_install.txt
index f2481ca..1abace6 100644
--- a/Documentation/make/headers_install.txt
+++ b/Documentation/make/headers_install.txt
@@ -39,8 +39,9 @@ INSTALL_HDR_PATH indicates where to install the headers.  It defaults to
 The command "make headers_install_all" exports headers for all architectures
 simultaneously.  (This is mostly of interest to distribution maintainers,
 who create an architecture-independent tarball from the resulting include
-directory.)  Remember to provide the appropriate linux/asm directory via "mv"
-or "ln -s" before building a C library with headers exported this way.
+directory.)  You also can use ARCH_LIST to specify list of architectures.
+Remember to provide the appropriate linux/asm directory via "mv" or "ln -s"
+before building a C library with headers exported this way.
 
 The kernel header export infrastructure is maintained by David Woodhouse
 <dwmw2@infradead.org>.
diff --git a/scripts/headers.sh b/scripts/headers.sh
index 1ddcdd3..62bc527 100755
--- a/scripts/headers.sh
+++ b/scripts/headers.sh
@@ -13,7 +13,7 @@ do_command()
 	fi
 }
 
-archs=$(ls ${srctree}/arch)
+archs=${ARCH_LIST:-$(ls ${srctree}/arch)}
 
 for arch in ${archs}; do
 	case ${arch} in
-- 
1.7.3.2

