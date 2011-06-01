Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162240Ab1FAI7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:59:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162175Ab1FAISM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:18:12 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:10 2011
Message-Id: <20110601081109.663529749@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:05 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jeff Garzik <jgarzik@pobox.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [035/165] libata: Use Maximum Write Same Length to report discard size
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 limit
Content-Length: 1118
Lines: 33

From: "Martin K. Petersen" <martin.petersen@oracle.com>

commit 5f4e206666f834340b69ddb43f86de3851c8675a upstream.

Previously we used Maximum Unmap LBA Count in the Block Limits VPD to
signal the maximum number of sectors we could handle in a single Write
Same command.

Starting with SBC3r26 the Block Limits VPD has an explicit limit on the
number of blocks in a Write Same. This means we can stop abusing a field
related to the Unmap command and let our SAT use the proper value in the
VPD (Maximum Write Same Length).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2139,7 +2139,7 @@ static unsigned int ata_scsiop_inq_b0(st
 	 * with the unmap bit set.
 	 */
 	if (ata_id_has_trim(args->id)) {
-		put_unaligned_be32(65535 * 512 / 8, &rbuf[20]);
+		put_unaligned_be64(65535 * 512 / 8, &rbuf[36]);
 		put_unaligned_be32(1, &rbuf[28]);
 	}
 


