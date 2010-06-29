Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab0F2KPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:15:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:47959 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab0F2KPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:15:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xZBI6CMNLOuXQ7NZXk0UALONTpu33A6MB3gdCPrnYjpj0NOOEXfl7PqVsXw5BvkNZc
         c34hyjSORfQ7PNemmkUn7lPRYQe5qg+/UWDTRx9SVqbs2cUmZLs+VMrp8J0liwjUthAl
         iIVq+bDIFefRGpPRaspNwur70wTN5Fxwh5oqg=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jarod Wilson <jarod@redhat.com>,
       Manu Abraham <abraham.manu@gmail.com>, Scott Davilla <davilla@4pi.com>,
       Ameya Palande <2ameya@gmail.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 13/25] crystalhd_lnx: remove casts from void*
Date: Tue, 29 Jun 2010 14:15:43 +0400
Message-Id: <1277806544-31146-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/crystalhd/crystalhd_lnx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index a4ec891..ce67392 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -273,7 +273,7 @@ static long chd_dec_ioctl(struct file *fd, unsigned int cmd, unsigned long ua)
 		return -EINVAL;
 	}
 
-	uc = (struct crystalhd_user *)fd->private_data;
+	uc = fd->private_data;
 	if (!uc) {
 		BCMLOG_ERR("Failed to get uc\n");
 		return -ENODATA;
@@ -334,7 +334,7 @@ static int chd_dec_close(struct inode *in, struct file *fd)
 		return -EINVAL;
 	}
 
-	uc = (struct crystalhd_user *)fd->private_data;
+	uc = fd->private_data;
 	if (!uc) {
 		BCMLOG_ERR("Failed to get uc\n");
 		return -ENODATA;
-- 
1.7.0.4

