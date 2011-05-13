Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab1EMJOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 05:14:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62673 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932983Ab1EMJOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 05:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=lwDq+QGN6JjislWmKZMaQEUq/XMQRXJ3w37lI5R3aVbr7xQ+uzNgwnf9xeO/+P8K12
         KMysPIDKJUhIS5M7Uj9enRLAR5M3P3t/NY8EIxx9jVN4du0Wtf3v6xWrZ1xZNEPt9O8T
         Ng0O2eDeiSNGJdiGiQSjWjSIr4sALv3Rk8NDc=
Subject: [PATCH] mfd: Fix off-by-one value range checking for
 tps65910_i2c_write
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Graeme Gregory <gg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 17:13:57 +0800
Message-ID: <1305278037.2713.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If bytes == (TPS65910_MAX_REGISTER + 1), we have a buffer overflow when
doing memcpy(&msg[1], src, bytes).

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/tps65910.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index bf649cf..e318248 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -71,7 +71,7 @@ static int tps65910_i2c_write(struct tps65910 *tps65910, u8 reg,
 	u8 msg[TPS65910_MAX_REGISTER + 1];
 	int ret;
 
-	if (bytes > (TPS65910_MAX_REGISTER + 1))
+	if (bytes > TPS65910_MAX_REGISTER)
 		return -EINVAL;
 
 	msg[0] = reg;
-- 
1.7.1



