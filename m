Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab1H2NIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 09:08:38 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49790 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab1H2NIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 09:08:21 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 2/2] evm: remove TCG_TPM dependency
Date: Mon, 29 Aug 2011 09:08:07 -0400
Message-Id: <1314623287-8375-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1314623287-8375-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1314623287-8375-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All tristates selected by EVM(boolean) are forced to be builtin, except
in the TCG_TPM(tristate) dependency case. Arnaud Lacombe summarizes the
Kconfig bug as, "So it would seem direct dependency state influence the
state of reverse dependencies.."  For a detailed explanation, refer to
Arnaud Lacombe's posting http://lkml.org/lkml/2011/8/23/498.

With the "encrypted-keys: remove trusted-keys dependency" patch, EVM
can now be built without a dependency on TCG_TPM.  The trusted-keys
dependency requires trusted-keys to either be builtin or not selected.
This dependency will prevent the boolean/tristate mismatch from
occuring.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>,
             Randy Dunlap <rdunlap@xenotimenet>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/integrity/evm/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
index 884617d..afbb59d 100644
--- a/security/integrity/evm/Kconfig
+++ b/security/integrity/evm/Kconfig
@@ -1,11 +1,10 @@
 config EVM
 	boolean "EVM support"
-	depends on SECURITY && KEYS && TCG_TPM
+	depends on SECURITY && KEYS && (TRUSTED_KEYS=y || TRUSTED_KEYS=n)
 	select CRYPTO_HMAC
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
 	select ENCRYPTED_KEYS
-	select TRUSTED_KEYS
 	default n
 	help
 	  EVM protects a file's security extended attributes against
-- 
1.7.3.4

