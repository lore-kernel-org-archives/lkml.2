Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab0KSVd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:33:57 -0500
Received: from kroah.org ([198.145.64.141]:44411 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860Ab0KSVd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:33:56 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:32:31 2010
Message-Id: <20101119213231.459788237@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:30:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        James Bottomley <James.Bottomley@suse.de>
Subject: [3/5] [SCSI] libsas: fix NCQ mixing with non-NCQ
In-Reply-To: <20101119213300.GA4637@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Milburn <dmilburn@redhat.com>

commit f0ad30d3d2dc924decc0e10b1ff6dc32525a5d99 upstream.

Some cards (like mvsas) have issue troubles if non-NCQ commands are
mixed with NCQ ones.  Fix this by using the libata default NCQ check
routine which waits until all NCQ commands are complete before issuing
a non-NCQ one.  The impact to cards (like aic94xx) which don't need
this logic should be minimal

Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libsas/sas_ata.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -346,6 +346,7 @@ static int sas_ata_scr_read(struct ata_p
 static struct ata_port_operations sas_sata_ops = {
 	.phy_reset		= sas_ata_phy_reset,
 	.post_internal_cmd	= sas_ata_post_internal,
+	.qc_defer               = ata_std_qc_defer,
 	.qc_prep		= ata_noop_qc_prep,
 	.qc_issue		= sas_ata_qc_issue,
 	.qc_fill_rtf		= sas_ata_qc_fill_rtf,


