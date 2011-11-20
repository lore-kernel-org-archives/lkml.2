Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab1KTHrj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 02:47:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62448 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1KTHrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 02:47:37 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Lasse Collin <lasse.collin@tukaani.org>
Subject: [PATCH] lib: fix potential memory free failure on unlzo()
Date: Sun, 20 Nov 2011 16:47:31 +0900
Message-Id: <1321775251-3274-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in_buf is dynamically allocated if @input is not given,
and adjusted as processing data on every loop. However
if block metadata is corrupted it will bail out the loop
in the middle, thus in_buf will point out wrong memory.
Fix it by freeing in_buf_save instead.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Lasse Collin <lasse.collin@tukaani.org>
---
 lib/decompress_unlzo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/decompress_unlzo.c b/lib/decompress_unlzo.c
index 5a7a2adf4c4c..4531294fa62f 100644
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
1.7.6

