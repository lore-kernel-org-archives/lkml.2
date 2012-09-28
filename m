Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965068Ab2I1UbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:31:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34785 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032859Ab2I1UbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:31:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Daniel J Blueman <daniel@quora.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [ 181/218] libata: Prevent interface errors with Seagate FreeAgent GoFlex
Date: Fri, 28 Sep 2012 13:16:38 -0700
Message-Id: <20120928201522.262152828@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4125,6 +4125,7 @@ static const struct ata_blacklist_entry
 
 	/* Devices which aren't very happy with higher link speeds */
 	{ "WD My Book",			NULL,	ATA_HORKAGE_1_5_GBPS, },
+	{ "Seagate FreeAgent GoFlex",	NULL,	ATA_HORKAGE_1_5_GBPS, },
 
 	/*
 	 * Devices which choke on SETXFER.  Applies only if both the


