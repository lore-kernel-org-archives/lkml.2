Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab2IDMFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 08:05:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40440 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab2IDMF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 08:05:28 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] drivers/media/rc/redrat3.c: fix error return code
Date: Tue,  4 Sep 2012 14:05:05 +0200
Message-Id: <1346760305-13060-3-git-send-email-peter.senna@gmail.com>
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
 drivers/media/rc/redrat3.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 2878b0e..49731b1 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -1217,9 +1217,10 @@ static int __devinit redrat3_dev_probe(struct usb_interface *intf,
 	rr3->carrier = 38000;
 
 	rr3->rc = redrat3_init_rc_dev(rr3);
-	if (!rr3->rc)
+	if (!rr3->rc) {
+		retval = -ENOMEM;
 		goto error;
-
+	}
 	setup_timer(&rr3->rx_timeout, redrat3_rx_timeout, (unsigned long)rr3);
 
 	/* we can register the device now, as it is ready */

