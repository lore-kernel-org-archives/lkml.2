Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab1ITMSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 08:18:47 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:46482 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab1ITMSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 08:18:44 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 20 Sep 2011 17:35:07 +0530
Message-Id: <20110920120507.25326.68120.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH v5 3.1.0-rc4-tip 25/26]   perf: Documentation for perf uprobes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Modify perf-probe.txt to include uprobe documentation

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 tools/perf/Documentation/perf-probe.txt |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 800775e..3c98a54 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -78,6 +78,8 @@ OPTIONS
 -F::
 --funcs::
 	Show available functions in given module or kernel.
+	With -x/--exec, can also list functions in a user space executable
+	/ shared library.
 
 --filter=FILTER::
 	(Only for --vars and --funcs) Set filter. FILTER is a combination of glob
@@ -98,6 +100,11 @@ OPTIONS
 --max-probes::
 	Set the maximum number of probe points for an event. Default is 128.
 
+-x::
+--exec=PATH::
+	Specify path to the executable or shared library file for user
+	space tracing. Can also be used with --funcs option.
+
 PROBE SYNTAX
 ------------
 Probe points are defined by following syntax.
@@ -182,6 +189,13 @@ Delete all probes on schedule().
 
  ./perf probe --del='schedule*'
 
+Add probes at zfree() function on /bin/zsh
+
+ ./perf probe -x /bin/zsh zfree
+
+Add probes at malloc() function on libc
+
+ ./perf probe -x /lib/libc.so.6 malloc
 
 SEE ALSO
 --------
