Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab1KCRKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:10:03 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7251 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933120Ab1KCRJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:09:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="134262363"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [PATCH] scripts/tags.sh: Add Page flag function magic
Date: Thu,  3 Nov 2011 10:09:57 -0700
Message-Id: <1320340197-9063-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.8.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It takes a while to find the macro-magically defined Page*()
functions defined in include/linux/page-flags.h if you're new to
the kernel. Add some magic to the tags script to transform these
macros into the actual functions they are, so that tag jumping in
the mm code is a bit easier.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Tested-by welcome because I didn't actually test the emacs part.

 scripts/tags.sh |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 38f6617..028dc5c 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -132,7 +132,28 @@ exuberant()
 	--regex-asm='/^(ENTRY|_GLOBAL)\(([^)]*)\).*/\2/'        \
 	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/' \
 	--regex-c++='/^TRACE_EVENT\(([^,)]*).*/trace_\1/'		\
-	--regex-c++='/^DEFINE_EVENT\([^,)]*, *([^,)]*).*/trace_\1/'
+	--regex-c++='/^DEFINE_EVENT\([^,)]*, *([^,)]*).*/trace_\1/'	\
+	--regex-c++='/PAGEFLAG\(([^,)]*).*/Page\1/'			\
+	--regex-c++='/PAGEFLAG\(([^,)]*).*/SetPage\1/'			\
+	--regex-c++='/PAGEFLAG\(([^,)]*).*/ClearPage\1/'		\
+	--regex-c++='/TESTSETFLAG\(([^,)]*).*/TestSetPage\1/'		\
+	--regex-c++='/TESTPAGEFLAG\(([^,)]*).*/Page\1/'			\
+	--regex-c++='/SETPAGEFLAG\(([^,)]*).*/SetPage\1/'		\
+	--regex-c++='/__SETPAGEFLAG\(([^,)]*).*/__SetPage\1/'		\
+	--regex-c++='/TESTCLEARFLAG\(([^,)]*).*/TestClearPage\1/'	\
+	--regex-c++='/__TESTCLEARFLAG\(([^,)]*).*/TestClearPage\1/'	\
+	--regex-c++='/CLEARPAGEFLAG\(([^,)]*).*/ClearPage\1/'		\
+	--regex-c++='/__CLEARPAGEFLAG\(([^,)]*).*/__ClearPage\1/'	\
+	--regex-c++='/__PAGEFLAG\(([^,)]*).*/__SetPage\1/'		\
+	--regex-c++='/__PAGEFLAG\(([^,)]*).*/__ClearPage\1/'		\
+	--regex-c++='/PAGEFLAG_FALSE\(([^,)]*).*/Page\1/'		\
+	--regex-c++='/TESTSCFLAG\(([^,)]*).*/TestSetPage\1/'		\
+	--regex-c++='/TESTSCFLAG\(([^,)]*).*/TestClearPage\1/'		\
+	--regex-c++='/SETPAGEFLAG_NOOP\(([^,)]*).*/SetPage\1/'		\
+	--regex-c++='/CLEARPAGEFLAG_NOOP\(([^,)]*).*/ClearPage\1/'	\
+	--regex-c++='/__CLEARPAGEFLAG_NOOP\(([^,)]*).*/__ClearPage\1/'	\
+	--regex-c++='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
+	--regex-c++='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--langdef=kconfig --language-force=kconfig              \
@@ -154,7 +175,28 @@ emacs()
 	--regex='/^(ENTRY|_GLOBAL)(\([^)]*\)).*/\2/'            \
 	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
 	--regex='/^TRACE_EVENT(\([^,)]*\).*/trace_\1/'		\
-	--regex='/^DEFINE_EVENT([^,)]*, *\([^,)]*\).*/trace_\1/'
+	--regex='/^DEFINE_EVENT([^,)]*, *\([^,)]*\).*/trace_\1/' \
+	--regex='/PAGEFLAG\(([^,)]*).*/Page\1/'			\
+	--regex='/PAGEFLAG\(([^,)]*).*/SetPage\1/'		\
+	--regex='/PAGEFLAG\(([^,)]*).*/ClearPage\1/'		\
+	--regex='/TESTSETFLAG\(([^,)]*).*/TestSetPage\1/'	\
+	--regex='/TESTPAGEFLAG\(([^,)]*).*/Page\1/'		\
+	--regex='/SETPAGEFLAG\(([^,)]*).*/SetPage\1/'		\
+	--regex='/__SETPAGEFLAG\(([^,)]*).*/__SetPage\1/'	\
+	--regex='/TESTCLEARFLAG\(([^,)]*).*/TestClearPage\1/'	\
+	--regex='/__TESTCLEARFLAG\(([^,)]*).*/TestClearPage\1/'	\
+	--regex='/CLEARPAGEFLAG\(([^,)]*).*/ClearPage\1/'	\
+	--regex='/__CLEARPAGEFLAG\(([^,)]*).*/__ClearPage\1/'	\
+	--regex='/__PAGEFLAG\(([^,)]*).*/__SetPage\1/'		\
+	--regex='/__PAGEFLAG\(([^,)]*).*/__ClearPage\1/'	\
+	--regex='/PAGEFLAG_FALSE\(([^,)]*).*/Page\1/'		\
+	--regex='/TESTSCFLAG\(([^,)]*).*/TestSetPage\1/'	\
+	--regex='/TESTSCFLAG\(([^,)]*).*/TestClearPage\1/'	\
+	--regex='/SETPAGEFLAG_NOOP\(([^,)]*).*/SetPage\1/'	\
+	--regex='/CLEARPAGEFLAG_NOOP\(([^,)]*).*/ClearPage\1/'	\
+	--regex='/__CLEARPAGEFLAG_NOOP\(([^,)]*).*/__ClearPage\1/' \
+	--regex='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
+	--regex='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

