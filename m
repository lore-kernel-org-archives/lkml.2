Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab2ECPVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:21:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59817 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab2ECPV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:21:28 -0400
From: Daniel J Blueman <daniel@quora.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@quora.org>
Subject: [PATCH] Prevent interface errors with Seagate FreeAgent GoFlex
Date: Thu,  3 May 2012 23:21:00 +0800
Message-Id: <1336058460-19924-1-git-send-email-daniel@quora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When connected by the optional eSATAp cable, various interface errors
occur with my new external Seagate FreeAgent GoFlex (firmware 0110) until
the interface is forced to 1.5Gbps mode. Blacklist 3.0Gbps mode with it
to avoid the error messages, delays and dataloss potential.

Signed-off-by: Daniel J Blueman <daniel@quora.org>
---
 drivers/ata/libata-core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 28db50b..0781510 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4119,6 +4119,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 
 	/* Devices which aren't very happy with higher link speeds */
 	{ "WD My Book",			NULL,	ATA_HORKAGE_1_5_GBPS, },
+	{ "Seagate FreeAgent GoFlex",	NULL,	ATA_HORKAGE_1_5_GBPS, },
 
 	/*
 	 * Devices which choke on SETXFER.  Applies only if both the
-- 
1.7.9.5

