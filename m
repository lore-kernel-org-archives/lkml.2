Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab2DAQES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:04:18 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:32815 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab2DAQEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:04:15 -0400
Subject: [RFC PATCH -tip 11/16] tracing/docs: add explanation about
 disassembler interface
To: linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 02 Apr 2012 01:04:11 +0900
Message-ID: <20120401160411.4502.77554.stgit@shimauta>
In-Reply-To: <20120401160229.4502.2541.stgit@shimauta>
References: <20120401160229.4502.2541.stgit@shimauta>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an entry for explaining x86 disassembler interface
to kprobetrace.txt, because that is very useful for
someone who wants to put a probe on somewhere without
using perf-probe.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
---
 Documentation/trace/kprobetrace.txt |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index d0d0bb9..1dc7b44 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -92,6 +92,20 @@ Event Profiling
 the third is the number of probe miss-hits.
 
 
+Function disassembling
+----------------------
+ To find a probe target, you have two options.
+1) Use perf-probe in perftools. This allows you to find a probe target
+ by using source-code level information.
+2) Use a kernel function disassembling interface on debugfs.
+The first one is easy to use, very helpful for noraml user, but also
+requires kernel debuginfo package (or built binary with CONFIG_DEBUGINFO).
+The second one is easy to use, but requires a knowladge of assembly
+language (and also, this is currently available on x86 with
+CONFIG_X86_DISASSEMBLER=y and CONFIG_DEBUG_X86_DISASSEMBLY=y).
+The debugfs interface is /sys/kernel/debug/x86/disassembly. At first,
+you should write a function name to the file, and then, read it.
+
 Usage examples
 --------------
 To add a probe as a new event, write a new definition to kprobe_events

