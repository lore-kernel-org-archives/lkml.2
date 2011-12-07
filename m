Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab1LGQus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:50:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757625Ab1LGQUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:20:16 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:26 2011
Message-Id: <20111207160826.638249319@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:07:09 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [49/80] USB: whci-hcd: fix endian conversion in qset_clear()
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 8746c83d538cab273d335acb2be226d096f4a5af upstream.

qset->qh.link is an __le64 field and we should be using cpu_to_le64()
to fill it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/whci/qset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/whci/qset.c
+++ b/drivers/usb/host/whci/qset.c
@@ -124,7 +124,7 @@ void qset_clear(struct whc *whc, struct
 {
 	qset->td_start = qset->td_end = qset->ntds = 0;
 
-	qset->qh.link = cpu_to_le32(QH_LINK_NTDS(8) | QH_LINK_T);
+	qset->qh.link = cpu_to_le64(QH_LINK_NTDS(8) | QH_LINK_T);
 	qset->qh.status = qset->qh.status & QH_STATUS_SEQ_MASK;
 	qset->qh.err_count = 0;
 	qset->qh.scratch[0] = 0;


