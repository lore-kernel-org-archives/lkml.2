Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847Ab2JKQSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 12:18:40 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33021 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387Ab2JKQSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 12:18:14 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4/4] sparc: Automatically generate trivial UAPI headers
Date: Thu, 11 Oct 2012 17:18:05 +0100
Message-Id: <1349972285-22830-5-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1349972285-22830-1-git-send-email-catalin.marinas@arm.com>
References: <1349972285-22830-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 11 Oct 2012 16:18:12.0374 (UTC) FILETIME=[02AE0B60:01CDA7CC]
X-MC-Unique: 112101117181300901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q9BGIi5v011859

This patch removes several trivial UAPI headers that were simply including
the asm-generic files as they can be automatically generated.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: "David S. Miller" <davem@davemloft.net>
---
 arch/sparc/include/uapi/asm/Kbuild     | 5 +++--
 arch/sparc/include/uapi/asm/kvm_para.h | 1 -
 arch/sparc/include/uapi/asm/statfs.h   | 6 ------
 3 files changed, 3 insertions(+), 9 deletions(-)
 delete mode 100644 arch/sparc/include/uapi/asm/kvm_para.h
 delete mode 100644 arch/sparc/include/uapi/asm/statfs.h

diff --git a/arch/sparc/include/uapi/asm/Kbuild b/arch/sparc/include/uapi/asm/Kbuild
index ce175af..c7a460f 100644
--- a/arch/sparc/include/uapi/asm/Kbuild
+++ b/arch/sparc/include/uapi/asm/Kbuild
@@ -17,7 +17,6 @@ header-y += ioctl.h
 header-y += ioctls.h
 header-y += ipcbuf.h
 header-y += jsflash.h
-header-y += kvm_para.h
 header-y += mman.h
 header-y += msgbuf.h
 header-y += openpromio.h
@@ -39,7 +38,6 @@ header-y += signal.h
 header-y += socket.h
 header-y += sockios.h
 header-y += stat.h
-header-y += statfs.h
 header-y += swab.h
 header-y += termbits.h
 header-y += termios.h
@@ -49,3 +47,6 @@ header-y += uctx.h
 header-y += unistd.h
 header-y += utrap.h
 header-y += watchdog.h
+
+generic-y += kvm_para.h
+generic-y += statfs.h
diff --git a/arch/sparc/include/uapi/asm/kvm_para.h b/arch/sparc/include/uapi/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/sparc/include/uapi/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
diff --git a/arch/sparc/include/uapi/asm/statfs.h b/arch/sparc/include/uapi/asm/statfs.h
deleted file mode 100644
index 55e607a..0000000
--- a/arch/sparc/include/uapi/asm/statfs.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef ___ASM_SPARC_STATFS_H
-#define ___ASM_SPARC_STATFS_H
-
-#include <asm-generic/statfs.h>
-
-#endif

