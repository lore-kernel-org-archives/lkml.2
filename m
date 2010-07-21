Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab0GUTHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 15:07:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35532 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758795Ab0GUTHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 15:07:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SQjMyI23JgjOzVysYjzHgRqz50Aw83fOip6MWS2d87kXywM60JOUOWReyZu5FvfWK9
         h/d2QhCiXklB2emlTYIOKx2FjMYFpajASlep75YU9vZ4M1KEA8LcIAa0yaHW0sMxxMK0
         yfU6DxNFrf8GRY8wgPvkKAA6/Q1lmRhhVjkOU=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeff Roberson <jroberson@jroberson.net>,
        Doug Thompson <dougthompson@xmission.com>,
        Joe Perches <joe@perches.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] edac: i5400: carefull error handling
Date: Wed, 21 Jul 2010 23:07:25 +0400
Message-Id: <1279739245-8243-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-EIO is not the only error code that pci_enable_device() may return,
also the set of errors can be enhanced in future. We should compare
return code with zero, not with concrete error value.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/edac/i5400_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 010c1d6..38a9be9 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1348,7 +1348,7 @@ static int __devinit i5400_init_one(struct pci_dev *pdev,
 
 	/* wake up device */
 	rc = pci_enable_device(pdev);
-	if (rc == -EIO)
+	if (rc)
 		return rc;
 
 	/* now probe and enable the device */
-- 
1.7.0.4

