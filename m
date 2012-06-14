Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab2FOABr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:01:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45611 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073Ab2FOAA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:00:59 -0400
Message-Id: <20120614235627.516423964@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:57:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andy Whitcroft <apw@canonical.com>,
        Jeff Garzik <jgarzik@redhat.com>, Victor Miasnikov <vvm@tut.by>
Subject: [ 41/42] libata: add a host flag to ignore detected ATA devices
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Whitcroft <apw@canonical.com>

commit db63a4c8115a0bb904496e1cdd3e7488e68b0d06 upstream.

Where devices are visible via more than one host we sometimes wish to
indicate that cirtain devices should be ignored on a specific host.  Add a
host flag indicating that this host wishes to ignore ATA specific devices.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Victor Miasnikov <vvm@tut.by>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-core.c |    6 ++++++
 include/linux/libata.h    |    1 +
 2 files changed, 7 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1973,6 +1973,12 @@ retry:
 	if (class == ATA_DEV_ATA) {
 		if (!ata_id_is_ata(id) && !ata_id_is_cfa(id))
 			goto err_out;
+		if (ap->host->flags & ATA_HOST_IGNORE_ATA &&
+							ata_id_is_ata(id)) {
+			ata_dev_dbg(dev,
+				"host indicates ignore ATA devices, ignored\n");
+			return -ENOENT;
+		}
 	} else {
 		if (ata_id_is_ata(id))
 			goto err_out;
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -247,6 +247,7 @@ enum {
 	ATA_HOST_SIMPLEX	= (1 << 0),	/* Host is simplex, one DMA channel per host only */
 	ATA_HOST_STARTED	= (1 << 1),	/* Host started */
 	ATA_HOST_PARALLEL_SCAN	= (1 << 2),	/* Ports on this host can be scanned in parallel */
+	ATA_HOST_IGNORE_ATA	= (1 << 3),	/* Ignore ATA devices on this host. */
 
 	/* bits 24:31 of host->flags are reserved for LLD specific flags */
 


