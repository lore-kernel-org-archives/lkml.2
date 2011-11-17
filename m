Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab1KSLiG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 06:38:06 -0500
Received: from www17.your-server.de ([213.133.104.17]:50673 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab1KSLiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 06:38:04 -0500
Subject: [PATCH] [SCSI] aacraid: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.290.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
--- a/drivers/scsi/aacraid/commctrl.c 2011-11-07 19:38:06.463566391 +0100
+++ b/drivers/scsi/aacraid/commctrl.c 2011-11-08 10:53:23.848146953 +0100
@@ -631,15 +631,14 @@ static int aac_send_raw_srb(struct aac_d
 			}
 		} else {
 			struct user_sgmap* usg;
-			usg = kmalloc(actual_fibsize - sizeof(struct aac_srb)
-			  + sizeof(struct sgmap), GFP_KERNEL);
+			usg = kmemdup(upsg,
+				      actual_fibsize - sizeof(struct aac_srb) + sizeof(struct sgmap),
+				      GFP_KERNEL);
 			if (!usg) {
 				dprintk((KERN_DEBUG"aacraid: Allocation error in Raw SRB command\n"));
 				rcode = -ENOMEM;
 				goto cleanup;
 			}
-			memcpy (usg, upsg, actual_fibsize - sizeof(struct aac_srb)
-			  + sizeof(struct sgmap));
 			actual_fibsize = actual_fibsize64;
 
 			for (i = 0; i < usg->count; i++) {
