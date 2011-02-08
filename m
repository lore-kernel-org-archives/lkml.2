Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab1BHMXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:23:50 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48060 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab1BHMXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:23:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=IvAlqQfjyPXRRymGtlAY7cB4nLfyLTlPppYeZKy6EpFb51ELa955DHPO68mF6DtqsC
         ZgqItiUOxhB4zi8L+ma9UJsvNAmHPQlc4vosUgyiMzj8Z1+nXsByYP33CzJ1bG8kQzXP
         jhK9exxZArraBlEXJc2bHOHEnXjqM9Ks9SecA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Feb 2011 13:23:37 +0100
Message-Id: <20110208122337.19110.8889.sendpatchset@linux-mhg7.site>
In-Reply-To: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
Subject: [PATCH 01/20] ata_piix: SITRE handling fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7b6d27a9d65fef8795fdeee3733316450f840aa6 Mon Sep 17 00:00:00 2001
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 8 Feb 2011 12:39:24 +0100
Subject: [PATCH 01/20] ata_piix: SITRE handling fix

Set SITRE bit also in master-only configurations.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/ata_piix.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 6cb14ca..0f4856d 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -751,8 +751,6 @@ static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	if (is_slave) {
 		/* clear TIME1|IE1|PPE1|DTE1 */
 		master_data &= 0xff0f;
-		/* Enable SITRE (separate slave timing register) */
-		master_data |= 0x4000;
 		/* enable PPE1, IE1 and TIME1 as needed */
 		master_data |= (control << 4);
 		pci_read_config_byte(dev, slave_port, &slave_data);
@@ -770,6 +768,9 @@ static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
 			(timings[pio][0] << 12) |
 			(timings[pio][1] << 8);
 	}
+
+	/* Enable SITRE (separate slave timing register) */
+	master_data |= 0x4000;
 	pci_write_config_word(dev, master_port, master_data);
 	if (is_slave)
 		pci_write_config_byte(dev, slave_port, slave_data);
-- 
1.7.1

