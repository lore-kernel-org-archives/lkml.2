Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab1HJLcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 07:32:20 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59574 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab1HJLcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 07:32:19 -0400
From: Julia Lawall <julia@diku.dk>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: kernel-janitors@vger.kernel.org, Kashyap Desai <kashyap.desai@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/scsi/mpt2sas/mpt2sas_transport.c: add missing sas_phy_free
Date: Wed, 10 Aug 2011 13:32:13 +0200
Message-Id: <1312975933-18277-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In each case, sas_phy_add has not yet been successfully applied, so use
sas_phy_free to free phy.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/mpt2sas/mpt2sas_transport.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 15c7980..762f05e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -857,6 +857,7 @@ mpt2sas_transport_add_host_phy(struct MPT2SAS_ADAPTER *ioc, struct _sas_phy
 	    &mpt2sas_phy->identify))) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
+		sas_phy_free(phy);
 		return -1;
 	}
 	phy->identify = mpt2sas_phy->identify;
@@ -923,6 +924,7 @@ mpt2sas_transport_add_expander_phy(struct MPT2SAS_ADAPTER *ioc, struct _sas_phy
 	    &mpt2sas_phy->identify))) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
+		sas_phy_free(phy);
 		return -1;
 	}
 	phy->identify = mpt2sas_phy->identify;

