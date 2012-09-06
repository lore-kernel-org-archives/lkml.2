Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433Ab2IFP0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:26:30 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33245 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793Ab2IFPYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:24:17 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/14] drivers/media/pci/ngene/ngene-core.c: fix error return code
Date: Thu,  6 Sep 2012 17:23:54 +0200
Message-Id: <1346945041-26676-7-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/media/pci/ngene/ngene-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index c8e0d5b..6bb44f1 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -1691,7 +1691,8 @@ int __devinit ngene_probe(struct pci_dev *pci_dev,
 	dev->i2c_current_bus = -1;
 
 	/* Register DVB adapters and devices for both channels */
-	if (init_channels(dev) < 0)
+	stat = init_channels(dev);
+	if (stat < 0)
 		goto fail2;
 
 	return 0;

