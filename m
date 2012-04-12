Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762941Ab2DLWkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:40:53 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:36696 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757869Ab2DLWkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:40:52 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-160.messagelabs.com!1334270443!3697232!4
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ata: libata-eh.c: local functions should not be exposed globally
Date: Thu, 12 Apr 2012 15:40:37 -0700
User-Agent: KMail/1.9.9
CC: <linux-ide@vger.kernel.org>, <jgarzik@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204121540.37253.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function ata_ering_clear_cb is only referenced in this file and
should be marked static to prevent it from being exposed globally.

This quiets the sparse warning:

warning: symbol 'ata_ering_clear_cb' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jeff Garzik <jgarzik@pobox.com>

---

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index b02748b..1ae0417 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -419,7 +419,7 @@ int ata_ering_map(struct ata_ering *ering,
 	return rc;
 }
 
-int ata_ering_clear_cb(struct ata_ering_entry *ent, void *void_arg)
+static int ata_ering_clear_cb(struct ata_ering_entry *ent, void *void_arg)
 {
 	ent->eflags |= ATA_EFLAG_OLD_ER;
 	return 0;
