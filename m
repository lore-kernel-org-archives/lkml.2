Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab2HOStW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:49:22 -0400
Received: from mga06.intel.com ([134.134.136.21]:3079 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751298Ab2HOStV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:49:21 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: zohar@linux.vnet.ibm.com, jmorris@namei.org, rusty@rustcorp.com.au,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@us.ibm.com>
Subject: [RFC v2 6/7] modsig: initialize the _module public key keyring
Date: Wed, 15 Aug 2012 21:43:11 +0300
Message-Id: <ba3d3f54baf08e7252312fa51e590e5d0ca50206.1345055639.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1345055638.git.dmitry.kasatkin@intel.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1345055638.git.dmitry.kasatkin@intel.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mimi Zohar <zohar@linux.vnet.ibm.com>

Create and initialize the _module public key keyring with the builtin
public key.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/integrity/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/integrity/module.c b/security/integrity/module.c
index b0e9ba2..f696a9d 100644
--- a/security/integrity/module.c
+++ b/security/integrity/module.c
@@ -82,7 +82,7 @@ err1:
 
 static int __init module_check_init(void)
 {
-	return 0;
+	return integrity_init_keyring(INTEGRITY_KEYRING_MODULE);
 }
 
 late_initcall(module_check_init);
-- 
1.7.9.5

