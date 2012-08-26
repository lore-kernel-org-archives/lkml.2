Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab2HZQP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 12:15:59 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:18738 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750908Ab2HZQP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 12:15:58 -0400
X-IronPort-AV: E=Sophos;i="4.80,316,1344204000"; 
   d="scan'208";a="170851380"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, crope@iki.fi, awalls@md.metrocast.net
Subject: [PATCH] drivers/media/dvb-frontends/rtl2830.c: correct double assignment
Date: Sun, 26 Aug 2012 18:15:51 +0200
Message-Id: <1345997751-340-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The double assignment is meant to be a bit-or to combine two values.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/dvb-frontends/rtl2830.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 8fa8b08..b6ab858 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -254,7 +254,7 @@ static int rtl2830_init(struct dvb_frontend *fe)
 		goto err;
 
 	buf[0] = tmp << 6;
-	buf[0] = (if_ctl >> 16) & 0x3f;
+	buf[0] |= (if_ctl >> 16) & 0x3f;
 	buf[1] = (if_ctl >>  8) & 0xff;
 	buf[2] = (if_ctl >>  0) & 0xff;
 

