Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab1KQV3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 16:29:33 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32940 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab1KQV3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 16:29:32 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lasse Collin <lasse.collin@tukaani.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] unlzo: Fix input buffer free
Date: Thu, 17 Nov 2011 22:29:20 +0100
Message-Id: <1321565360-28111-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.7.1
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unlzo modifies the pointer to in_buf, so we have to free the
original buffer, not the modified pointer. This only happens
when a fill function is passed, a case which is currently unused
in the kernel.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 lib/decompress_unlzo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/decompress_unlzo.c b/lib/decompress_unlzo.c
index 5a7a2ad..4531294 100644
--- a/lib/decompress_unlzo.c
+++ b/lib/decompress_unlzo.c
@@ -279,7 +279,7 @@ STATIC inline int INIT unlzo(u8 *input, int in_len,
 	ret = 0;
 exit_2:
 	if (!input)
-		free(in_buf);
+		free(in_buf_save);
 exit_1:
 	if (!output)
 		free(out_buf);
-- 
1.7.7.1

