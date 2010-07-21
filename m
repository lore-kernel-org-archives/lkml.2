Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab0GUTHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 15:07:40 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35532 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab0GUTHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 15:07:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZooDp79Y0bvDU2AucL02mBY7hQ7448K6+yJwK7eZNvGucQi8NTak+ncrA/qgZzxvNf
         lj/QYDJNOtGKy1SoThjos0E76eFhRyBmkwODt0IUo0IgmAEjsy5y8agRkl2gTgzMFf/2
         BUJPf/9DWHSqPS8suPoaGrj8RVGEIE5jfWJgA=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Doug Thompson <dougthompson@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tamas Vincze <tom@vincze.org>, Aristeu Rozanski <aris@ruivo.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] edac: i5000: carefull error handling
Date: Wed, 21 Jul 2010 23:07:21 +0400
Message-Id: <1279739241-8203-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-EIO is not the only error code that pci_enable_device() may return,
also the set of errors can be enhanced in future. We should compare
return code with zero, not with concrete error value.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/edac/i5000_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 996c1bd..a5cefab 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -1482,7 +1482,7 @@ static int __devinit i5000_init_one(struct pci_dev *pdev,
 
 	/* wake up device */
 	rc = pci_enable_device(pdev);
-	if (rc == -EIO)
+	if (rc)
 		return rc;
 
 	/* now probe and enable the device */
-- 
1.7.0.4

