Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868Ab1CaGpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:45:38 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55432 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab1CaGpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:45:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pmuEXm0zuI162Ao76ZbOve2fZAch7Y5jUchfjRWozM3sufbUGplIsADlw9i/XazEsK
         y3wsNYaYIKRVOq/uVSZoDruyZSPvmQABc08WxeOxj6UF3BXEzsJcsGbCgNwsU1MQ8BIL
         6+PnEhGXpqdeGrLTn3xZ8/EYu4DT8cUYr56uY=
From: Pan Weiping <panweiping3@gmail.com>
Cc: Pan Weiping <panweiping3@gmail.com>,
        Boaz Harrosh <bharrosh@panasas.com> (maintainer:OSD LIBRARY and
	F...),
        Benny Halevy <bhalevy@panasas.com> (maintainer:OSD LIBRARY and F...),
        osd-dev@open-osd.org (open list:OSD LIBRARY and F...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/3] exofs:typo correction
Date: Thu, 31 Mar 2011 14:46:41 +0800
Message-Id: <1301554001-29133-1-git-send-email-panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use accumulated_osd_erry instead of acumulated_osd_err.
use accumulated_lin_err instead of acumulated_lin_err.

Signed-off-by: Pan Weiping <panweiping3@gmail.com>
---
 fs/exofs/ios.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/exofs/ios.c b/fs/exofs/ios.c
index f74a2ec..cf0858e 100644
--- a/fs/exofs/ios.c
+++ b/fs/exofs/ios.c
@@ -216,8 +216,8 @@ static void _clear_bio(struct bio *bio)
 
 int exofs_check_io(struct exofs_io_state *ios, u64 *resid)
 {
-	enum osd_err_priority acumulated_osd_err = 0;
-	int acumulated_lin_err = 0;
+	enum osd_err_priority accumulated_osd_erry = 0;
+	int accumulated_lin_err = 0;
 	int i;
 
 	for (i = 0; i < ios->numdevs; i++) {
@@ -243,21 +243,21 @@ int exofs_check_io(struct exofs_io_state *ios, u64 *resid)
 			continue; /* we recovered */
 		}
 
-		if (osi.osd_err_pri >= acumulated_osd_err) {
-			acumulated_osd_err = osi.osd_err_pri;
-			acumulated_lin_err = ret;
+		if (osi.osd_err_pri >= accumulated_osd_erry) {
+			accumulated_osd_erry = osi.osd_err_pri;
+			accumulated_lin_err = ret;
 		}
 	}
 
 	/* TODO: raid specific residual calculations */
 	if (resid) {
-		if (likely(!acumulated_lin_err))
+		if (likely(!accumulated_lin_err))
 			*resid = 0;
 		else
 			*resid = ios->length;
 	}
 
-	return acumulated_lin_err;
+	return accumulated_lin_err;
 }
 
 /*
-- 
1.7.4

