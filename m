Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933879Ab2AJXBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:01:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933598Ab2AJXBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:01:05 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:50:24 2012
Message-Id: <20120110215024.303370465@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:48:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kashyap Desai <kashyap.desai@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [39/42] SCSI: mpt2sas: Added missing mpt2sas_base_detach call from scsih_remove context
In-Reply-To: <20120110215031.GA19398@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "kashyap.desai@lsi.com" <kashyap.desai@lsi.com>

commit 9ae89b0296e275d5a556068b40b7c2557a556a85 upstream.

mpt2sas_base_detach() call was removed from _scsih_remove() while
doing some code shuffling.  Mainly when we work on adding code for
scsih_shutdown().  I have added back mpt2sas_base_detach() which will
get callled from _scsih_remove().

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>

---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -7354,6 +7354,7 @@ _scsih_remove(struct pci_dev *pdev)
 	}
 
 	sas_remove_host(shost);
+	mpt2sas_base_detach(ioc);
 	list_del(&ioc->list);
 	scsi_remove_host(shost);
 	scsi_host_put(shost);


