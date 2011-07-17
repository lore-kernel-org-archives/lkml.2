Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab1GQLxp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 07:53:45 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52346 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab1GQLxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 07:53:43 -0400
Date: Sun, 17 Jul 2011 19:53:23 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: stefanb@linux.vnet.ibm.com, sfr@canb.auug.org.au,
        srajiv@linux.vnet.ibm.com, jmorris@namei.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        kongjianjun@gmail.com, harryxiyou@gmail.com
Subject: Re: [PATCH] tpm: Move tpm_tis_reenable_interrupts out of
 CONFIG_PNP block
Message-ID: <20110717115320.GA14595@gmail.com>
Mail-Followup-To: Randy Dunlap <rdunlap@xenotime.net>,
	stefanb@linux.vnet.ibm.com, sfr@canb.auug.org.au,
	srajiv@linux.vnet.ibm.com, jmorris@namei.org,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
	kongjianjun@gmail.com, harryxiyou@gmail.com
References: <1310879064.15064.4.camel@d941e-10>
 <20110716223426.f1507465.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <20110716223426.f1507465.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 10:34:26PM -0700, Randy Dunlap wrote:
> New warning:
> drivers/char/tpm/tpm_tis.c:97: warning: 'is_itpm' defined but not used

From: Harry Wei <harryxiyou@gmail.com>

This patch can fix above warning.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 drivers/char/tpm/tpm_tis.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index dd21df5..5929bb2 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -79,26 +79,6 @@ enum tis_defaults {
 static LIST_HEAD(tis_chips);
 static DEFINE_SPINLOCK(tis_lock);
 
-#ifdef CONFIG_ACPI
-static int is_itpm(struct pnp_dev *dev)
-{
-	struct acpi_device *acpi = pnp_acpi_device(dev);
-	struct acpi_hardware_id *id;
-
-	list_for_each_entry(id, &acpi->pnp.ids, list) {
-		if (!strcmp("INTC0102", id->id))
-			return 1;
-	}
-
-	return 0;
-}
-#else
-static int is_itpm(struct pnp_dev *dev)
-{
-	return 0;
-}
-#endif
-
 static int check_locality(struct tpm_chip *chip, int l)
 {
 	if ((ioread8(chip->vendor.iobase + TPM_ACCESS(l)) &
-- 
1.7.0.4

