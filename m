Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606Ab1I1Wv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:51:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756068Ab1I1WvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:51:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:48 2011
Message-Id: <20110928220148.452593942@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bhanu Prakash Gollapudi <bprakash@broadcom.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [219/244] [SCSI] bnx2fc: scsi_dma_unmap() not invoked on IO completions
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

commit b5a95fe7ef464a67fab6ff870aa740739e788f90 upstream.

Do not set io_req->sc_cmd to NULL until bnx2fc_unmap_sg_list() is called to
enable it to unmap the DMA mappings.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>

---
 drivers/scsi/bnx2fc/bnx2fc_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1734,7 +1734,6 @@ void bnx2fc_process_scsi_cmd_compl(struc
 		printk(KERN_ERR PFX "SCp.ptr is NULL\n");
 		return;
 	}
-	io_req->sc_cmd = NULL;
 
 	if (io_req->on_active_queue) {
 		list_del_init(&io_req->link);
@@ -1754,6 +1753,7 @@ void bnx2fc_process_scsi_cmd_compl(struc
 	}
 
 	bnx2fc_unmap_sg_list(io_req);
+	io_req->sc_cmd = NULL;
 
 	switch (io_req->fcp_status) {
 	case FC_GOOD:


