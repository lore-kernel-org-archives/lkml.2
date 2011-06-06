Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab1FFR2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:28:04 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:62258 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755357Ab1FFR2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:28:01 -0400
X-AuditID: 1209190d-b7bdeae0000004f8-d4-4ded0ddcc77c
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, Ingo Molnar <mingo@elte.hu>
Cc: pageexec@freemail.hu, Mikael Pettersson <mikpe@it.uu.se>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 3/3] x86-64: Clarify CONFIG_COMPAT_VSYSCALLS text
Date: Mon,  6 Jun 2011 13:27:25 -0400
Message-Id: <4ad5860f9c9c79ecd303f345cf9c06f8859c44d4.1307380481.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1307380481.git.luto@mit.edu>
References: <cover.1307380481.git.luto@mit.edu>
In-Reply-To: <cover.1307380481.git.luto@mit.edu>
References: <cover.1307380481.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42IR4hRV1r3L+9bXYHcLs0XflaPsFtM2iltc
	3jWHzeJJ83VGiy2XmlktHq95zmzxqO8tu8WPDY9ZHTg8brX9YfZY0vGD3WPnrLvsHv9fHmHz
	2LSqk83jxIzfLB6fN8l5nGj5whrAEcVlk5Kak1mWWqRvl8CV8frrWtaCLpmKQ5tcGxj3i3Ux
	cnJICJhIHNi3gRnCFpO4cG89WxcjF4eQwD5GiaX3f0M56xklzj46wQZSJSRwiEni04dwEJtN
	QEWiY+kDJhBbREBf4vfZRYwgDcwCzxklXnyAaBAWcJS4d6QJzGYRUJXYfu43WAOvQJDEx4lb
	gGwOoNUKEudX5YOEOQUMJKbensUIsUtf4vy+yay4xCcwCixgZFjFKJuSW6Wbm5iZU5yarFuc
	nJiXl1qka6SXm1mil5pSuokRHNKSvDsY3x1UOsQowMGoxMNr+v2NrxBrYllxZe4hRkkOJiVR
	3lZgRAjxJeWnVGYkFmfEF5XmpBYfYpTgYFYS4Y1/A1TOm5JYWZValA+TkuZgURLnnSmp7isk
	kJ5YkpqdmlqQWgSTleHgUJLg7QUZKliUmp5akZaZU4KQZuLgBBnOAzR8HgdQDW9xQWJucWY6
	RP4Uoy7H1hNvDzIKseTl56VKifPmgwwSACnKKM2DmwNLRa8YxYHeEob4gQeYxuAmvQJawgS0
	5LjTK5AlJYkIKakGxpB2+Y/RTW9vGTUsvvMxaFuOpGaa07oHcoaGD2Z190rH7rx7serP4mMR
	XFPnPzbgMS7Q2S7vxFJa6atbalvyLpbty6G1K5ZZZnCFyEiLbwnhXaXXvPvzbcaDZ7q4ZjPP
	5V90SiqTLZzN6M2uFT/zXy9nerjK6sX3i++sGiMdJh3TjTu0LS/EUomlOCPRUIu5qDgRAHAo
	WkogAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enough people are confused about whether CONFIG_COMPAT_VSYSCALLS=n
breaks binary compatibility that we should make it harder to be
confused.  So make it more clear what's going on.

The new text is a slight lie in that CONFIG_COMPAT_VSYSCALLS could
make it slightly harder to exploit *kernel* bugs once the kernel
address layout is randomized, but I mentioning that in the help text
might just cause more confusion

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 Documentation/feature-removal-schedule.txt |   11 +++++++----
 arch/x86/Kconfig                           |   27 +++++++++++++++------------
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 4282ab2..ef5d1e9 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -602,11 +602,14 @@ Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 ----------------------------
 
 What:	CONFIG_COMPAT_VSYSCALLS (x86_64)
-When:	When glibc 2.14 or newer is ubitquitous.  Perhaps mid-2012.
+When:	When glibc 2.14 or newer is ubiquitous.  Perhaps 2013.
 Why:	Having user-executable syscall invoking code at a fixed addresses makes
-	it easier for attackers to exploit security holes.
-	Turning off CONFIG_COMPAT_VSYSCALLS mostly removes the risk but will
-	make the time() function slower on glibc versions 2.13 and below.
+	it easier for attackers to exploit security holes.  Turning off
+	CONFIG_COMPAT_VSYSCALLS reduces the risk without breaking binary
+	compatibility but will make the time() function slower on glibc
+	versions 2.13 and below.
+
+	We may flip the default setting to N before 2013.
 Who:	Andy Lutomirski <luto@mit.edu>
 
 ----------------------------
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 30041d8..17d99bc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1648,24 +1648,27 @@ config COMPAT_VDSO
 
 config COMPAT_VSYSCALLS
 	def_bool y
-	prompt "Fixed address legacy vsyscalls"
+	prompt "Fast legacy sys_time() vsyscall"
 	depends on X86_64
 	---help---
-	  Legacy user code expects to be able to issue three syscalls
-	  by calling a fixed addresses.  If you say N, then the kernel
-	  traps and emulates these calls.  If you say Y, then there is
-	  actual executable code at a fixed address to implement time()
-	  efficiently.
+	  Glibc 2.13 and older, statically linked binaries, and a few
+	  other things use a legacy ABI to implement time().
 
-	  On a system with recent enough glibc (probably 2.14 or
-	  newer) and no static binaries, you can say N without a
-	  performance penalty to improve security: having no fixed
-	  address userspace-executable syscall invoking code makes
-	  it harder for both remote and local attackers to exploit
-	  security holes.
+	  If you say N here, the kernel will emulate that interface in
+	  order to make certain types of userspace bugs more difficult
+	  to exploit.  This will cause some legacy software to run
+	  slightly more slowly.
+
+	  If you say Y here, then the kernel will provide native code to
+	  allow legacy programs to run without any performance impact.
+	  This could make it easier to exploit certain types of
+	  userspace bugs.
 
 	  If unsure, say Y.
 
+	  NOTE: disabling this option will not break any ABI; the kernel
+	        will be fully compatible with all binaries either way.
+
 config CMDLINE_BOOL
 	bool "Built-in kernel command line"
 	---help---
-- 
1.7.5.2

