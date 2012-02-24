Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab2BXT2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:28:08 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:49060 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754905Ab2BXT2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:28:06 -0500
Message-ID: <4F47E4C5.7060706@xenotime.net>
Date: Fri, 24 Feb 2012 11:28:05 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Mimi Zohar <zohar@us.ibm.com>,
        James Morris <jmorris@namei.org>
Subject: [PATCH] security: fix ima kconfig warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix IMA kconfig warning on non-X86 architectures:

warning: (IMA) selects TCG_TIS which has unmet direct dependencies
(TCG_TPM && X86)

But why do TCG_TIS and TCG_NSC depend on X86??

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: James Morris <jmorris@namei.org>
---
No IMA/TPM builds have been tested with this change...

 security/integrity/ima/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-33-rc4.orig/security/integrity/ima/Kconfig
+++ lnx-33-rc4/security/integrity/ima/Kconfig
@@ -10,7 +10,7 @@ config IMA
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
 	select TCG_TPM if !S390 && !UML
-	select TCG_TIS if TCG_TPM
+	select TCG_TIS if TCG_TPM && X86
 	help
 	  The Trusted Computing Group(TCG) runtime Integrity
 	  Measurement Architecture(IMA) maintains a list of hash
