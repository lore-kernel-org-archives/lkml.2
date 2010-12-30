Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab0L3XUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 18:20:40 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27791 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab0L3XUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:20:39 -0500
Date: Fri, 31 Dec 2010 00:11:30 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-media@vger.kernel.org
cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATVH] media, dvb, IX2505V: Remember to free allocated memory in
 failure path (ix2505v_attach()).
Message-ID: <alpine.LNX.2.00.1012310008070.32595@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We may leak the storage allocated to 'state' in 
drivers/media/dvb/frontends/ix2505v.c::ix2505v_attach() on error.
This patch makes sure we free the allocated memory in the failure case.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 ix2505v.c |    1 +
 1 file changed, 1 insertion(+)

  Compile tested only.

diff --git a/drivers/media/dvb/frontends/ix2505v.c b/drivers/media/dvb/frontends/ix2505v.c
index 55f2eba..fcb173d 100644
--- a/drivers/media/dvb/frontends/ix2505v.c
+++ b/drivers/media/dvb/frontends/ix2505v.c
@@ -293,6 +293,7 @@ struct dvb_frontend *ix2505v_attach(struct dvb_frontend *fe,
 		ret = ix2505v_read_status_reg(state);
 
 		if (ret & 0x80) {
+			kfree(state);
 			deb_i2c("%s: No IX2505V found\n", __func__);
 			goto error;
 		}



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

