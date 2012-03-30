Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965884Ab2C3VwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:52:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965765Ab2C3VTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:19:46 -0400
Message-Id: <20120330194835.804951675@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [ 060/175] ima: fix Kconfig dependencies
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@gmail.com>

commit f4a0391dfa91155bd961673b31eb42d9d45c799d upstream.

Fix the following build warning:
warning: (IMA) selects TCG_TPM which has unmet direct dependencies
(HAS_IOMEM && EXPERIMENTAL)

Suggested-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/Kconfig       |    1 -
 security/integrity/ima/Kconfig |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -5,7 +5,6 @@
 menuconfig TCG_TPM
 	tristate "TPM Hardware Support"
 	depends on HAS_IOMEM
-	depends on EXPERIMENTAL
 	select SECURITYFS
 	---help---
 	  If you have a TPM security chip in your system, which
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -9,7 +9,7 @@ config IMA
 	select CRYPTO_HMAC
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
-	select TCG_TPM if !S390 && !UML
+	select TCG_TPM if HAS_IOMEM && !UML
 	select TCG_TIS if TCG_TPM
 	help
 	  The Trusted Computing Group(TCG) runtime Integrity


