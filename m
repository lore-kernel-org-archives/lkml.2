Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858Ab2JKQSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 12:18:44 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33007 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab2JKQSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 12:18:14 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 3/4] s390: Automatically generate trivial UAPI headers
Date: Thu, 11 Oct 2012 17:18:04 +0100
Message-Id: <1349972285-22830-4-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1349972285-22830-1-git-send-email-catalin.marinas@arm.com>
References: <1349972285-22830-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 11 Oct 2012 16:18:12.0014 (UTC) FILETIME=[02771CE0:01CDA7CC]
X-MC-Unique: 112101117181219401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q9BGIwgY011863

This patch removes several trivial UAPI headers that were simply including
the asm-generic files as they can be automatically generated.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/include/uapi/asm/Kbuild     | 19 ++++++++++---------
 arch/s390/include/uapi/asm/errno.h    | 11 -----------
 arch/s390/include/uapi/asm/fcntl.h    |  1 -
 arch/s390/include/uapi/asm/ioctl.h    |  1 -
 arch/s390/include/uapi/asm/mman.h     |  6 ------
 arch/s390/include/uapi/asm/param.h    |  6 ------
 arch/s390/include/uapi/asm/poll.h     |  1 -
 arch/s390/include/uapi/asm/resource.h | 13 -------------
 arch/s390/include/uapi/asm/sockios.h  |  6 ------
 arch/s390/include/uapi/asm/termbits.h |  6 ------
 10 files changed, 10 insertions(+), 60 deletions(-)
 delete mode 100644 arch/s390/include/uapi/asm/errno.h
 delete mode 100644 arch/s390/include/uapi/asm/fcntl.h
 delete mode 100644 arch/s390/include/uapi/asm/ioctl.h
 delete mode 100644 arch/s390/include/uapi/asm/mman.h
 delete mode 100644 arch/s390/include/uapi/asm/param.h
 delete mode 100644 arch/s390/include/uapi/asm/poll.h
 delete mode 100644 arch/s390/include/uapi/asm/resource.h
 delete mode 100644 arch/s390/include/uapi/asm/sockios.h
 delete mode 100644 arch/s390/include/uapi/asm/termbits.h

diff --git a/arch/s390/include/uapi/asm/Kbuild b/arch/s390/include/uapi/asm/Kbuild
index 7bf68ff..e364de2 100644
--- a/arch/s390/include/uapi/asm/Kbuild
+++ b/arch/s390/include/uapi/asm/Kbuild
@@ -9,23 +9,16 @@ header-y += chsc.h
 header-y += cmb.h
 header-y += dasd.h
 header-y += debug.h
-header-y += errno.h
-header-y += fcntl.h
-header-y += ioctl.h
 header-y += ioctls.h
 header-y += ipcbuf.h
 header-y += kvm.h
 header-y += kvm_para.h
 header-y += kvm_virtio.h
-header-y += mman.h
 header-y += monwriter.h
 header-y += msgbuf.h
-header-y += param.h
-header-y += poll.h
 header-y += posix_types.h
 header-y += ptrace.h
 header-y += qeth.h
-header-y += resource.h
 header-y += schid.h
 header-y += sembuf.h
 header-y += setup.h
@@ -34,15 +27,23 @@ header-y += sigcontext.h
 header-y += siginfo.h
 header-y += signal.h
 header-y += socket.h
-header-y += sockios.h
 header-y += stat.h
 header-y += statfs.h
 header-y += swab.h
 header-y += tape390.h
-header-y += termbits.h
 header-y += termios.h
 header-y += types.h
 header-y += ucontext.h
 header-y += unistd.h
 header-y += vtoc.h
 header-y += zcrypt.h
+
+generic-y += errno.h
+generic-y += fcntl.h
+generic-y += ioctl.h
+generic-y += mman.h
+generic-y += param.h
+generic-y += poll.h
+generic-y += resource.h
+generic-y += sockios.h
+generic-y += termbits.h
diff --git a/arch/s390/include/uapi/asm/errno.h b/arch/s390/include/uapi/asm/errno.h
deleted file mode 100644
index 395e97d..0000000
--- a/arch/s390/include/uapi/asm/errno.h
+++ /dev/null
@@ -1,11 +0,0 @@
-/*
- *  S390 version
- *
- */
-
-#ifndef _S390_ERRNO_H
-#define _S390_ERRNO_H
-
-#include <asm-generic/errno.h>
-
-#endif
diff --git a/arch/s390/include/uapi/asm/fcntl.h b/arch/s390/include/uapi/asm/fcntl.h
deleted file mode 100644
index 46ab12d..0000000
--- a/arch/s390/include/uapi/asm/fcntl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/fcntl.h>
diff --git a/arch/s390/include/uapi/asm/ioctl.h b/arch/s390/include/uapi/asm/ioctl.h
deleted file mode 100644
index b279fe0..0000000
--- a/arch/s390/include/uapi/asm/ioctl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ioctl.h>
diff --git a/arch/s390/include/uapi/asm/mman.h b/arch/s390/include/uapi/asm/mman.h
deleted file mode 100644
index de23da1..0000000
--- a/arch/s390/include/uapi/asm/mman.h
+++ /dev/null
@@ -1,6 +0,0 @@
-/*
- *  S390 version
- *
- *  Derived from "include/asm-i386/mman.h"
- */
-#include <asm-generic/mman.h>
diff --git a/arch/s390/include/uapi/asm/param.h b/arch/s390/include/uapi/asm/param.h
deleted file mode 100644
index c616821..0000000
--- a/arch/s390/include/uapi/asm/param.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASMS390_PARAM_H
-#define _ASMS390_PARAM_H
-
-#include <asm-generic/param.h>
-
-#endif /* _ASMS390_PARAM_H */
diff --git a/arch/s390/include/uapi/asm/poll.h b/arch/s390/include/uapi/asm/poll.h
deleted file mode 100644
index c98509d..0000000
--- a/arch/s390/include/uapi/asm/poll.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/poll.h>
diff --git a/arch/s390/include/uapi/asm/resource.h b/arch/s390/include/uapi/asm/resource.h
deleted file mode 100644
index ec23d1c..0000000
--- a/arch/s390/include/uapi/asm/resource.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/*
- *  S390 version
- *
- *  Derived from "include/asm-i386/resources.h"
- */
-
-#ifndef _S390_RESOURCE_H
-#define _S390_RESOURCE_H
-
-#include <asm-generic/resource.h>
-
-#endif
-
diff --git a/arch/s390/include/uapi/asm/sockios.h b/arch/s390/include/uapi/asm/sockios.h
deleted file mode 100644
index 6f60eee..0000000
--- a/arch/s390/include/uapi/asm/sockios.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_S390_SOCKIOS_H
-#define _ASM_S390_SOCKIOS_H
-
-#include <asm-generic/sockios.h>
-
-#endif
diff --git a/arch/s390/include/uapi/asm/termbits.h b/arch/s390/include/uapi/asm/termbits.h
deleted file mode 100644
index 71bf6ac..0000000
--- a/arch/s390/include/uapi/asm/termbits.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_S390_TERMBITS_H
-#define _ASM_S390_TERMBITS_H
-
-#include <asm-generic/termbits.h>
-
-#endif

