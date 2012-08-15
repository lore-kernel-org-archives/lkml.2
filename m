Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab2HOSnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:43:35 -0400
Received: from mga10.intel.com ([192.55.52.92]:25253 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754911Ab2HOSn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:43:28 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: zohar@linux.vnet.ibm.com, jmorris@namei.org, rusty@rustcorp.com.au,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@us.ibm.com>
Subject: [RFC v2 2/7] keys: initialize root uid and session keyrings early
Date: Wed, 15 Aug 2012 21:43:07 +0300
Message-Id: <ec8635c36005ba5ea3784276214fb905720ee3ec.1345055639.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1345055638.git.dmitry.kasatkin@intel.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1345055638.git.dmitry.kasatkin@intel.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mimi Zohar <zohar@linux.vnet.ibm.com>

In order to create the integrity keyrings (eg. _evm, _ima, _modules),
root's uid and session keyrings need to be initialized early.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/keys/Makefile       |    1 +
 security/keys/root_keyring.c |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+)
 create mode 100644 security/keys/root_keyring.c

diff --git a/security/keys/Makefile b/security/keys/Makefile
index 504aaa0..c93ce8d 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -18,6 +18,7 @@ obj-y := \
 obj-$(CONFIG_KEYS_COMPAT) += compat.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_SYSCTL) += sysctl.o
+obj-$(CONFIG_INTEGRITY_SIGNATURE) += root_keyring.o
 
 #
 # Key types
diff --git a/security/keys/root_keyring.c b/security/keys/root_keyring.c
new file mode 100644
index 0000000..f6662eb
--- /dev/null
+++ b/security/keys/root_keyring.c
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) 2012 IBM Corporation
+ *
+ * Author:
+ * Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ */
+
+#include "internal.h"
+static int __init init_root_keyring(void)
+{
+	return install_user_keyrings();
+}
+
+late_initcall(init_root_keyring);
-- 
1.7.9.5

