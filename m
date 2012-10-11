Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892Ab2JKCNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:13:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44978 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933786Ab2JKCNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:13:45 -0400
X-Sasl-enc: DnEsWBcP1kWXp+J6t0nJ9tyGph2qRWy5FL1990LzVFxA 1349921624
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Steffen Maier <maier@linux.vnet.ibm.com>,
        Martin Peschke <mpeschke@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 43/84] SCSI: zfcp: remove invalid reference to list iterator variable
Date: Thu, 11 Oct 2012 11:03:27 +0900
Message-Id: <20121011015424.804815261@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julia Lawall <Julia.Lawall@lip6.fr>

commit ca579c9f136af4274ccfd1bcaee7f38a29a0e2e9 upstream.

If list_for_each_entry, etc complete a traversal of the list, the iterator
variable ends up pointing to an address at an offset from the list head,
and not a meaningful structure.  Thus this value should not be used after
the end of the iterator.  Replace port->adapter->scsi_host by
adapter->scsi_host.

This problem was found using Coccinelle (http://coccinelle.lip6.fr/).

Oversight in upsteam commit of v2.6.37
a1ca48319a9aa1c5b57ce142f538e76050bb8972
"[SCSI] zfcp: Move ACL/CFDC code to zfcp_cfdc.c"
which merged the content of zfcp_erp_port_access_changed().

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/scsi/zfcp_cfdc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_cfdc.c
+++ b/drivers/s390/scsi/zfcp_cfdc.c
@@ -293,7 +293,7 @@ void zfcp_cfdc_adapter_access_changed(st
 	}
 	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 
-	shost_for_each_device(sdev, port->adapter->scsi_host) {
+	shost_for_each_device(sdev, adapter->scsi_host) {
 		zfcp_sdev = sdev_to_zfcp(sdev);
 		status = atomic_read(&zfcp_sdev->status);
 		if ((status & ZFCP_STATUS_COMMON_ACCESS_DENIED) ||


