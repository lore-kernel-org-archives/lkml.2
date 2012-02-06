Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab2BFXPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 18:15:49 -0500
Received: from mail.vyatta.com ([76.74.103.46]:40729 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab2BFXPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 18:15:47 -0500
Date: Mon, 6 Feb 2012 15:15:43 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH] tags: fix use of parenthesis in regex
Message-ID: <20120206151543.1bb1d869@s6510.linuxnetplumber.net>
In-Reply-To: <4F305CB6.7050603@codeaurora.org>
References: <20120203112701.1c12b12c@s6510.linuxnetplumber.net>
	<4F2C38BD.1060109@codeaurora.org>
	<20120203121847.1b01f4b5@s6510.linuxnetplumber.net>
	<c1f3d71b6001dfc42ded4ee651e9a82c.squirrel@www.codeaurora.org>
	<20120206124058.1cf1a23e@s6510.linuxnetplumber.net>
	<4F305CB6.7050603@codeaurora.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several of the regular expressions passed to etags and ctags where incorrect
and missing the backslash before the closing paren, and matching the wrong
part of the start of the function causing warning:
  etags: Unmatched ( or \( while compiling pattern

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

---
v2 - cover all regex (not just etags)
v3 - fix match at start of function args


--- a/scripts/tags.sh	2012-02-06 12:38:53.243121989 -0800
+++ b/scripts/tags.sh	2012-02-06 15:13:33.400557183 -0800
@@ -129,31 +129,31 @@ exuberant()
 	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL                      \
 	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
 	--extra=+f --c-kinds=+px                                \
-	--regex-asm='/^(ENTRY|_GLOBAL)\(([^)]*)\).*/\2/'        \
-	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/' \
-	--regex-c++='/^TRACE_EVENT\(([^,)]*).*/trace_\1/'		\
-	--regex-c++='/^DEFINE_EVENT\([^,)]*, *([^,)]*).*/trace_\1/'	\
-	--regex-c++='/PAGEFLAG\(([^,)]*).*/Page\1/'			\
-	--regex-c++='/PAGEFLAG\(([^,)]*).*/SetPage\1/'			\
-	--regex-c++='/PAGEFLAG\(([^,)]*).*/ClearPage\1/'		\
-	--regex-c++='/TESTSETFLAG\(([^,)]*).*/TestSetPage\1/'		\
-	--regex-c++='/TESTPAGEFLAG\(([^,)]*).*/Page\1/'			\
-	--regex-c++='/SETPAGEFLAG\(([^,)]*).*/SetPage\1/'		\
-	--regex-c++='/__SETPAGEFLAG\(([^,)]*).*/__SetPage\1/'		\
-	--regex-c++='/TESTCLEARFLAG\(([^,)]*).*/TestClearPage\1/'	\
-	--regex-c++='/__TESTCLEARFLAG\(([^,)]*).*/TestClearPage\1/'	\
-	--regex-c++='/CLEARPAGEFLAG\(([^,)]*).*/ClearPage\1/'		\
-	--regex-c++='/__CLEARPAGEFLAG\(([^,)]*).*/__ClearPage\1/'	\
-	--regex-c++='/__PAGEFLAG\(([^,)]*).*/__SetPage\1/'		\
-	--regex-c++='/__PAGEFLAG\(([^,)]*).*/__ClearPage\1/'		\
-	--regex-c++='/PAGEFLAG_FALSE\(([^,)]*).*/Page\1/'		\
-	--regex-c++='/TESTSCFLAG\(([^,)]*).*/TestSetPage\1/'		\
-	--regex-c++='/TESTSCFLAG\(([^,)]*).*/TestClearPage\1/'		\
-	--regex-c++='/SETPAGEFLAG_NOOP\(([^,)]*).*/SetPage\1/'		\
-	--regex-c++='/CLEARPAGEFLAG_NOOP\(([^,)]*).*/ClearPage\1/'	\
-	--regex-c++='/__CLEARPAGEFLAG_NOOP\(([^,)]*).*/__ClearPage\1/'	\
-	--regex-c++='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
-	--regex-c++='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/'
+	--regex-asm='/^(ENTRY|_GLOBAL)(\([^)]*)\).*/\2/'        \
+	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?(\([^,)]*\).*/sys_\1/' \
+	--regex-c++='/^TRACE_EVENT(\([^,)]*\).*/trace_\1/'		\
+	--regex-c++='/^DEFINE_EVENT\([^,)]*, *([^,)]*\).*/trace_\1/'	\
+	--regex-c++='/PAGEFLAG(\([^,)]*\).*/Page\1/'			\
+	--regex-c++='/PAGEFLAG(\([^,)]*\).*/SetPage\1/'			\
+	--regex-c++='/PAGEFLAG(\([^,)]*\).*/ClearPage\1/'		\
+	--regex-c++='/TESTSETFLAG(\([^,)]*\).*/TestSetPage\1/'		\
+	--regex-c++='/TESTPAGEFLAG(\([^,)]*\).*/Page\1/'		\
+	--regex-c++='/SETPAGEFLAG(\([^,)]*\).*/SetPage\1/'		\
+	--regex-c++='/__SETPAGEFLAG(\([^,)]*\).*/__SetPage\1/'		\
+	--regex-c++='/TESTCLEARFLAG(\([^,)]*\).*/TestClearPage\1/'	\
+	--regex-c++='/__TESTCLEARFLAG(\([^,)]*\).*/TestClearPage\1/'	\
+	--regex-c++='/CLEARPAGEFLAG(\([^,)]*\).*/ClearPage\1/'		\
+	--regex-c++='/__CLEARPAGEFLAG(\([^,)]*\).*/__ClearPage\1/'	\
+	--regex-c++='/__PAGEFLAG(\([^,)]*\).*/__SetPage\1/'		\
+	--regex-c++='/__PAGEFLAG(\([^,)]*\).*/__ClearPage\1/'		\
+	--regex-c++='/PAGEFLAG_FALSE(\([^,)]*\).*/Page\1/'		\
+	--regex-c++='/TESTSCFLAG(\([^,)]*\).*/TestSetPage\1/'		\
+	--regex-c++='/TESTSCFLAG(\([^,)]*\).*/TestClearPage\1/'		\
+	--regex-c++='/SETPAGEFLAG_NOOP(\([^,)]*\).*/SetPage\1/'		\
+	--regex-c++='/CLEARPAGEFLAG_NOOP(\([^,)]*\).*/ClearPage\1/'	\
+	--regex-c++='/__CLEARPAGEFLAG_NOOP(\([^,)]*\).*/__ClearPage\1/'	\
+	--regex-c++='/TESTCLEARFLAG_FALSE(\([^,)]*\).*/TestClearPage\1/' \
+	--regex-c++='/__TESTCLEARFLAG_FALSE(\([^,)]*\).*/__TestClearPage\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--langdef=kconfig --language-force=kconfig              \
@@ -178,27 +178,27 @@ emacs()
 	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
 	--regex='/^TRACE_EVENT(\([^,)]*\).*/trace_\1/'		\
 	--regex='/^DEFINE_EVENT([^,)]*, *\([^,)]*\).*/trace_\1/' \
