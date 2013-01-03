Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab3ACMUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:20:18 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33247 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3ACMUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:20:06 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-usb@vger.kernel.org
Subject: [PATCH -v2 14/26] uwb: rename random32() to prandom_u32()
Date: Thu,  3 Jan 2013 21:19:10 +0900
Message-Id: <1357215562-6288-15-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-usb@vger.kernel.org
---

No change from v1

 drivers/uwb/rsv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/uwb/rsv.c b/drivers/uwb/rsv.c
index 0b0d8bc..f4ae05f 100644
--- a/drivers/uwb/rsv.c
+++ b/drivers/uwb/rsv.c
@@ -231,7 +231,7 @@ void uwb_rsv_backoff_win_increment(struct uwb_rc *rc)
 		return;
 
 	bow->window <<= 1;
-	bow->n = random32() & (bow->window - 1);
+	bow->n = prandom_u32() & (bow->window - 1);
 	dev_dbg(dev, "new_window=%d, n=%d\n: ", bow->window, bow->n);
 
 	/* reset the timer associated variables */
@@ -557,7 +557,7 @@ int uwb_rsv_establish(struct uwb_rsv *rsv)
 	if (ret)
 		goto out;
 
-	rsv->tiebreaker = random32() & 1;
+	rsv->tiebreaker = prandom_u32() & 1;
 	/* get available mas bitmap */
 	uwb_drp_available(rc, &available);
 
-- 
1.7.11.7

