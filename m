Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab1GTBJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 21:09:20 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60341 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab1GTBJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 21:09:18 -0400
Subject: [PATCH v2] tpm: Fix compilation warning when CONFIG_PNP is not
 defined
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: rdunlap@xenotime.net, Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>, linux-next@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 09:11:55 -0400
Message-ID: <1310994715.28315.0.camel@d941e-10>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The is_itpm() function is only accessed from a block surrounded by
#ifdef CONFIG_PNP. Therefore, also surround it with #ifdef CONFIG_PNP
and remove the #else branch causing the warning.

http://lxr.linux.no/#linux+v2.6.39/drivers/char/tpm/tpm_tis.c#L622

v2:
 - fixes a previous typo

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

---
 drivers/char/tpm/tpm_tis.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6/drivers/char/tpm/tpm_tis.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm_tis.c
+++ linux-2.6/drivers/char/tpm/tpm_tis.c
@@ -80,7 +80,7 @@ enum tis_defaults {
 static LIST_HEAD(tis_chips);
 static DEFINE_SPINLOCK(tis_lock);
 
-#ifdef CONFIG_ACPI
+#ifdef CONFIG_PNP
 static int is_itpm(struct pnp_dev *dev)
 {
 	struct acpi_device *acpi = pnp_acpi_device(dev);
@@ -93,11 +93,6 @@ static int is_itpm(struct pnp_dev *dev)
 
 	return 0;
 }
-#else
-static int is_itpm(struct pnp_dev *dev)
-{
-	return 0;
-}
 #endif
 
 static int check_locality(struct tpm_chip *chip, int l)


