Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab0FNU2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:28:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52855 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745Ab0FNU04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:26:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=balXRRKzb2RoRnlc+ZIqG18EC6+Ie4O92chpRmZuqk8qmcGRbqQVrEnv8BPvh+7Agd
         pnQp1W01sO39aFTsNI07NlDQeTOxiSIUzyzdTggY7ThyFgCaaR1H9mqbhO8TcP4K0G1c
         eFl7bGhztRvBMXNfNYqb3IJEj3t9qeCjl9F7U=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
       clemens@ladisch.de, debora@linux.vnet.ibm.com,
       dri-devel@lists.freedesktop.org, linux-i2c@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 4/8]drivers:tmp.c Fix warning: variable 'rc' set but not used
Date: Mon, 14 Jun 2010 13:26:44 -0700
Message-Id: <1276547208-26569-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Im getting this warning when compiling:
 CC      drivers/char/tpm/tpm.o
drivers/char/tpm/tpm.c: In function 'tpm_gen_interrupt':
drivers/char/tpm/tpm.c:508:10: warning: variable 'rc' set but not used

The below patch gets rid of the warning,
but I'm not sure if it's the best solution.

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/char/tpm/tpm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 05ad4a1..3d685dc 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -514,6 +514,8 @@ void tpm_gen_interrupt(struct tpm_chip *chip)
 
 	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
 			"attempting to determine the timeouts");
+	if (!rc)
+		rc = 0;
 }
 EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
 
-- 
1.7.1.rc1.21.gf3bd6

