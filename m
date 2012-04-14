Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2DNS1H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 14:27:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59599 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab2DNS1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 14:27:05 -0400
Date: Sat, 14 Apr 2012 11:26:50 -0700
From: tip-bot for Sam Ravnborg <sam@ravnborg.org>
Message-ID: <tip-302616911da8e868d3f1a00dce517ca30b0e065d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        sam@ravnborg.org, tj@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sam@ravnborg.org, tj@kernel.org, tglx@linutronix.de
In-Reply-To: <20120406124735.GA6920@merkur.ravnborg.org>
References: <20120406124735.GA6920@merkur.ravnborg.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Drop obsolete ARCH_BOOTMEM support
Git-Commit-ID: 302616911da8e868d3f1a00dce517ca30b0e065d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 14 Apr 2012 11:26:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  302616911da8e868d3f1a00dce517ca30b0e065d
Gitweb:     http://git.kernel.org/tip/302616911da8e868d3f1a00dce517ca30b0e065d
Author:     Sam Ravnborg <sam@ravnborg.org>
AuthorDate: Fri, 6 Apr 2012 14:47:35 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 14 Apr 2012 14:28:58 +0200

x86: Drop obsolete ARCH_BOOTMEM support

x86 unconditionally uses NO_BOOTMEM so there is no use
of the HAVE_ARCH_BOOTMEM support as mm/bootmem.c is the
only file referencing this symbol.

bootmem_arch_preferred_node() is the function referred
in the mm/bootmem.c code and can thuis be dropped too.

x86 was the sole user of HAVE_ARCH_BOOTMEM - so there is
an opportunity to clean up a little in mm/bootmem.c too
if we do not expect other users to emerge.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/20120406124735.GA6920@merkur.ravnborg.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig                 |    4 ----
 arch/x86/include/asm/mmzone_32.h |    6 ------
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e..a105ee7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1255,10 +1255,6 @@ config NODES_SHIFT
 	  Specify the maximum number of NUMA Nodes available on the target
 	  system.  Increases memory reserved to accommodate various tables.
 
-config HAVE_ARCH_BOOTMEM
-	def_bool y
-	depends on X86_32 && NUMA
-
 config HAVE_ARCH_ALLOC_REMAP
 	def_bool y
 	depends on X86_32 && NUMA
diff --git a/arch/x86/include/asm/mmzone_32.h b/arch/x86/include/asm/mmzone_32.h
index 55728e1..eb05fb3 100644
--- a/arch/x86/include/asm/mmzone_32.h
+++ b/arch/x86/include/asm/mmzone_32.h
@@ -61,10 +61,4 @@ static inline int pfn_valid(int pfn)
 
 #endif /* CONFIG_DISCONTIGMEM */
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
-/* always use node 0 for bootmem on this numa platform */
-#define bootmem_arch_preferred_node(__bdata, size, align, goal, limit)	\
-	(NODE_DATA(0)->bdata)
-#endif /* CONFIG_NEED_MULTIPLE_NODES */
-
 #endif /* _ASM_X86_MMZONE_32_H */
