Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab0EMUHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:07:24 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:44468 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381Ab0EMUHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:07:17 -0400
Date: Thu, 13 May 2010 22:07:11 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Petr Vandrovec <vandrove@vc.cvut.cz>, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 18/20] drivers/video/matrox: Use kzalloc
Message-ID: <Pine.LNX.4.64.1005132206530.6282@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kzalloc rather than the combination of kmalloc and memset.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,size,flags;
statement S;
@@

-x = kmalloc(size,flags);
+x = kzalloc(size,flags);
 if (x == NULL) S
-memset(x, 0, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/video/matrox/matroxfb_base.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/drivers/video/matrox/matroxfb_base.c b/drivers/video/matrox/matroxfb_base.c
--- a/drivers/video/matrox/matroxfb_base.c
+++ b/drivers/video/matrox/matroxfb_base.c
@@ -2040,10 +2040,9 @@ static int matroxfb_probe(struct pci_dev
 		return -1;
 	}
 
-	minfo = kmalloc(sizeof(*minfo), GFP_KERNEL);
+	minfo = kzalloc(sizeof(*minfo), GFP_KERNEL);
 	if (!minfo)
 		return -1;
-	memset(minfo, 0, sizeof(*minfo));
 
 	minfo->pcidev = pdev;
 	minfo->dead = 0;
