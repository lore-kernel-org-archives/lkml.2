Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934126Ab0HEUVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:21:33 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55551 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934048Ab0HEUV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:21:26 -0400
Date: Thu, 5 Aug 2010 22:21:24 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 15/42] drivers/video/mbx/mbxfb.c: Adjust confusing if
 indentation
Message-ID: <Pine.LNX.4.64.1008052221020.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Indent the branch of an if.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable braces4@
position p1,p2;
statement S1,S2;
@@

(
if (...) { ... }
|
if (...) S1@p1 S2@p2
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

if (p1[0].column == p2[0].column):
  cocci.print_main("branch",p1)
  cocci.print_secs("after",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/video/mbx/mbxfb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/mbx/mbxfb.c
index afea9ab..aaf7612 100644
--- a/drivers/video/mbx/mbxfb.c
+++ b/drivers/video/mbx/mbxfb.c
@@ -629,14 +629,14 @@ static int mbxfb_ioctl(struct fb_info *info, unsigned int cmd,
 		case MBXFB_IOCS_PLANEORDER:
 			if (copy_from_user(&porder, (void __user*)arg,
 					sizeof(struct mbxfb_planeorder)))
-			return -EFAULT;
+				return -EFAULT;
 
 			return mbxfb_ioctl_planeorder(&porder);
 
 		case MBXFB_IOCS_ALPHA:
 			if (copy_from_user(&alpha, (void __user*)arg,
 					sizeof(struct mbxfb_alphaCtl)))
-			return -EFAULT;
+				return -EFAULT;
 
 			return mbxfb_ioctl_alphactl(&alpha);
 
