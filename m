Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab1HKEXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 00:23:24 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46441 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab1HKEXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 00:23:17 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 2/2] evm: fix evm_inode_init_security return code
Date: Thu, 11 Aug 2011 00:22:52 -0400
Message-Id: <1313036572-27122-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1313036572-27122-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1313036572-27122-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

evm_inode_init_security() should return 0, when EVM is not enabled.
(Returning an error is a remnant of evm_inode_post_init_security.)

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 include/linux/evm.h               |    2 +-
 security/integrity/evm/evm_main.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/evm.h b/include/linux/evm.h
index 62deb65..ea603c9 100644
--- a/include/linux/evm.h
+++ b/include/linux/evm.h
@@ -85,7 +85,7 @@ static inline int evm_inode_init_security(struct inode *inode,
 					  const struct xattr *xattr_array,
 					  struct xattr *evm)
 {
-	return -EOPNOTSUPP;
+	return 0;
 }
 
 #endif /* CONFIG_EVM_H */
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 8fc5b5d..f0127e5 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -324,7 +324,7 @@ int evm_inode_init_security(struct inode *inode,
 	int rc;
 
 	if (!evm_initialized || !evm_protected_xattr(lsm_xattr->name))
-		return -EOPNOTSUPP;
+		return 0;
 
 	xattr_data = kzalloc(sizeof(*xattr_data), GFP_NOFS);
 	if (!xattr_data)
-- 
1.7.3.4

