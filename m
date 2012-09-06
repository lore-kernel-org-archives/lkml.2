Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab2IFPYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:24:19 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43127 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757743Ab2IFPYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:24:16 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/14] drivers/media/pci/ttpci/budget-av.c: fix error return code
Date: Thu,  6 Sep 2012 17:23:53 +0200
Message-Id: <1346945041-26676-6-git-send-email-peter.senna@gmail.com>
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
 drivers/media/pci/ttpci/budget-av.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/ttpci/budget-av.c b/drivers/media/pci/ttpci/budget-av.c
index 12ddb53..1f8b1bb 100644
--- a/drivers/media/pci/ttpci/budget-av.c
+++ b/drivers/media/pci/ttpci/budget-av.c
@@ -1477,8 +1477,8 @@ static int budget_av_attach(struct saa7146_dev *dev, struct saa7146_pci_extensio
 
 	if (saa7113_init(budget_av) == 0) {
 		budget_av->has_saa7113 = 1;
-
-		if (0 != saa7146_vv_init(dev, &vv_data)) {
+		err = saa7146_vv_init(dev, &vv_data);
+		if (err != 0) {
 			/* fixme: proper cleanup here */
 			ERR("cannot init vv subsystem\n");
 			return err;

