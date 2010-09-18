Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab0IRBDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 21:03:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab0IRBDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 21:03:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] default CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
X-Fcc: ~/Mail/linus
X-Windows: form follows malfunction.
Message-Id: <20100918010300.0194C403E8@magilla.sf.frob.com>
Date: Fri, 17 Sep 2010 18:02:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The userland ELF tools have been coping with partial-segments core
files for a few years now.  Multiple distro builds are now setting
this option.  It behooves everyone who ever deals with core files to
have more info dumped in there, especially as more and more people's
compilers are producing build IDs.  Make it the default.

Anyone using older tools confused by these core files can configure
this option off, or just change /proc/PID/coredump_filter after boot.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 fs/Kconfig.binfmt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index bb4cc5b..79e2ca7 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -42,7 +42,7 @@ config BINFMT_ELF_FDPIC
 
 config CORE_DUMP_DEFAULT_ELF_HEADERS
 	bool "Write ELF core dumps with partial segments"
-	default n
+	default y
 	depends on BINFMT_ELF && ELF_CORE
 	help
 	  ELF core dump files describe each memory mapping of the crashed
@@ -60,7 +60,7 @@ config CORE_DUMP_DEFAULT_ELF_HEADERS
 	  inherited.  See Documentation/filesystems/proc.txt for details.
 
 	  This config option changes the default setting of coredump_filter
-	  seen at boot time.  If unsure, say N.
+	  seen at boot time.  If unsure, say Y.
 
 config BINFMT_FLAT
 	bool "Kernel support for flat binaries"
