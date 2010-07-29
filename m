Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab0G2VtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 17:49:01 -0400
Received: from adelie.canonical.com ([91.189.90.139]:44078 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757751Ab0G2Vs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 17:48:58 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 13/13] AppArmor: update Maintainer and Documentation
Date: Thu, 29 Jul 2010 14:48:09 -0700
Message-Id: <1280440089-3203-14-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280440089-3203-1-git-send-email-john.johansen@canonical.com>
References: <1280440089-3203-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 Documentation/apparmor.txt          |   40 +++++++++++++++++++++++++++++++++++
 Documentation/kernel-parameters.txt |    8 +++++++
 MAINTAINERS                         |    8 +++++++
 3 files changed, 56 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/apparmor.txt

diff --git a/Documentation/apparmor.txt b/Documentation/apparmor.txt
new file mode 100644
index 0000000..6240438
--- /dev/null
+++ b/Documentation/apparmor.txt
@@ -0,0 +1,40 @@
+--- What is AppArmor? ---
+
+AppArmor is MAC style security extension for the Linux kernel.  It implements
+a task centered policy, with task "profiles" being created and loaded
+from user space.  Tasks on the system that do not have a profile defined for
+them run in an unconfined state which is equivalent to standard Linux DAC
+permissions.
+
+--- How to enable/disable ---
+
+set CONFIG_SECURITY_APPARMOR=y
+
+If AppArmor should be selected as the default security module then
+   set CONFIG_DEFAULT_SECURITY="apparmor"
+   and CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
+
+Build the kernel
+
+If AppArmor is not the default security module it can be enabled by passing
+security=apparmor on the kernel's command line.
+
+If AppArmor is the default security module it can be disabled by passing
+apparmor=0, security=XXXX (where XXX is valid security module), on the
+kernel's command line
+
+For AppArmor to enforce any restrictions beyond standard Linux DAC permissions
+policy must be loaded into the kernel from user space (see the Documentation
+and tools links).
+
+--- Documentation ---
+
+Documentation can be found on the wiki.
+
+--- Links ---
+
+Mailing List - apparmor@lists.ubuntu.com
+Wiki - http://apparmor.wiki.kernel.org/
+User space tools - https://launchpad.net/apparmor
+Kernel module - git://git.kernel.org/pub/scm/linux/kernel/git/jj/apparmor-dev.git
+
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4ddb58d..a5c74ca 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -93,6 +93,7 @@ parameter is applicable:
 			Documentation/scsi/.
 	SECURITY Different security models are enabled.
 	SELINUX SELinux support is enabled.
+	APPARMOR AppArmor support is enabled.
 	SERIAL	Serial support is enabled.
 	SH	SuperH architecture is enabled.
 	SMP	The kernel is an SMP kernel.
@@ -2312,6 +2313,13 @@ and is between 256 and 4096 characters. It is defined in the file
 			If enabled at boot time, /selinux/disable can be used
 			later to disable prior to initial policy load.
 
+	apparmor=	[APPARMOR] Disable or enable AppArmor at boot time
+			Format: { "0" | "1" }
+			See security/apparmor/Kconfig help text
+			0 -- disable.
+			1 -- enable.
+			Default value is set via kernel config option.
+
 	serialnumber	[BUGS=X86-32]
 
 	shapers=	[NET]
diff --git a/MAINTAINERS b/MAINTAINERS
index db3d0f5..b4e8b7d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5061,6 +5061,14 @@ S:	Supported
 F:	include/linux/selinux*
 F:	security/selinux/
 
+APPARMOR SECURITY MODULE
+M:	John Johansen <john.johansen@canonical.com>
+L:	apparmor@lists.ubuntu.com (subscribers-only, general discussion)
+W:	apparmor.wiki.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jj/apparmor-dev.git
+S:	Supported
+F:	security/apparmor/
+
 SENSABLE PHANTOM
 M:	Jiri Slaby <jirislaby@gmail.com>
 S:	Maintained
-- 
1.7.1

