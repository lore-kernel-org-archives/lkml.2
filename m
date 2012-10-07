Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab2JGXXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:23:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38524 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754395Ab2JGXWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:55 -0400
Message-Id: <20121007225842.584009963@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel J Blueman <daniel@quora.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [ 057/108] [libata] Prevent interface errors with Seagate FreeAgent GoFlex
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel J Blueman <daniel@quora.org>

commit c531077f40abc9f2129c4c83a30b3f8d6ce1c0e7 upstream.

When using my Seagate FreeAgent GoFlex eSATAp external disk enclosure,
interface errors are always seen until 1.5Gbps is negotiated [1]. This
occurs using any disk in the enclosure, and when the disk is connected
directly with a generic passive eSATAp cable, we see stable 3Gbps
operation as expected.

Blacklist 3Gbps mode to avoid dataloss and the ~30s delay bus reset
and renegotiation incurs.

Signed-off-by: Daniel J Blueman <daniel@quora.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/libata-core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c14f88c..95a656f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4129,6 +4129,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 
 	/* Devices which aren't very happy with higher link speeds */
 	{ "WD My Book",			NULL,	ATA_HORKAGE_1_5_GBPS, },
+	{ "Seagate FreeAgent GoFlex",	NULL,	ATA_HORKAGE_1_5_GBPS, },
 
 	/*
 	 * Devices which choke on SETXFER.  Applies only if both the


