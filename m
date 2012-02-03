Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab2BCT1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 14:27:08 -0500
Received: from mail.vyatta.com ([76.74.103.46]:59693 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191Ab2BCT1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 14:27:04 -0500
Date: Fri, 3 Feb 2012 11:27:01 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Stephen Boyd <sboyd@codeaurora.org>, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tags: fix regex passed to etags
Message-ID: <20120203112701.1c12b12c@s6510.linuxnetplumber.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several of the regular expressions passed to etags where incorrect
and missing the backslash before the closing parenthesis, causing warning:
  etags: Unmatched ( or \( while compiling pattern

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/scripts/tags.sh	2012-02-03 11:21:08.880886637 -0800
+++ b/scripts/tags.sh	2012-02-03 11:21:57.753063962 -0800
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
+	--regex='/PAGEFLAG\(([^,)]*\).*/Page\1/'			\
+	--regex='/PAGEFLAG\(([^,)]*\).*/SetPage\1/'		\
+	--regex='/PAGEFLAG\(([^,)]*\).*/ClearPage\1/'		\
+	--regex='/TESTSETFLAG\(([^,)]*\).*/TestSetPage\1/'	\
+	--regex='/TESTPAGEFLAG\(([^,)]*\).*/Page\1/'		\
+	--regex='/SETPAGEFLAG\(([^,)]*\).*/SetPage\1/'		\
+	--regex='/__SETPAGEFLAG\(([^,)]*\).*/__SetPage\1/'	\
+	--regex='/TESTCLEARFLAG\(([^,)]*\).*/TestClearPage\1/'	\
+	--regex='/__TESTCLEARFLAG\(([^,)]*\).*/TestClearPage\1/'	\
+	--regex='/CLEARPAGEFLAG\(([^,)]*\).*/ClearPage\1/'	\
+	--regex='/__CLEARPAGEFLAG\(([^,)]*\).*/__ClearPage\1/'	\
+	--regex='/__PAGEFLAG\(([^,)]*\).*/__SetPage\1/'		\
+	--regex='/__PAGEFLAG\(([^,)]*\).*/__ClearPage\1/'	\
+	--regex='/PAGEFLAG_FALSE\(([^,)]*\).*/Page\1/'		\
+	--regex='/TESTSCFLAG\(([^,)]*\).*/TestSetPage\1/'	\
+	--regex='/TESTSCFLAG\(([^,)]*\).*/TestClearPage\1/'	\
+	--regex='/SETPAGEFLAG_NOOP\(([^,)]*\).*/SetPage\1/'	\
+	--regex='/CLEARPAGEFLAG_NOOP\(([^,)]*\).*/ClearPage\1/'	\
+	--regex='/__CLEARPAGEFLAG_NOOP\(([^,)]*\).*/__ClearPage\1/' \
+	--regex='/TESTCLEARFLAG_FALSE\(([^,)]*\).*/TestClearPage\1/' \
+	--regex='/__TESTCLEARFLAG_FALSE\(([^,)]*\).*/__TestClearPage\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'
