Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab1LERa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:30:57 -0500
Received: from www17.your-server.de ([213.133.104.17]:38035 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932692Ab1LERax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:30:53 -0500
Subject: [PATCH] [SCSI] libsas: Use kcalloc instead of kzalloc to allocate
 array
From: Thomas Meyer <thomas@m3y3r.de>
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.330.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
--- a/drivers/scsi/libsas/sas_expander.c 2011-11-13 11:07:46.460470430 +0100
+++ b/drivers/scsi/libsas/sas_expander.c 2011-11-28 20:04:24.150985642 +0100
@@ -306,7 +306,7 @@ static int sas_expander_discover(struct
 	struct expander_device *ex = &dev->ex_dev;
 	int res = -ENOMEM;
 
-	ex->ex_phy = kzalloc(sizeof(*ex->ex_phy)*ex->num_phys, GFP_KERNEL);
+	ex->ex_phy = kcalloc(ex->num_phys, sizeof(*ex->ex_phy), GFP_KERNEL);
 	if (!ex->ex_phy)
 		return -ENOMEM;
 
