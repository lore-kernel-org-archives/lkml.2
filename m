Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab1EPOTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:19:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39691 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab1EPOTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:19:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=D/JuN0d7Zt8ip/2KxV9dBjq/80C0K6hNsfSX2rtU7XlZePVDAIGYy3l/qk5qUgk1Xm
         hcFf14k6KCtlo7AKsCl0mhbqGwaoBNs3BfZWyrt9Q12+NrZY5vCcbR9AxOu7LY/Y9r0A
         tZkA24pk5/fa1FHqv4zJLbPlNMLjiQlx7G/qg=
Subject: [PATCH RESEND] mfd: Fix off-by-one value range checking for
 tps65910_i2c_write
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Graeme Gregory <gg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 22:19:01 +0800
Message-ID: <1305555542.2337.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If bytes == (TPS65910_MAX_REGISTER + 1), we have a buffer overflow when
doing memcpy(&msg[1], src, bytes).

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
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



