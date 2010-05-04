Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284Ab0EDWQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:16:52 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40581 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760226Ab0EDWQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:16:50 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Jean-Christophe Dubois <jcd@tribudubois.net>,
       Serge Hallyn <serue@us.ibm.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       James Morris <jmorris@namei.org>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH] ima: remove ACPI dependency
Date: Tue,  4 May 2010 18:16:30 -0400
Message-Id: <1273011390-6090-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI dependency moved to the TPM, where it belongs.  Although
IMA per-se does not require access to the bios measurement log,
verifying the IMA boot aggregate does, which requires ACPI.

This patch prereq's 'TPM: ACPI/PNP dependency removal'
http://lkml.org/lkml/2010/5/4/378.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Reported-by: Jean-Christophe Dubois <jcd@tribudubois.net>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Tested-by: Serge Hallyn <serue@us.ibm.com>
---
 security/integrity/ima/Kconfig |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 3d7846d..b6ecfd4 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -2,15 +2,14 @@
 #
 config IMA
 	bool "Integrity Measurement Architecture(IMA)"
-	depends on ACPI
 	depends on SECURITY
 	select SECURITYFS
 	select CRYPTO
 	select CRYPTO_HMAC
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
-	select TCG_TPM
-	select TCG_TIS
+	select TCG_TPM if !S390
+	select TCG_TIS if TCG_TPM
 	help
 	  The Trusted Computing Group(TCG) runtime Integrity
 	  Measurement Architecture(IMA) maintains a list of hash
-- 
1.6.6.1

