Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab1DYU0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:26:38 -0400
Received: from 1wt.eu ([62.212.114.60]:34656 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932550Ab1DYU0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:26:35 -0400
Message-Id: <20110425200234.252228845@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:01 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Tejun Heo <tj@kernel.org>, Sergei Shtylyov <sshtylyov@mvista.com>,
        Jeff Garzik <jgarzik@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 029/173] pata_mpc52xx: inherit from ata_bmdma_port_ops
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 77c5fd19075d299fe820bb59bb21b0b113676e20 upstream.

pata_mpc52xx supports BMDMA but inherits ata_sff_port_ops which
triggers BUG_ON() when a DMA command is issued.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Roman Fietze <roman.fietze@telemotive.de>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_mpc52xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -610,7 +610,7 @@ static struct scsi_host_template mpc52xx
 };
 
 static struct ata_port_operations mpc52xx_ata_port_ops = {
-	.inherits		= &ata_sff_port_ops,
+	.inherits		= &ata_bmdma_port_ops,
 	.sff_dev_select		= mpc52xx_ata_dev_select,
 	.set_piomode		= mpc52xx_ata_set_piomode,
 	.set_dmamode		= mpc52xx_ata_set_dmamode,


