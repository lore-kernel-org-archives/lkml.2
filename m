Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab2JRR6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:58:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932363Ab2JRR6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:58:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] UAPI: S390 shouldn't've been changed to use
 uapi/asm-generic/kvm_para.h
To: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, fengguang.wu@intel.com
Date: Thu, 18 Oct 2012 18:58:13 +0100
Message-ID: <20121018175813.7489.19089.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that S390 shouldn't use uapi/asm-generic/kvm_para.h since it
defines the functions in its non-UAPI kvm_para.h file.

#including <asm-generic/kvm_para.h> will first pick up
include/asm-generic/kvm_para.h, which defines conflicting functions.

Instead, partially revert commit 0420c87e648a3b623ad925038a0bcff2ef5a4bc9,
ungenericising this file and just inserting a comment to prevent the patch
program from deleting it.

Reported-by: Yuanhan Liu <yuanhan.liu@intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Yuanhan Liu <yuanhan.liu@intel.com>
cc: fengguang.wu@intel.com
---

 arch/s390/include/uapi/asm/Kbuild     |    2 --
 arch/s390/include/uapi/asm/kvm_para.h |   11 +++++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)
 create mode 100644 arch/s390/include/uapi/asm/kvm_para.h

diff --git a/arch/s390/include/uapi/asm/Kbuild b/arch/s390/include/uapi/asm/Kbuild
index 59b67ed..7bf68ff 100644
--- a/arch/s390/include/uapi/asm/Kbuild
+++ b/arch/s390/include/uapi/asm/Kbuild
@@ -1,8 +1,6 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
-generic-y += kvm_para.h
-
 header-y += auxvec.h
 header-y += bitsperlong.h
 header-y += byteorder.h
diff --git a/arch/s390/include/uapi/asm/kvm_para.h b/arch/s390/include/uapi/asm/kvm_para.h
new file mode 100644
index 0000000..ff1f4e7
--- /dev/null
+++ b/arch/s390/include/uapi/asm/kvm_para.h
@@ -0,0 +1,11 @@
+/*
+ * User API definitions for paravirtual devices on s390
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ *
+ *    Author(s): Christian Borntraeger <borntraeger@de.ibm.com>
+ */

