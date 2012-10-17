Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab2JQOQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:16:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262Ab2JQOQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:16:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/10] UAPI: Put a comment into uapi/asm-generic/kvm_para.h
 and use it from arches
To: torvalds@osdl.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org
Date: Wed, 17 Oct 2012 15:16:13 +0100
Message-ID: <20121017141613.29084.14629.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121017141521.29084.36722.stgit@warthog.procyon.org.uk>
References: <20121017141521.29084.36722.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make uapi/asm-generic/kvm_para.h non-empty by addition of a comment to stop
the patch program from deleting it when it creates it.

Then delete empty arch-specific uapi/asm/kvm_para.h files and tell the Kbuild
files to use the generic instead.

Should this perhaps instead be a #warning or #error that the facility is
unsupported on this arch?

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Arnd Bergmann <arnd@arndb.de>
cc: Avi Kivity <avi@redhat.com>
cc: Marcelo Tosatti <mtosatti@redhat.com>
cc: kvm@vger.kernel.org
---

 arch/ia64/include/uapi/asm/Kbuild     |    2 ++
 arch/ia64/include/uapi/asm/kvm_para.h |    0 
 arch/s390/include/uapi/asm/Kbuild     |    2 ++
 arch/s390/include/uapi/asm/kvm_para.h |    0 
 include/uapi/asm-generic/kvm_para.h   |    4 ++++
 5 files changed, 8 insertions(+)
 delete mode 100644 arch/ia64/include/uapi/asm/kvm_para.h
 delete mode 100644 arch/s390/include/uapi/asm/kvm_para.h

diff --git a/arch/ia64/include/uapi/asm/Kbuild b/arch/ia64/include/uapi/asm/Kbuild
index 30cafac..1b3f5eb 100644
--- a/arch/ia64/include/uapi/asm/Kbuild
+++ b/arch/ia64/include/uapi/asm/Kbuild
@@ -1,6 +1,8 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
+generic-y += kvm_para.h
+
 header-y += auxvec.h
 header-y += bitsperlong.h
 header-y += break.h
diff --git a/arch/ia64/include/uapi/asm/kvm_para.h b/arch/ia64/include/uapi/asm/kvm_para.h
deleted file mode 100644
index e69de29..0000000
diff --git a/arch/s390/include/uapi/asm/Kbuild b/arch/s390/include/uapi/asm/Kbuild
index 7bf68ff..59b67ed 100644
--- a/arch/s390/include/uapi/asm/Kbuild
+++ b/arch/s390/include/uapi/asm/Kbuild
@@ -1,6 +1,8 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
+generic-y += kvm_para.h
+
 header-y += auxvec.h
 header-y += bitsperlong.h
 header-y += byteorder.h
diff --git a/arch/s390/include/uapi/asm/kvm_para.h b/arch/s390/include/uapi/asm/kvm_para.h
deleted file mode 100644
index e69de29..0000000
diff --git a/include/uapi/asm-generic/kvm_para.h b/include/uapi/asm-generic/kvm_para.h
index e69de29..486f0af 100644
--- a/include/uapi/asm-generic/kvm_para.h
+++ b/include/uapi/asm-generic/kvm_para.h
@@ -0,0 +1,4 @@
+/*
+ * There isn't anything here, but the file must not be empty or patch
+ * will delete it.
+ */

