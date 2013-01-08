Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab3AHXti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:49:38 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53663 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab3AHXho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:44 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 33/77] USB: whci-hcd: fix endian conversion in qset_clear()
Date: Tue, 8 Jan 2013 18:35:12 -0500
Message-ID: <1357688156-25387-34-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 8746c83d538cab273d335acb2be226d096f4a5af upstream.

qset->qh.link is an __le64 field and we should be using cpu_to_le64()
to fill it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/whci/qset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/whci/qset.c b/drivers/usb/host/whci/qset.c
index b388dd1..c0f48e4 100644
--- a/drivers/usb/host/whci/qset.c
+++ b/drivers/usb/host/whci/qset.c
@@ -124,7 +124,7 @@ void qset_clear(struct whc *whc, struct whc_qset *qset)
 {
 	qset->td_start = qset->td_end = qset->ntds = 0;
 
-	qset->qh.link = cpu_to_le32(QH_LINK_NTDS(8) | QH_LINK_T);
+	qset->qh.link = cpu_to_le64(QH_LINK_NTDS(8) | QH_LINK_T);
 	qset->qh.status = qset->qh.status & QH_STATUS_SEQ_MASK;
 	qset->qh.err_count = 0;
 	qset->qh.scratch[0] = 0;
-- 
1.7.12.1

