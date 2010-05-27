Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178Ab0E0D0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 23:26:38 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36491 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932807Ab0E0D0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 23:26:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DqXR7CoOXvNUxitioAQZR7BAwQtadlrMFjuS98b+u8fKbKkEeRTlo9/WIW6mAL7mNF
         /wkTP/XpWkW67zV7NnN03Ey0E0PvKvX1n8yBwaknPfHA1hhcqM3bd4STF3r2Pv/8JYeG
         R62XDR7YIM6mpHzEeamuu4CFlJ9+Udy+9mlYI=
From: Scott Kidder <scott.kidder11@gmail.com>
To: jarod@redhat.com, adraham.manu@gmail.com, davilla@4pi.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Scott Kidder <scott.kidder11@gmail.com>
Subject: [PATCH 2/2] Staging: crystalhd: removed kfree(NULL) checks
Date: Wed, 26 May 2010 23:38:45 -0500
Message-Id: <1274935125-8825-1-git-send-email-scott.kidder11@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed kfree(NULL checks) that were not necessary

Signed-off-by: Scott Kidder <scott.kidder11@gmail.com>
---
 drivers/staging/crystalhd/crystalhd_lnx.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index a4ec891..9d2805a 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -152,10 +152,8 @@ static int chd_dec_fetch_cdata(struct crystalhd_adp *adp, struct crystalhd_ioctl
 	if (rc) {
 		BCMLOG_ERR("failed to pull add_cdata sz:%x ua_off:%x\n",
 			   io->add_cdata_sz, (unsigned int)ua_off);
-		if (io->add_cdata) {
-			kfree(io->add_cdata);
-			io->add_cdata = NULL;
-		}
+		kfree(io->add_cdata);
+		io->add_cdata = NULL;
 		return -ENODATA;
 	}

@@ -435,8 +433,7 @@ static void __devexit chd_dec_release_chdev(struct crystalhd_adp *adp)
 	/* Clear iodata pool.. */
 	do {
 		temp = chd_dec_alloc_iodata(adp, 0);
-		if (temp)
-			kfree(temp);
+		kfree(temp);
 	} while (temp);

 	crystalhd_delete_elem_pool(adp);
--
1.7.1