-	--regex='/PAGEFLAG\(([^,)]*).*/Page\1/'			\
-	--regex='/PAGEFLAG\(([^,)]*).*/SetPage\1/'		\
-	--regex='/PAGEFLAG\(([^,)]*).*/ClearPage\1/'		\
-	--regex='/TESTSETFLAG\(([^,)]*).*/TestSetPage\1/'	\
-	--regex='/TESTPAGEFLAG\(([^,)]*).*/Page\1/'		\
-	--regex='/SETPAGEFLAG\(([^,)]*).*/SetPage\1/'		\
-	--regex='/__SETPAGEFLAG\(([^,)]*).*/__SetPage\1/'	\
-	--regex='/TESTCLEARFLAG\(([^,)]*).*/TestClearPage\1/'	\
-	--regex='/__TESTCLEARFLAG\(([^,)]*).*/TestClearPage\1/'	\
-	--regex='/CLEARPAGEFLAG\(([^,)]*).*/ClearPage\1/'	\
-	--regex='/__CLEARPAGEFLAG\(([^,)]*).*/__ClearPage\1/'	\
-	--regex='/__PAGEFLAG\(([^,)]*).*/__SetPage\1/'		\
-	--regex='/__PAGEFLAG\(([^,)]*).*/__ClearPage\1/'	\
-	--regex='/PAGEFLAG_FALSE\(([^,)]*).*/Page\1/'		\
-	--regex='/TESTSCFLAG\(([^,)]*).*/TestSetPage\1/'	\
-	--regex='/TESTSCFLAG\(([^,)]*).*/TestClearPage\1/'	\
-	--regex='/SETPAGEFLAG_NOOP\(([^,)]*).*/SetPage\1/'	\
-	--regex='/CLEARPAGEFLAG_NOOP\(([^,)]*).*/ClearPage\1/'	\
-	--regex='/__CLEARPAGEFLAG_NOOP\(([^,)]*).*/__ClearPage\1/' \
-	--regex='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
-	--regex='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/'
+	--regex='/PAGEFLAG(\([^,)]*\).*/Page\1/'			\
+	--regex='/PAGEFLAG(\([^,)]*\).*/SetPage\1/'		\
+	--regex='/PAGEFLAG(\([^,)]*\).*/ClearPage\1/'		\
+	--regex='/TESTSETFLAG(\([^,)]*\).*/TestSetPage\1/'	\
+	--regex='/TESTPAGEFLAG(\([^,)]*\).*/Page\1/'		\
+	--regex='/SETPAGEFLAG(\([^,)]*\).*/SetPage\1/'		\
+	--regex='/__SETPAGEFLAG(\([^,)]*\).*/__SetPage\1/'	\
+	--regex='/TESTCLEARFLAG(\([^,)]*\).*/TestClearPage\1/'	\
+	--regex='/__TESTCLEARFLAG(\([^,)]*\).*/TestClearPage\1/'	\
+	--regex='/CLEARPAGEFLAG(\([^,)]*\).*/ClearPage\1/'	\
+	--regex='/__CLEARPAGEFLAG(\([^,)]*\).*/__ClearPage\1/'	\
+	--regex='/__PAGEFLAG(\([^,)]*\).*/__SetPage\1/'		\
+	--regex='/__PAGEFLAG(\([^,)]*\).*/__ClearPage\1/'	\
+	--regex='/PAGEFLAG_FALSE(\([^,)]*\).*/Page\1/'		\
+	--regex='/TESTSCFLAG(\([^,)]*\).*/TestSetPage\1/'	\
+	--regex='/TESTSCFLAG(\([^,)]*\).*/TestClearPage\1/'	\
+	--regex='/SETPAGEFLAG_NOOP(\([^,)]*\).*/SetPage\1/'	\
+	--regex='/CLEARPAGEFLAG_NOOP(\([^,)]*\).*/ClearPage\1/'	\
+	--regex='/__CLEARPAGEFLAG_NOOP(\([^,)]*\).*/__ClearPage\1/' \
+	--regex='/TESTCLEARFLAG_FALSE(\([^,)]*\).*/TestClearPage\1/' \
+	--regex='/__TESTCLEARFLAG_FALSE(\([^,)]*\).*/__TestClearPage\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'
