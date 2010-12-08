Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab0LHCJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:09:30 -0500
Received: from kroah.org ([198.145.64.141]:58379 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140Ab0LHArX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:23 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:30 2010
Message-Id: <20101208004430.203160113@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Douglas Gilbert <dgilbert@interlog.com>,
        Jeff Garzik <jgarzik@redhat.com>, Kerin Millar <kerframil@gmail.com>
Subject: [059/127] libata-scsi passthru: fix bug which truncated LBA48 return values
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Douglas Gilbert <dgilbert@interlog.com>

commit bc496ed00ab1411d3efaf295b72e0c9eb343e1a3 upstream.

Fix assignment which overwrote SAT ATA PASS-THROUGH command EXTEND
bit setting (ATA_TFLAG_LBA48)

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Kerin Millar <kerframil@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2825,7 +2825,7 @@ static unsigned int ata_scsi_pass_thru(s
 	 * write indication (used for PIO/DMA setup), result TF is
 	 * copied back and we don't whine too much about its failure.
 	 */
-	tf->flags = ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	if (scmd->sc_data_direction == DMA_TO_DEVICE)
 		tf->flags |= ATA_TFLAG_WRITE;
 


