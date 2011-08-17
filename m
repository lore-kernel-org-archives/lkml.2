Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab1HQWwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 18:52:07 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:36594 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab1HQWwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 18:52:02 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@xenotime.net>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH] evm: add Kconfig TCG_TPM dependency
Date: Wed, 17 Aug 2011 18:51:36 -0400
Message-Id: <1313621496-8308-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although the EVM encrypted-key should be encrypted/decrypted using a
trusted-key, a user-defined key could be used instead. When using a user-
defined key, a TCG_TPM dependency should not be required.  Unfortunately,
the encrypted-key code needs to be refactored a bit in order to remove
this dependency.

This patch adds the TCG_TPM dependency.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>,
	     Randy Dunlap <rdunlap@xenotimenet>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/integrity/evm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
index 444877d..884617d 100644
--- a/security/integrity/evm/Kconfig
+++ b/security/integrity/evm/Kconfig
@@ -1,6 +1,6 @@
 config EVM
 	boolean "EVM support"
-	depends on SECURITY && KEYS
+	depends on SECURITY && KEYS && TCG_TPM
 	select CRYPTO_HMAC
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
-- 
1.7.3.4

