Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030915Ab2CNXDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:03:47 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62306 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964865Ab2CNXCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:02:46 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 10/11] dynamic_debug: update Documentation/*, Kconfig.debug
Date: Wed, 14 Mar 2012 17:02:05 -0600
Message-Id: <1331766126-11674-11-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.8.1
In-Reply-To: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com>
References: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

In dynamic-debug-howto.txt:

- add section: Debug Messages at Module Initialization Time
- update flags indicators in example outputs, from '-' to '=_'.
- make flags descriptions tabular
- add item on '_' flag-char
- add dyndbg, boot-args examples
- rewrap some paragraphs with long lines

In Kconfig.debug, note that compiling with -DDEBUG enables all
pr_debug()s in that code.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 Documentation/dynamic-debug-howto.txt |  155 ++++++++++++++++++++-------------
 lib/Kconfig.debug                     |   17 +++--
 2 files changed, 107 insertions(+), 65 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index 74e6c77..235d963 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -2,17 +2,17 @@
 Introduction
 ============
 
-This document describes how to use the dynamic debug (ddebug) feature.
+This document describes how to use the dynamic debug (dyndbg) feature.
 
-Dynamic debug is designed to allow you to dynamically enable/disable kernel
-code to obtain additional kernel information. Currently, if
-CONFIG_DYNAMIC_DEBUG is set, then all pr_debug()/dev_dbg() calls can be
-dynamically enabled per-callsite.
+Dynamic debug is designed to allow you to dynamically enable/disable
+kernel code to obtain additional kernel information.  Currently, if
+CONFIG_DYNAMIC_DEBUG is set, then all pr_debug()/dev_dbg() calls can
+be dynamically enabled per-callsite.
 
 Dynamic debug has even more useful features:
 
- * Simple query language allows turning on and off debugging statements by
-   matching any combination of 0 or 1 of:
+ * Simple query language allows turning on and off debugging
+   statements by matching any combination of 0 or 1 of:
 
    - source filename
    - function name
@@ -20,17 +20,19 @@ Dynamic debug has even more useful features:
    - module name
    - format string
 
- * Provides a debugfs control file: <debugfs>/dynamic_debug/control which can be
-   read to display the complete list of known debug statements, to help guide you
+ * Provides a debugfs control file: <debugfs>/dynamic_debug/control
+   which can be read to display the complete list of known debug
+   statements, to help guide you
 
 Controlling dynamic debug Behaviour
 ===================================
 
 The behaviour of pr_debug()/dev_dbg()s are controlled via writing to a
-control file in the 'debugfs' filesystem. Thus, you must first mount the debugfs
-filesystem, in order to make use of this feature. Subsequently, we refer to the
-control file as: <debugfs>/dynamic_debug/control. For example, if you want to
-enable printing from source file 'svcsock.c', line 1603 you simply do:
+control file in the 'debugfs' filesystem. Thus, you must first mount
+the debugfs filesystem, in order to make use of this feature.
+Subsequently, we refer to the control file as:
+<debugfs>/dynamic_debug/control. For example, if you want to enable
+printing from source file 'svcsock.c', line 1603 you simply do:
 
 nullarbor:~ # echo 'file svcsock.c line 1603 +p' >
 				<debugfs>/dynamic_debug/control
@@ -44,15 +46,15 @@ nullarbor:~ # echo 'file svcsock.c wtf 1 +p' >
 Viewing Dynamic Debug Behaviour
 ===========================
 
-You can view the currently configured behaviour of all the debug statements
-via:
+You can view the currently configured behaviour of all the debug
+statements via:
 
 nullarbor:~ # cat <debugfs>/dynamic_debug/control
 # filename:lineno [module]function flags format
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:323 [svcxprt_rdma]svc_rdma_cleanup - "SVCRDMA Module Removed, deregister RPC RDMA transport\012"
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:341 [svcxprt_rdma]svc_rdma_init - "\011max_inline       : %d\012"
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:340 [svcxprt_rdma]svc_rdma_init - "\011sq_depth         : %d\012"
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:338 [svcxprt_rdma]svc_rdma_init - "\011max_requests     : %d\012"
+/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:323 [svcxprt_rdma]svc_rdma_cleanup =_ "SVCRDMA Module Removed, deregister RPC RDMA transport\012"
+/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:341 [svcxprt_rdma]svc_rdma_init =_ "\011max_inline       : %d\012"
+/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:340 [svcxprt_rdma]svc_rdma_init =_ "\011sq_depth         : %d\012"
+/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:338 [svcxprt_rdma]svc_rdma_init =_ "\011max_requests     : %d\012"
 ...
 
 
@@ -65,12 +67,12 @@ nullarbor:~ # grep -i rdma <debugfs>/dynamic_debug/control  | wc -l
 nullarbor:~ # grep -i tcp <debugfs>/dynamic_debug/control | wc -l
 42
 
-Note in particular that the third column shows the enabled behaviour
-flags for each debug statement callsite (see below for definitions of the
-flags).  The default value, no extra behaviour enabled, is "-".  So
-you can view all the debug statement callsites with any non-default flags:
+The third column shows the currently enabled flags for each debug
+statement callsite (see below for definitions of the flags).  The
+default value, with no flags enabled, is "=_".  So you can view all
+the debug statement callsites with any non-default flags:
 
-nullarbor:~ # awk '$3 != "-"' <debugfs>/dynamic_debug/control
+nullarbor:~ # awk '$3 != "=_"' <debugfs>/dynamic_debug/control
 # filename:lineno [module]function flags format
 /usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svcsock.c:1603 [sunrpc]svc_send p "svc_process: st_sendto returned %d\012"
 
@@ -103,15 +105,14 @@ specifications, followed by a flags change specification.
 
 command ::= match-spec* flags-spec
 
-The match-spec's are used to choose a subset of the known dprintk()
+The match-spec's are used to choose a subset of the known pr_debug()
 callsites to which to apply the flags-spec.  Think of them as a query
 with implicit ANDs between each pair.  Note that an empty list of
-match-specs is possible, but is not very useful because it will not
-match any debug statement callsites.
+match-specs will select all debug statement callsites.
 
-A match specification comprises a keyword, which controls the attribute
-of the callsite to be compared, and a value to compare against.  Possible
-keywords are:
+A match specification comprises a keyword, which controls the
+attribute of the callsite to be compared, and a value to compare
+against.  Possible keywords are:
 
 match-spec ::= 'func' string |
 	       'file' string |
@@ -164,15 +165,15 @@ format
     characters (") or single quote characters (').
     Examples:
 
-    format svcrdma:	    // many of the NFS/RDMA server dprintks
-    format readahead	    // some dprintks in the readahead cache
+    format svcrdma:	    // many of the NFS/RDMA server pr_debugs
+    format readahead	    // some pr_debugs in the readahead cache
     format nfsd:\040SETATTR // one way to match a format with whitespace
     format "nfsd: SETATTR"  // a neater way to match a format with whitespace
     format 'nfsd: SETATTR'  // yet another way to match a format with whitespace
 
 line
     The given line number or range of line numbers is compared
-    against the line number of each dprintk() callsite.  A single
+    against the line number of each pr_debug() callsite.  A single
     line number matches the callsite line number exactly.  A
     range of line numbers matches any callsite between the first
     and last line number inclusive.  An empty first number means
@@ -188,52 +189,76 @@ The flags specification comprises a change operation followed
 by one or more flag characters.  The change operation is one
 of the characters:
 
--
-    remove the given flags
-
-+
-    add the given flags
-
-=
-    set the flags to the given flags
+  -    remove the given flags
+  +    add the given flags
+  =    set the flags to the given flags
 
 The flags are:
 
-f
-    Include the function name in the printed message
-l
-    Include line number in the printed message
-m
-    Include module name in the printed message
-p
-    Causes a printk() message to be emitted to dmesg
-t
-    Include thread ID in messages not generated from interrupt context
+  p    enables the pr_debug() callsite.
+  f    Include the function name in the printed message
+  l    Include line number in the printed message
+  m    Include module name in the printed message
+  t    Include thread ID in messages not generated from interrupt context
+  _    No flags are set. (Or'd with others on input)
 
-Note the regexp ^[-+=][flmpt]+$ matches a flags specification.
-Note also that there is no convenient syntax to remove all
-the flags at once, you need to use "-flmpt".
+For display, the flags are preceded by '='
+(mnemonic: what the flags are currently equal to).
 
+Note the regexp ^[-+=][flmpt_]+$ matches a flags specification.
+To clear all flags at once, use "=_" or "-flmpt".
 
-Debug messages during boot process
+
+Debug messages during Boot Process
 ==================================
 
-To be able to activate debug messages during the boot process,
-even before userspace and debugfs exists, use the boot parameter:
-ddebug_query="QUERY"
+To activate debug messages for core code and built-in modules during
+the boot process, even before userspace and debugfs exists, use the
+boot parameter: dyndbg="QUERY".
 
 QUERY follows the syntax described above, but must not exceed 1023
 characters. The enablement of debug messages is done as an arch_initcall.
 Thus you can enable debug messages in all code processed after this
 arch_initcall via this boot parameter.
+
 On an x86 system for example ACPI enablement is a subsys_initcall and
-ddebug_query="file ec.c +p"
+   dyndbg="file ec.c +p"
 will show early Embedded Controller transactions during ACPI setup if
 your machine (typically a laptop) has an Embedded Controller.
 PCI (or other devices) initialization also is a hot candidate for using
 this boot parameter for debugging purposes.
 
 
+Debug Messages at Module Initialization Time
+============================================
+
+For dynamically loaded modules, dyndbg given via modprobe enables
+its callsites before module initialization:
+
+1. # the parameter can be given permanently via /etc/modprobe.d/*.conf
+   options $module dyndbg=+pmflt
+   options $module dyndbg # defaults to +p
+
+2. # as an ordinary module parameter via modprobe
+   modprobe $module dyndbg=+pmfl
+
+Dyndbg flag settings are applied in the order given above, with last
+having final say.  This lets modprobe args (2) either supplement
+(dyndbg=+tfl) or override (dyndbg="=p_") flags in (1).
+
+The boot parameter form: $modname.dyndbg="value" must exclude "module
+$modname", as the $modname is taken from the param-name, and only 1
+spec of each type is allowed.
+
+The dyndbg option is not implemented as an ordinary module parameter
+and thus will not show up in /sys/module/$module_name/parameters/dyndbg
+
+For CONFIG_DYNAMIC_DEBUG kernels, any settings given at boot-time (or
+by -DDEBUG flag during compilation) can be disabled later via the
+sysfs interface if the debug messages are no longer needed:
+
+   echo "module module_name -p" > <debugfs>/dynamic_debug/control
+
 Examples
 ========
 
@@ -260,3 +285,15 @@ nullarbor:~ # echo -n 'func svc_process -p' >
 // enable messages for NFS calls READ, READLINK, READDIR and READDIR+.
 nullarbor:~ # echo -n 'format "nfsd: READ" +p' >
 				<debugfs>/dynamic_debug/control
+
+// enable all messages
+nullarbor:~ # echo -n '+p' > <debugfs>/dynamic_debug/control
+
+// add module, function to all enabled messages
+nullarbor:~ # echo -n '+mf' > <debugfs>/dynamic_debug/control
+
+// boot-args example, with newlines and comments for readability
+Kernel command line: ...
+  dyndbg="func i2c_del_adapter +p; func tboot_probe +p"
+  dynamic_debug.verbose=1	# see whats going on
+  nouveau.dyndbg		# implicit =+p
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index f7af95d..ed27521 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1204,8 +1204,13 @@ config DYNAMIC_DEBUG
 	  otherwise be available at runtime. These messages can then be
 	  enabled/disabled based on various levels of scope - per source file,
 	  function, module, format string, and line number. This mechanism
-	  implicitly enables all pr_debug() and dev_dbg() calls. The impact of
-	  this compile option is a larger kernel text size of about 2%.
+	  implicitly compiles in all pr_debug() and dev_dbg() calls, which
+	  enlarges the kernel text size by about 2%.
+
+	  If a source file is compiled with DEBUG flag set, any
+	  pr_debug() calls in it are enabled by default, but can be
+	  disabled at runtime as below.  Note that DEBUG flag is
+	  turned on by many CONFIG_*DEBUG* options.
 
 	  Usage:
 
@@ -1222,16 +1227,16 @@ config DYNAMIC_DEBUG
 	  lineno : line number of the debug statement
 	  module : module that contains the debug statement
 	  function : function that contains the debug statement
-          flags : 'p' means the line is turned 'on' for printing
+          flags : '=p' means the line is turned 'on' for printing
           format : the format used for the debug statement
 
 	  From a live system:
 
 		nullarbor:~ # cat <debugfs>/dynamic_debug/control
 		# filename:lineno [module]function flags format
-		fs/aio.c:222 [aio]__put_ioctx - "__put_ioctx:\040freeing\040%p\012"
-		fs/aio.c:248 [aio]ioctx_alloc - "ENOMEM:\040nr_events\040too\040high\012"
-		fs/aio.c:1770 [aio]sys_io_cancel - "calling\040cancel\012"
+		fs/aio.c:222 [aio]__put_ioctx =_ "__put_ioctx:\040freeing\040%p\012"
+		fs/aio.c:248 [aio]ioctx_alloc =_ "ENOMEM:\040nr_events\040too\040high\012"
+		fs/aio.c:1770 [aio]sys_io_cancel =_ "calling\040cancel\012"
 
 	  Example usage:
 
-- 
1.7.7.6

