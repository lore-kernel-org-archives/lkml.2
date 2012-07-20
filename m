Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab2GTV6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 17:58:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab2GTV6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 17:58:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 09/13] UAPI: Set up uapi/asm/Kbuild.asm
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, tglx@linutronix.de,
        mingo@kernel.org, davej@redhat.com
Date: Fri, 20 Jul 2012 22:58:22 +0100
Message-ID: <20120720215822.14854.44849.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
References: <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set up uapi/asm/Kbuild.asm.  This requires the mandatory headers to be
dynamically detected.  The same goes for include/asm/Kbuild.asm.  The problem
is that the header files will be split or moved one at a time, but each header
file in Kbuild.asm's list applies to all arch headers of that name
simultaneously.

The dynamic detection of mandatory files can be undone later.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/asm-generic/Kbuild.asm      |   46 +--------------------------------
 include/uapi/asm-generic/Kbuild.asm |   49 +++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 45 deletions(-)
 create mode 100644 include/uapi/asm-generic/Kbuild.asm

diff --git a/include/asm-generic/Kbuild.asm b/include/asm-generic/Kbuild.asm
index c5d2e5d..d2ee86b 100644
--- a/include/asm-generic/Kbuild.asm
+++ b/include/asm-generic/Kbuild.asm
@@ -1,45 +1 @@
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h \
-		  $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
-header-y  += kvm.h
-endif
-
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
-		  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h),)
-header-y  += kvm_para.h
-endif
-
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h \
-		  $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
-header-y += a.out.h
-endif
-
-header-y += auxvec.h
-header-y += bitsperlong.h
-header-y += byteorder.h
-header-y += errno.h
-header-y += fcntl.h
-header-y += ioctl.h
-header-y += ioctls.h
-header-y += ipcbuf.h
-header-y += mman.h
-header-y += msgbuf.h
-header-y += param.h
-header-y += poll.h
-header-y += posix_types.h
-header-y += ptrace.h
-header-y += resource.h
-header-y += sembuf.h
-header-y += setup.h
-header-y += shmbuf.h
-header-y += sigcontext.h
-header-y += siginfo.h
-header-y += signal.h
-header-y += socket.h
-header-y += sockios.h
-header-y += stat.h
-header-y += statfs.h
-header-y += swab.h
-header-y += termbits.h
-header-y += termios.h
-header-y += types.h
-header-y += unistd.h
+include include/uapi/asm-generic/Kbuild.asm
diff --git a/include/uapi/asm-generic/Kbuild.asm b/include/uapi/asm-generic/Kbuild.asm
new file mode 100644
index 0000000..9a8464d
--- /dev/null
+++ b/include/uapi/asm-generic/Kbuild.asm
@@ -0,0 +1,49 @@
+#
+# Headers that are optional in usr/include/asm/
+#
+opt-header += kvm.h
+opt-header += kvm_para.h
+opt-header += a.out.h
+
+#
+# Headers that are mandatory in usr/include/asm/
+#
+header-y += auxvec.h
+header-y += bitsperlong.h
+header-y += byteorder.h
+header-y += errno.h
+header-y += fcntl.h
+header-y += ioctl.h
+header-y += ioctls.h
+header-y += ipcbuf.h
+header-y += mman.h
+header-y += msgbuf.h
+header-y += param.h
+header-y += poll.h
+header-y += posix_types.h
+header-y += ptrace.h
+header-y += resource.h
+header-y += sembuf.h
+header-y += setup.h
+header-y += shmbuf.h
+header-y += sigcontext.h
+header-y += siginfo.h
+header-y += signal.h
+header-y += socket.h
+header-y += sockios.h
+header-y += stat.h
+header-y += statfs.h
+header-y += swab.h
+header-y += termbits.h
+header-y += termios.h
+header-y += types.h
+header-y += unistd.h
+
+header-y += $(foreach hdr,$(opt-header), \
+	      $(if \
+		$(wildcard \
+			arch/$(SRCARCH)/include/uapi/asm/$(hdr) \
+			arch/$(SRCARCH)/include/asm/$(hdr) \
+		), \
+		$(hdr) \
+		))

