Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab0ILS5d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:57:33 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41655 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab0ILS53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:57:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Pv3fuKR2hsm2IYR5NoQ83Xi4oBhfUNpg2yF/Yf1ESqe5HtJqztH+EZZL8ga+NfhY0u
         AMAbVAQHAL/NroeqQetcX9jK5CJlJ1/8WetuZ9Ff+ab528NG7gcZVxAmI5v+xWv///Lr
         MvDiwEpJJx5nf3dWJQQtejmi5a0Uc9kFypd9I=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gregory Bean <gbean@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: sx150x: fix error code value
Date: Sun, 12 Sep 2010 22:57:24 +0400
Message-Id: <1284317845-5181-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return code of sx150x_get_io() is propagated as error code,
so it should look like standard code.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/gpio/sx150x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/sx150x.c b/drivers/gpio/sx150x.c
index b42f42c..b0eed89 100644
--- a/drivers/gpio/sx150x.c
+++ b/drivers/gpio/sx150x.c
@@ -179,7 +179,7 @@ static int sx150x_get_io(struct sx150x_chip *chip, unsigned offset)
 	sx150x_find_cfg(offset, 1, &reg, &mask, &shift);
 	err = sx150x_i2c_read(chip->client, reg, &data);
 	if (err >= 0)
-		err = (data & mask) != 0 ? 1 : 0;
+		err = (data & mask) != 0 ? -EIO : 0;
 
 	return err;
 }
-- 
1.7.0.4

