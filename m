Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab1CBWKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:10:31 -0500
Received: from unix.wroclaw.pl ([94.23.28.62]:35288 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757516Ab1CBWKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:10:30 -0500
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Bhanu Prakash Gollapudi <bprakash@broadcom.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: [PATCH] [SCSI] bnx2fc: fix build error when !CONFIG_MODULES
Date: Wed,  2 Mar 2011 23:10:03 +0100
Message-Id: <1299103803-32594-1-git-send-email-mk@lab.zgora.pl>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20110302182740.e4dfd79f.sfr@canb.auug.org.au>
References: <20110302182740.e4dfd79f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on unix.wroclaw.pl
	Spam=No score=-1.4 bayes=0.5 autolearn=disabled
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: dereferencing pointer to incomplete type
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: ‘MODULE_STATE_LIVE’ undeclared (first use in this function)

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index e476e87..689db39 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1812,10 +1812,12 @@ static int bnx2fc_disable(struct net_device *netdev)
 
 	mutex_lock(&bnx2fc_dev_lock);
 
+#ifdef CONFIG_SCSI_BNX2X_FCOE_MODULE
 	if (THIS_MODULE->state != MODULE_STATE_LIVE) {
 		rc = -ENODEV;
 		goto nodev;
 	}
+#endif
 
 	/* obtain physical netdev */
 	if (netdev->priv_flags & IFF_802_1Q_VLAN)
@@ -1875,10 +1877,12 @@ static int bnx2fc_enable(struct net_device *netdev)
 	BNX2FC_MISC_DBG("Entered %s\n", __func__);
 	mutex_lock(&bnx2fc_dev_lock);
 
+#ifdef CONFIG_SCSI_BNX2X_FCOE_MODULE
 	if (THIS_MODULE->state != MODULE_STATE_LIVE) {
 		rc = -ENODEV;
 		goto nodev;
 	}
+#endif
 
 	/* obtain physical netdev */
 	if (netdev->priv_flags & IFF_802_1Q_VLAN)
-- 
1.7.0.4

