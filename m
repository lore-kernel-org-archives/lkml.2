Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab2HOUYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:24:36 -0400
Received: from mail.windriver.com ([147.11.1.11]:36805 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591Ab2HOTua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:30 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jack Wang <jack_wang@usish.com>,
        James Bottomley <JBottomley@parallels.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 067/165] libsas: set sas_address and device type of rphy
Date: Wed, 15 Aug 2012 15:46:51 -0400
Message-ID: <1345060109-9187-68-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Wang <jack_wang@usish.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit bb041a0e9c31229071b6e56e1d0d8374af0d2038 upstream.

Libsas forget to set the sas_address and device type of rphy lead to file
under /sys/class/sas_x show wrong value, fix that.

Signed-off-by: Jack Wang <jack_wang@usish.com>
Tested-by: Crystal Yu <crystal_yu@usish.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/libsas/sas_expander.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 7107bbc..4ee42bb 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -199,6 +199,8 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
 	phy->virtual = dr->virtual;
 	phy->last_da_index = -1;
 
+	phy->phy->identify.sas_address = SAS_ADDR(phy->attached_sas_addr);
+	phy->phy->identify.device_type = phy->attached_dev_type;
 	phy->phy->identify.initiator_port_protocols = phy->attached_iproto;
 	phy->phy->identify.target_port_protocols = phy->attached_tproto;
 	phy->phy->identify.phy_identifier = phy_id;
-- 
1.7.12.rc2

