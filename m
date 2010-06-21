Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab0FUQP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 12:15:57 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46651 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab0FUQPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 12:15:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oagxi+5lOSV6Utej8XKxDtFak0eXEnjnZqraR5N75adx2V9aUxmY5HN7VimxBbtati
         iSgz86MGcIvBMVsE0Vebvl5mdq/rts/vw6zVf/euOnn7aXZ4K1qnnJRurK3Z57l9dnWn
         AVuNglFdLfTLJGBTy6+18eoUSvU8uPOjn/yA4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 8/8 v2]tuners:tuner-simple Fix warning: variable 'tun' set but not used
Date: Mon, 21 Jun 2010 09:15:47 -0700
Message-Id: <1277136947-2787-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend due to a whitespace issue I created by mistake.
The below patch fixes a warning message create by gcc 4.6.0
 
 CC [M]  drivers/media/common/tuners/tuner-simple.o
drivers/media/common/tuners/tuner-simple.c: In function 'simple_set_tv_freq':
drivers/media/common/tuners/tuner-simple.c:548:20: warning: variable 'tun' set but not used

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
 Reviewed-By: Mauro Carvalho Chehab <mchehab@redhat.com>

---
 drivers/media/common/tuners/tuner-simple.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-simple.c b/drivers/media/common/tuners/tuner-simple.c
index 8abbcc5..84900fa 100644
--- a/drivers/media/common/tuners/tuner-simple.c
+++ b/drivers/media/common/tuners/tuner-simple.c
@@ -545,14 +545,11 @@ static int simple_set_tv_freq(struct dvb_frontend *fe,
 	struct tuner_simple_priv *priv = fe->tuner_priv;
 	u8 config, cb;
 	u16 div;
-	struct tunertype *tun;
 	u8 buffer[4];
 	int rc, IFPCoff, i;
 	enum param_type desired_type;
 	struct tuner_params *t_params;
 
-	tun = priv->tun;
-
 	/* IFPCoff = Video Intermediate Frequency - Vif:
 		940  =16*58.75  NTSC/J (Japan)
 		732  =16*45.75  M/N STD
-- 
1.7.1.rc1.21.gf3bd6

