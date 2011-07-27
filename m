Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab1G0SmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 14:42:16 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:38495 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754543Ab1G0SmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 14:42:14 -0400
Date: Wed, 27 Jul 2011 11:42:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Leendert van Doorn <leendert@watson.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>, tpmdd-devel@lists.sourceforge.net
Subject: [PATCH -next] tpm_tis: fix build when ACPI is not enabled
Message-Id: <20110727114211.18be47cf.rdunlap@xenotime.net>
In-Reply-To: <20110727141151.d31e3da6a8d21a255473293c@canb.auug.org.au>
References: <20110727141151.d31e3da6a8d21a255473293c@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix tpm_tis.c build when CONFIG_ACPI is not enabled by providing
a stub function.  Fixes many build errors/warnings:

drivers/char/tpm/tpm_tis.c:89: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_tis.c:89: warning: type defaults to 'int' in declaration of 'type name'
drivers/char/tpm/tpm_tis.c:89: error: request for member 'list' in something not a structure or union
drivers/char/tpm/tpm_tis.c:89: warning: type defaults to 'int' in declaration of '__mptr'
drivers/char/tpm/tpm_tis.c:89: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_tis.c:89: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_tis.c:89: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_tis.c:89: warning: type defaults to 'int' in declaration of 'type name'
drivers/char/tpm/tpm_tis.c:89: error: request for member 'list' in something not a structure or union
drivers/char/tpm/tpm_tis.c:89: warning: type defaults to 'int' in declaration of 'type name'
drivers/char/tpm/tpm_tis.c:89: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_tis.c:89: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_tis.c:89: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_tis.c:89: warning: type defaults to 'int' in declaration of 'type name'
drivers/char/tpm/tpm_tis.c:89: error: request for member 'list' in something not a structure or union
drivers/char/tpm/tpm_tis.c:89: warning: type defaults to 'int' in declaration of '__mptr'
drivers/char/tpm/tpm_tis.c:89: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_tis.c:89: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_tis.c:89: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_tis.c:89: warning: type defaults to 'int' in declaration of 'type name'
drivers/char/tpm/tpm_tis.c:89: error: request for member 'list' in something not a structure or union
drivers/char/tpm/tpm_tis.c:89: warning: type defaults to 'int' in declaration of 'type name'
drivers/char/tpm/tpm_tis.c:90: error: dereferencing pointer to incomplete type

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Leendert van Doorn <leendert@watson.ibm.com>
---
 drivers/char/tpm/tpm_tis.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- linux-next-20110727.orig/drivers/char/tpm/tpm_tis.c
+++ linux-next-20110727/drivers/char/tpm/tpm_tis.c
@@ -80,7 +80,7 @@ enum tis_defaults {
 static LIST_HEAD(tis_chips);
 static DEFINE_SPINLOCK(tis_lock);
 
-#ifdef CONFIG_PNP
+#if defined(CONFIG_PNP) && defined(CONFIG_ACPI)
 static int is_itpm(struct pnp_dev *dev)
 {
 	struct acpi_device *acpi = pnp_acpi_device(dev);
@@ -93,6 +93,11 @@ static int is_itpm(struct pnp_dev *dev)
 
 	return 0;
 }
+#else
+static inline int is_itpm(struct pnp_dev *dev)
+{
+	return 0;
+}
 #endif
 
 static int check_locality(struct tpm_chip *chip, int l)
