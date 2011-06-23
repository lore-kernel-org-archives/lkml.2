Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551Ab1FWSDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:03:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:34869 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933528Ab1FWRhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:18 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Tejun Heo <tj@kernel.org>,
        Jeff Garzik <jgarzik@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 066/247] pata_mpc52xx: inherit from ata_bmdma_port_ops
Date: Thu, 23 Jun 2011 13:32:14 -0400
Message-Id: <1308850515-15242-7-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 77c5fd19075d299fe820bb59bb21b0b113676e20 upstream.

pata_mpc52xx supports BMDMA but inherits ata_sff_port_ops which
triggers BUG_ON() when a DMA command is issued.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Roman Fietze <roman.fietze@telemotive.de>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/ata/pata_mpc52xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 9f5b053..e80ebcb 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -610,7 +610,7 @@ static struct scsi_host_template mpc52xx_ata_sht = {
 };
 
 static struct ata_port_operations mpc52xx_ata_port_ops = {
-	.inherits		= &ata_sff_port_ops,
+	.inherits		= &ata_bmdma_port_ops,
 	.sff_dev_select		= mpc52xx_ata_dev_select,
 	.set_piomode		= mpc52xx_ata_set_piomode,
 	.set_dmamode		= mpc52xx_ata_set_dmamode,
-- 
1.7.4.4

