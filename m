Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab2IQAuT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33333 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966Ab2IQAt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:26 -0400
Message-Id: <20120917003627.453243120@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:34 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kashyap Desai <Kashyap.Desai@lsi.com>,
        Adam Radford <aradford@gmail.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 009/135] [SCSI] megaraid_sas: Move poll_aen_lock initializer
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kashyap Desai <Kashyap.Desai@lsi.com>

commit bd8d6dd43a77bfd2b8fef5b094b9d6095e169dee upstream.

The following patch moves the poll_aen_lock initializer from
megasas_probe_one() to megasas_init().  This prevents a crash when a user
loads the driver and tries to issue a poll() system call on the ioctl
interface with no adapters present.

Signed-off-by: Kashyap Desai <Kashyap.Desai@lsi.com>
Signed-off-by: Adam Radford <aradford@gmail.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index dc27598..ed38454 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4066,7 +4066,6 @@ megasas_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&instance->cmd_pool_lock);
 	spin_lock_init(&instance->hba_lock);
 	spin_lock_init(&instance->completion_lock);
-	spin_lock_init(&poll_aen_lock);
 
 	mutex_init(&instance->aen_mutex);
 	mutex_init(&instance->reset_mutex);
@@ -5392,6 +5391,8 @@ static int __init megasas_init(void)
 	printk(KERN_INFO "megasas: %s %s\n", MEGASAS_VERSION,
 	       MEGASAS_EXT_VERSION);
 
+	spin_lock_init(&poll_aen_lock);
+
 	support_poll_for_event = 2;
 	support_device_change = 1;
 


