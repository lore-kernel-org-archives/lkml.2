Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab0E0MdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 08:33:09 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:48506 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902Ab0E0MdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 08:33:05 -0400
Date: Thu, 27 May 2010 14:33:00 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Jean-Paul Roubelat <jpr@f6fbb.org>, linux-hams@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/11] drivers/net/hamradio: Eliminate a NULL pointer dereference
Message-ID: <Pine.LNX.4.64.1005271432450.5422@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

At the point of the print, dev is NULL.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E,E1;
identifier f;
statement S1,S2,S3;
@@

if ((E == NULL && ...) || ...)
{
  ... when != if (...) S1 else S2
      when != E = E1
* E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/hamradio/yam.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 694132e..4e7d1d0 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -1151,8 +1151,7 @@ static int __init yam_init_driver(void)
 		dev = alloc_netdev(sizeof(struct yam_port), name,
 				   yam_setup);
 		if (!dev) {
-			printk(KERN_ERR "yam: cannot allocate net device %s\n",
-			       dev->name);
+			pr_err("yam: cannot allocate net device\n");
 			err = -ENOMEM;
 			goto error;
 		}
