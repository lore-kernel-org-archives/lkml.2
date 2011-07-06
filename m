Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab1GFSEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:04:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243Ab1GFSEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:04:30 -0400
Date: Wed, 6 Jul 2011 15:03:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv3 09/17] [media] nxt6000: i2c bus error should return
 -EIO
Message-ID: <20110706150359.58da172c@pedra>
In-Reply-To: <cover.1309974026.git.mchehab@redhat.com>
References: <cover.1309974026.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-EFAULT is used to indicate that there were a problem when copying
data from/to userspace. Don't mix it with I2C bus error (-EIO).

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/nxt6000.c b/drivers/media/dvb/frontends/nxt6000.c
index a763ec7..6599b8f 100644
--- a/drivers/media/dvb/frontends/nxt6000.c
+++ b/drivers/media/dvb/frontends/nxt6000.c
@@ -50,7 +50,7 @@ static int nxt6000_writereg(struct nxt6000_state* state, u8 reg, u8 data)
 	if ((ret = i2c_transfer(state->i2c, &msg, 1)) != 1)
 		dprintk("nxt6000: nxt6000_write error (reg: 0x%02X, data: 0x%02X, ret: %d)\n", reg, data, ret);
 
-	return (ret != 1) ? -EFAULT : 0;
+	return (ret != 1) ? -EIO : 0;
 }
 
 static u8 nxt6000_readreg(struct nxt6000_state* state, u8 reg)
-- 
1.7.1


