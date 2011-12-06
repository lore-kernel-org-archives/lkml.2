Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab1LFBGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:06:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:18104 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932716Ab1LFBGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:06:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,302,1320652800"; 
   d="scan'208";a="92645293"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 1/3] um: Run host archheaders, allow use of host generated headers
Date: Mon,  5 Dec 2011 17:05:47 -0800
Message-Id: <1323133549-13590-2-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1323133549-13590-1-git-send-email-hpa@linux.intel.com>
References: <1323133549-13590-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Run the "archheaders" target for the host architecture, for
architectures (like x86, now) that want to generate some of the
necessary header files.

Add $(HOST_DIR)/include/generated to the include path so we then pick
them up.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/um/Makefile |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 7730af6..00210e9 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -64,7 +64,8 @@ USER_CFLAGS = $(patsubst $(KERNEL_DEFINES),,$(patsubst -D__KERNEL__,,\
 #This will adjust *FLAGS accordingly to the platform.
 include $(srctree)/$(ARCH_DIR)/Makefile-os-$(OS)
 
-KBUILD_CPPFLAGS += -I$(srctree)/$(HOST_DIR)/include
+KBUILD_CPPFLAGS += -I$(srctree)/$(HOST_DIR)/include \
+		   -I$(HOST_DIR)/include/generated
 
 # -Derrno=kernel_errno - This turns all kernel references to errno into
 # kernel_errno to separate them from the libc errno.  This allows -fno-common
@@ -96,6 +97,10 @@ endef
 
 KBUILD_KCONFIG := $(HOST_DIR)/um/Kconfig
 
+archheaders:
+	$(Q)$(MAKE) -C '$(KBUILD_SRC)' KBUILD_SRC= \
+		ARCH=$(SUBARCH) O='$(objtree)' archheaders
+
 archprepare: include/generated/user_constants.h
 
 LINK-$(CONFIG_LD_SCRIPT_STATIC) += -static
-- 
1.7.6.4

