Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2KQAzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 19:55:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37949 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab2KQAzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 19:55:31 -0500
Date: Fri, 16 Nov 2012 16:54:50 -0800
From: tip-bot for Alexander Duyck <alexander.h.duyck@intel.com>
Message-ID: <tip-217f155e9fc68bf2a6c58a7b47e0d1ce68d78818@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, alexander.h.duyck@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, alexander.h.duyck@intel.com, rostedt@goodmis.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20121116215718.8521.24026.stgit@ahduyck-cp1.jf.intel.com>
References: <20121116215718.8521.24026.stgit@ahduyck-cp1.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/ftrace:
  Use __pa_symbol instead of __pa on C visible symbols
Git-Commit-ID: 217f155e9fc68bf2a6c58a7b47e0d1ce68d78818
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 16 Nov 2012 16:55:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  217f155e9fc68bf2a6c58a7b47e0d1ce68d78818
Gitweb:     http://git.kernel.org/tip/217f155e9fc68bf2a6c58a7b47e0d1ce68d78818
Author:     Alexander Duyck <alexander.h.duyck@intel.com>
AuthorDate: Fri, 16 Nov 2012 13:57:32 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 16 Nov 2012 16:42:09 -0800

x86/ftrace: Use __pa_symbol instead of __pa on C visible symbols

Instead of using __pa which is meant to be a general function for converting
virtual addresses to physical addresses we can use __pa_symbol which is the
preferred way of decoding kernel text virtual addresses to physical addresses.

In this case we are not directly converting C visible symbols however if we
know that the instruction pointer is somewhere between _text and _etext we
know that we are going to be translating an address form the kernel text
space.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Link: http://lkml.kernel.org/r/20121116215718.8521.24026.stgit@ahduyck-cp1.jf.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/ftrace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 1d41402..42a392a 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -89,7 +89,7 @@ do_ftrace_mod_code(unsigned long ip, const void *new_code)
 	 * kernel identity mapping to modify code.
 	 */
 	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
-		ip = (unsigned long)__va(__pa(ip));
+		ip = (unsigned long)__va(__pa_symbol(ip));
 
 	return probe_kernel_write((void *)ip, new_code, MCOUNT_INSN_SIZE);
 }
@@ -279,7 +279,7 @@ static int ftrace_write(unsigned long ip, const char *val, int size)
 	 * kernel identity mapping to modify code.
 	 */
 	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
-		ip = (unsigned long)__va(__pa(ip));
+		ip = (unsigned long)__va(__pa_symbol(ip));
 
 	return probe_kernel_write((void *)ip, val, size);
 }
