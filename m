Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab2GUKNr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 06:13:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab2GUKNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 06:13:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120720215738.14854.55273.stgit@warthog.procyon.org.uk>
References: <20120720215738.14854.55273.stgit@warthog.procyon.org.uk> <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
To: linux-arch@vger.kernel.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, arnd@arndb.de,
        tglx@linutronix.de, mingo@kernel.org, davej@redhat.com,
        viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 05/13] UAPI: Partition the header include path sets and add uapi/ header directories
Date: Sat, 21 Jul 2012 11:13:27 +0100
Message-ID: <28231.1342865607@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


And thanks to Al for pointing out that the UM arch needed fixing.  The
attached patch should do the trick.

David
---
diff --git a/arch/um/Makefile b/arch/um/Makefile
index 0970910..133f7de 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -66,7 +66,9 @@ USER_CFLAGS = $(patsubst $(KERNEL_DEFINES),,$(patsubst -D__KERNEL__,,\
 include $(srctree)/$(ARCH_DIR)/Makefile-os-$(OS)
 
 KBUILD_CPPFLAGS += -I$(srctree)/$(HOST_DIR)/include \
-		   -I$(HOST_DIR)/include/generated
+		   -I$(srctree)/$(HOST_DIR)/include/uapi \
+		   -I$(HOST_DIR)/include/generated \
+		   -I$(HOST_DIR)/include/generated/uapi
 
 # -Derrno=kernel_errno - This turns all kernel references to errno into
 # kernel_errno to separate them from the libc errno.  This allows -fno-common
