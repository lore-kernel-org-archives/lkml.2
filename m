Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439Ab2ILXpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:45:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36222 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933421Ab2ILXpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:45:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Kashyap Desai <Kashyap.Desai@lsi.com>,
        Adam Radford <aradford@gmail.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 36/46] SCSI: megaraid_sas: Move poll_aen_lock initializer
Date: Wed, 12 Sep 2012 16:39:26 -0700
Message-Id: <20120912233821.443691723@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233817.662663809@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/megaraid/megaraid_sas_base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4052,7 +4052,6 @@ megasas_probe_one(struct pci_dev *pdev,
 	spin_lock_init(&instance->cmd_pool_lock);
 	spin_lock_init(&instance->hba_lock);
 	spin_lock_init(&instance->completion_lock);
-	spin_lock_init(&poll_aen_lock);
 
 	mutex_init(&instance->aen_mutex);
 	mutex_init(&instance->reset_mutex);
@@ -5380,6 +5379,8 @@ static int __init megasas_init(void)
 	printk(KERN_INFO "megasas: %s %s\n", MEGASAS_VERSION,
 	       MEGASAS_EXT_VERSION);
 
+	spin_lock_init(&poll_aen_lock);
+
 	support_poll_for_event = 2;
 	support_device_change = 1;
 


