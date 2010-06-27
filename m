Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab0F0GsL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 02:48:11 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:45822 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab0F0Grt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 02:47:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=papwmRTs+uIrwvsXP3Mt81ZrF6H5J4/Tx7J6UK0ODsm5zbR9KpQzLOgYf85pSR+HDA
         KDjHioIOTElsdHJgUovlC4dvQrJHdTGeWmXTHXzGMolS6VUpNQZOf1b6tBKOrsDoltsb
         CbW6ionw2f6IBI60hCqclpj/NI2LQW2NXEOkM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, sds@tycho.nsa.gov, lenb@kernel.org,
       linux-bluetooth@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 4/5]block:cryptoloop Fix warning: variable 'cipher' set but not used
Date: Sat, 26 Jun 2010 23:47:25 -0700
Message-Id: <1277621246-10960-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1277621246-10960-1-git-send-email-justinmattock@gmail.com>
References: <1277621246-10960-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Im getting this when compiling on gcc 4.6.0
  CC [M]  drivers/block/cryptoloop.o
drivers/block/cryptoloop.c: In function 'cryptoloop_init':
drivers/block/cryptoloop.c:46:8: warning: variable 'cipher' set but not used
The below fixes it for me. Please have a look and let me know.

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/block/cryptoloop.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cryptoloop.c b/drivers/block/cryptoloop.c
index 8b6bb76..fb8a6fd 100644
--- a/drivers/block/cryptoloop.c
+++ b/drivers/block/cryptoloop.c
@@ -43,7 +43,6 @@ cryptoloop_init(struct loop_device *lo, const struct loop_info64 *info)
 	int cipher_len;
 	int mode_len;
 	char cms[LO_NAME_SIZE];			/* cipher-mode string */
-	char *cipher;
 	char *mode;
 	char *cmsp = cms;			/* c-m string pointer */
 	struct crypto_blkcipher *tfm;
@@ -56,7 +55,6 @@ cryptoloop_init(struct loop_device *lo, const struct loop_info64 *info)
 	strncpy(cms, info->lo_crypt_name, LO_NAME_SIZE);
 	cms[LO_NAME_SIZE - 1] = 0;
 
-	cipher = cmsp;
 	cipher_len = strcspn(cmsp, "-");
 
 	mode = cmsp + cipher_len;
-- 
1.7.1.rc1.21.gf3bd6

