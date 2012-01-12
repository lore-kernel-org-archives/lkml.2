Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab2ALVuC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 16:50:02 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:54327 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651Ab2ALVth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 16:49:37 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Dan Williams <dan.j.williams@intel.com>
Cc: kernel-janitors@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] drivers/dma/amba-pl08x.c: adjust double test
Date: Thu, 12 Jan 2012 22:49:29 +0100
Message-Id: <1326404970-1084-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1326404970-1084-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1326404970-1084-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Rewrite a duplicated test to test the correct value

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E;
@@

(
* E
  || ... || E
|
* E
  && ... && E
)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
There is a dstbus field, so it is my guess that that should be tested
instead of testing the srcbus field again.

 drivers/dma/amba-pl08x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 8a28158..840c6c0 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -649,7 +649,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 			}
 
 			if ((bd.srcbus.addr % bd.srcbus.buswidth) ||
-					(bd.srcbus.addr % bd.srcbus.buswidth)) {
+					(bd.dstbus.addr % bd.dstbus.buswidth)) {
 				dev_err(&pl08x->adev->dev,
 					"%s src & dst address must be aligned to src"
 					" & dst width if peripheral is flow controller",

