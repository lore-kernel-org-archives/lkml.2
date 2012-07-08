Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab2GHLi1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 07:38:27 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:56591 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751938Ab2GHLhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 07:37:55 -0400
X-IronPort-AV: E=Sophos;i="4.77,546,1336341600"; 
   d="scan'208";a="166023142"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: kernel-janitors@vger.kernel.org, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] drivers/s390/scsi/zfcp_cfdc.c: remove invalid reference to list iterator variable
Date: Sun,  8 Jul 2012 13:37:44 +0200
Message-Id: <1341747464-1772-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1341747464-1772-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1341747464-1772-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

If list_for_each_entry, etc complete a traversal of the list, the iterator
variable ends up pointing to an address at an offset from the list head,
and not a meaningful structure.  Thus this value should not be used after
the end of the iterator.  Replace port->adapter->scsi_host by
adapter->scsi_host.

This problem was found using Coccinelle (http://coccinelle.lip6.fr/).

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
This is not tested, an I am not sure that this is the right change.
Indeed, I'm not at all sure how the original code could have worked, since
port->adapter->scsi_host should be a completely random value.

 drivers/s390/scsi/zfcp_cfdc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_cfdc.c b/drivers/s390/scsi/zfcp_cfdc.c
index fab2c25..8ed63aa 100644
--- a/drivers/s390/scsi/zfcp_cfdc.c
+++ b/drivers/s390/scsi/zfcp_cfdc.c
@@ -293,7 +293,7 @@ void zfcp_cfdc_adapter_access_changed(struct zfcp_adapter *adapter)
 	}
 	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 
-	shost_for_each_device(sdev, port->adapter->scsi_host) {
+	shost_for_each_device(sdev, adapter->scsi_host) {
 		zfcp_sdev = sdev_to_zfcp(sdev);
 		status = atomic_read(&zfcp_sdev->status);
 		if ((status & ZFCP_STATUS_COMMON_ACCESS_DENIED) ||

