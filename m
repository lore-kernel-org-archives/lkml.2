Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab2JVTUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:20:48 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:44678 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab2JVTUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:20:24 -0400
Message-Id: <20121022192020.282883454@openvz.org>
User-Agent: quilt/0.48-1
Date: Mon, 22 Oct 2012 23:14:54 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc 2/2] [RFC] procfs: Documantation -- Add VmFlags field description
References: <20121022191452.785366817@openvz.org>
Content-Disposition: inline; filename=mm-vma-flags-doc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/filesystems/proc.txt |   38 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

Index: linux-2.6.git/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.git.orig/Documentation/filesystems/proc.txt
+++ linux-2.6.git/Documentation/filesystems/proc.txt
@@ -142,7 +142,7 @@ Table 1-1: Process specific entries in /
  pagemap	Page table
  stack		Report full stack trace, enable via CONFIG_STACKTRACE
  smaps		a extension based on maps, showing the memory consumption of
-		each mapping
+		each mapping and flags associated with it
 ..............................................................................
 
 For example, to get the status information of a process, all you have to do is
@@ -415,6 +415,7 @@ Swap:                  0 kB
 KernelPageSize:        4 kB
 MMUPageSize:           4 kB
 Locked:              374 kB
+VmFlags: RD:1 WR:0 EX:1 SH:0 MR:1 MW:1 ME:1 MS:0 GD:0 PF:0 DW:1 LO:0 IO:0 SR:0 RR:0 DC:0 DE:0 AC:0 NR:0 HT:0 NL:0 AR:0 DD:0 MM:0 HG:0 NH:0 MG:0
 
 The first of these lines shows the same information as is displayed for the
 mapping in /proc/PID/maps.  The remaining lines show the size of the mapping
@@ -430,6 +431,41 @@ and a page is modified, the file page is
 "Swap" shows how much would-be-anonymous memory is also used, but out on
 swap.
 
+"VmFlags" field deserves a separate description. This member represents the kernel
+flags associated with the particular virtual memory area in two letter encoded
+manner. The codes are the following:
+    RD  - readable
+    WR  - writeable
+    EX  - executable
+    SH  - shared
+    MR  - may read
+    MW  - may write
+    ME  - may execute
+    MS  - may share
+    GD  - stack segment growns down
+    PF  - pure PFN range
+    DW  - disabled write to the mapped file
+    LO  - pages are locked in memory
+    IO  - memory mapped I/O area
+    SR  - sequential read advise provided
+    RR  - random read advise provided
+    DC  - do not copy area on fork
+    DE  - do not expand area on remapping
+    AC  - area is accountable
+    NR  - swap space is not reserved for the area
+    HT  - area uses huge tlb pages
+    NL  - non-linear mapping
+    AR  - architecture specific flag
+    DD  - do not include area into core dump
+    MM  - mixed map area
+    HG  - huge page advise flag
+    NH  - no-huge page advise flag
+    MG  - mergable advise flag
+
+Note that there is no guarantee that every flag and associated mnemonic will
+be present in all further kernel releases. Things get changed, the flags may
+be vanished or the reverse -- new added.
+
 This file is only present if the CONFIG_MMU kernel configuration option is
 enabled.
 

