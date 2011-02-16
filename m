Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab1BPBIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:08:44 -0500
Received: from kroah.org ([198.145.64.141]:45762 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933137Ab1BPAto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:49:44 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:08 2011
Message-Id: <20110216002108.297161002@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [patch 092/176] RDMA/cxgb4: Set the correct device physical function for iWARP connections
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steve Wise <swise@opengridcomputing.com>

commit 94788657c94169171971968c9d4b6222c5e704aa upstream.

The PF passed to FW was 0, causing PCI failures in an SR-IOV environment.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/hw/cxgb4/cm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -383,7 +383,7 @@ static void send_flowc(struct c4iw_ep *e
 					  16)) | FW_WR_FLOWID(ep->hwtid));
 
 	flowc->mnemval[0].mnemonic = FW_FLOWC_MNEM_PFNVFN;
-	flowc->mnemval[0].val = cpu_to_be32(0);
+	flowc->mnemval[0].val = cpu_to_be32(PCI_FUNC(ep->com.dev->rdev.lldi.pdev->devfn) << 8);
 	flowc->mnemval[1].mnemonic = FW_FLOWC_MNEM_CH;
 	flowc->mnemval[1].val = cpu_to_be32(ep->tx_chan);
 	flowc->mnemval[2].mnemonic = FW_FLOWC_MNEM_PORT;


