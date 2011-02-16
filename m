Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565Ab1BPBve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:51:34 -0500
Received: from kroah.org ([198.145.64.141]:49097 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758440Ab1BPBus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:50:48 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:01 2011
Message-Id: <20110216014701.184553840@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Sergei Shtylyov <sshtylyov@mvista.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [069/115] pata_mpc52xx: inherit from ata_bmdma_port_ops
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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


