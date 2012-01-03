Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab2ACWfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:35:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab2ACWfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:35:37 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:32 2012
Message-Id: <20120103223032.068629775@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Blanchard <anton@samba.org>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [09/67] SCSI: mpt2sas: _scsih_smart_predicted_fault uses GFP_KERNEL in interrupt context
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit f6a290b419a2675c4b77a6b0731cd2a64332365e upstream.

_scsih_smart_predicted_fault is called in an interrupt and therefore
must allocate memory using GFP_ATOMIC.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -4145,7 +4145,7 @@ _scsih_smart_predicted_fault(struct MPT2
 	/* insert into event log */
 	sz = offsetof(Mpi2EventNotificationReply_t, EventData) +
 	     sizeof(Mpi2EventDataSasDeviceStatusChange_t);
-	event_reply = kzalloc(sz, GFP_KERNEL);
+	event_reply = kzalloc(sz, GFP_ATOMIC);
 	if (!event_reply) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);


