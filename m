Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965694Ab2JWVO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:14:56 -0400
Received: from smtp.outflux.net ([198.145.64.163]:45349 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933640Ab2JWUFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:00 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Rob Landley <rob@landley.net>,
        Jiri Kosina <jkosina@suse.cz>, Masanari Iida <standby24x7@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Richard L Maliszewski <richard.l.maliszewski@intel.com>,
        Gang Wei <gang.wei@intel.com>, Shane Wang <shane.wang@intel.com>,
        Harry Wei <harryxiyou@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=20003/193=5D=20Documentation=3A=20remove=20CONFIG=5FEXPERIMENTAL?=
Date: Tue, 23 Oct 2012 13:01:16 -0700
Message-Id: <1351022666-6960-4-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Rob Landley <rob@landley.net>
CC: Jiri Kosina <jkosina@suse.cz>
CC: Masanari Iida <standby24x7@gmail.com>
CC: Jason Wessel <jason.wessel@windriver.com>
CC: Richard L Maliszewski <richard.l.maliszewski@intel.com>
CC: Gang Wei <gang.wei@intel.com>
CC: Shane Wang <shane.wang@intel.com>
CC: Harry Wei <harryxiyou@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/CodingStyle                 |   10 +---------
 Documentation/DocBook/kernel-hacking.tmpl |    7 -------
 Documentation/DocBook/kgdb.tmpl           |    6 ++----
 Documentation/intel_txt.txt               |    2 +-
 Documentation/zh_CN/CodingStyle           |    7 -------
 5 files changed, 4 insertions(+), 28 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 495e5ba..e00b8f0 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -546,15 +546,7 @@ config AUDIT
 	  logging of avc messages output).  Does not do system-call
 	  auditing without CONFIG_AUDITSYSCALL.
 
-Features that might still be considered unstable should be defined as
-dependent on "EXPERIMENTAL":
-
-config SLUB
-	depends on EXPERIMENTAL && !ARCH_USES_SLAB_PAGE_STRUCT
-	bool "SLUB (Unqueued Allocator)"
-	...
-
-while seriously dangerous features (such as write support for certain
+Seriously dangerous features (such as write support for certain
 filesystems) should advertise this prominently in their prompt string:
 
 config ADFS_FS_RW
diff --git a/Documentation/DocBook/kernel-hacking.tmpl b/Documentation/DocBook/kernel-hacking.tmpl
index eee7142..22e0bd1 100644
--- a/Documentation/DocBook/kernel-hacking.tmpl
+++ b/Documentation/DocBook/kernel-hacking.tmpl
@@ -1185,13 +1185,6 @@ static struct block_device_operations opt_fops = {
     </para>
 
     <para>
-     You may well want to make your CONFIG option only visible if
-     <symbol>CONFIG_EXPERIMENTAL</symbol> is enabled: this serves as a
-     warning to users.  There many other fancy things you can do: see
-     the various <filename>Kconfig</filename> files for ideas.
-    </para>
-
-    <para>
      In your description of the option, make sure you address both the
      expert user and the user who knows nothing about your feature.  Mention
      incompatibilities and issues here.  <emphasis> Definitely
diff --git a/Documentation/DocBook/kgdb.tmpl b/Documentation/DocBook/kgdb.tmpl
index 4ee4ba3..f77358f 100644
--- a/Documentation/DocBook/kgdb.tmpl
+++ b/Documentation/DocBook/kgdb.tmpl
@@ -94,10 +94,8 @@
   <sect1 id="CompileKGDB">
     <title>Kernel config options for kgdb</title>
     <para>
-    To enable <symbol>CONFIG_KGDB</symbol> you should first turn on
-    "Prompt for development and/or incomplete code/drivers"
-    (CONFIG_EXPERIMENTAL) in  "General setup", then under the
-    "Kernel debugging" select "KGDB: kernel debugger".
+    To enable <symbol>CONFIG_KGDB</symbol> you should look under
+    "Kernel debugging" and select "KGDB: kernel debugger".
     </para>
     <para>
     While it is not a hard requirement that you have symbols in your
diff --git a/Documentation/intel_txt.txt b/Documentation/intel_txt.txt
index 849de1a..91d89c5 100644
--- a/Documentation/intel_txt.txt
+++ b/Documentation/intel_txt.txt
@@ -192,7 +192,7 @@ grub.conf needs to be modified as follows:
 
 The kernel option for enabling Intel TXT support is found under the
 Security top-level menu and is called "Enable Intel(R) Trusted
-Execution Technology (TXT)".  It is marked as EXPERIMENTAL and
+Execution Technology (TXT)".  It is considered EXPERIMENTAL and
 depends on the generic x86 support (to allow maximum flexibility in
 kernel build options), since the tboot code will detect whether the
 platform actually supports Intel TXT and thus whether any of the
diff --git a/Documentation/zh_CN/CodingStyle b/Documentation/zh_CN/CodingStyle
index ecd9307..654afd7 100644
--- a/Documentation/zh_CN/CodingStyle
+++ b/Documentation/zh_CN/CodingStyle
@@ -462,13 +462,6 @@ config AUDIT
 	  logging of avc messages output).  Does not do system-call
 	  auditing without CONFIG_AUDITSYSCALL.
 
-仍然被认为不够稳定的功能应该被定义为依赖于“EXPERIMENTAL”：
-
-config SLUB
-	depends on EXPERIMENTAL && !ARCH_USES_SLAB_PAGE_STRUCT
-	bool "SLUB (Unqueued Allocator)"
-	...
-
 而那些危险的功能（比如某些文件系统的写支持）应该在它们的提示字符串里显著的声明这
 一点：
 
-- 
1.7.9.5

