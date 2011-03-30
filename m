Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330Ab1C3V6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:58:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:4889 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964812Ab1C3VGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903734528"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: tj@kernel.org, ak@linux.intel.com, sshtylyov@mvista.com,
        jgarzik@redhat.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [71/275] pata_mpc52xx: inherit from ata_bmdma_port_ops
Message-Id: <20110330210508.6B4CE3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Tejun Heo <tj@kernel.org>

commit 77c5fd19075d299fe820bb59bb21b0b113676e20 upstream.

pata_mpc52xx supports BMDMA but inherits ata_sff_port_ops which
triggers BUG_ON() when a DMA command is issued.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reported-by: Roman Fietze <roman.fietze@telemotive.de>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_mpc52xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/ata/pata_mpc52xx.c
===================================================================
--- linux-2.6.35.y.orig/drivers/ata/pata_mpc52xx.c	2011-03-29 22:51:41.645657560 -0700
+++ linux-2.6.35.y/drivers/ata/pata_mpc52xx.c	2011-03-29 23:02:59.649309143 -0700
@@ -610,7 +610,7 @@
 };
 
 static struct ata_port_operations mpc52xx_ata_port_ops = {
-	.inherits		= &ata_sff_port_ops,
+	.inherits		= &ata_bmdma_port_ops,
 	.sff_dev_select		= mpc52xx_ata_dev_select,
 	.set_piomode		= mpc52xx_ata_set_piomode,
 	.set_dmamode		= mpc52xx_ata_set_dmamode,
