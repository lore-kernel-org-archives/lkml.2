Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab1KCByI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:54:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51262 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934445Ab1KCBlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:41:04 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:44 2011
Message-Id: <20111102222744.859644850@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jack Wang <jack_wang@usish.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [056/101] [SCSI] libsas: set sas_address and device type of rphy
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jack Wang <jack_wang@usish.com>

commit bb041a0e9c31229071b6e56e1d0d8374af0d2038 upstream.

Libsas forget to set the sas_address and device type of rphy lead to file
under /sys/class/sas_x show wrong value, fix that.

Signed-off-by: Jack Wang <jack_wang@usish.com>
Tested-by: Crystal Yu <crystal_yu@usish.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libsas/sas_expander.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -198,6 +198,8 @@ static void sas_set_ex_phy(struct domain
 	phy->virtual = dr->virtual;
 	phy->last_da_index = -1;
 
+	phy->phy->identify.sas_address = SAS_ADDR(phy->attached_sas_addr);
+	phy->phy->identify.device_type = phy->attached_dev_type;
 	phy->phy->identify.initiator_port_protocols = phy->attached_iproto;
 	phy->phy->identify.target_port_protocols = phy->attached_tproto;
 	phy->phy->identify.phy_identifier = phy_id;


