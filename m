Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab0ILS5B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:57:01 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52144 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab0ILS46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:56:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lfw9FwLIJtvX9gVEZoEkM6sMtJQPblin+AMl/g6tT2m8rUhPu/FoPHw1C4y/aqMU0B
         esmUN+DETfz2oPaFpjglkJQKf53ILByR8zn4PNUNROoPGr7gRKEGsJOzcLa/Tjpw3V39
         7+RkUE2CvBAg83Rfrr27W0+6VHFyu0HWbSucQ=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jarod Wilson <jarod@redhat.com>,
        Manu Abraham <abraham.manu@gmail.com>, Scott Davilla <davilla@4pi.com>,
        Lars Lindley <lindley@coyote.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: crystalhd: fix signed bug
Date: Sun, 12 Sep 2010 22:56:51 +0400
Message-Id: <1284317813-4895-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

chd_dec_major is unsigned, so check chd_dec_major < 0 doesn't make sense.
Since it is used as signed, declare it as int.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/staging/crystalhd/crystalhd_lnx.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_lnx.h b/drivers/staging/crystalhd/crystalhd_lnx.h
index c951e43..a2b5a56 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.h
+++ b/drivers/staging/crystalhd/crystalhd_lnx.h
@@ -76,7 +76,7 @@ struct crystalhd_adp {
 	spinlock_t		lock;
 
 	/* API Related */
-	unsigned int		chd_dec_major;
+	int		chd_dec_major;
 	unsigned int		cfg_users;
 
 	struct crystalhd_ioctl_data	*idata_free_head;	/* ioctl data pool */
-- 
1.7.0.4

