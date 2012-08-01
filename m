Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab2HAEzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 00:55:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64111 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab2HAEy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 00:54:56 -0400
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: greg@kroah.com
Cc: swetland@google.com, linux-kernel@vger.kernel.org,
        Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 5/5] Fixes a potential bug in android/logger.c
Date: Wed,  1 Aug 2012 14:54:20 +1000
Message-Id: <1343796860-7025-6-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343796860-7025-1-git-send-email-cruzjbishop@gmail.com>
References: <1343796860-7025-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, when calling is_between(a, b, c), the calculation was wrong.
It counted C as between A and B if C was equal to B, but not A.

Example of this are:

is_between(1, 10, 10) = 1 (Expected: 0)
is_between(1, 10, 1) = 0 (Expected: 0)
is_between(20, 10, 10) = 1 (Expected: 0)

And so on and so forth.

Obviously, ten is not a number between one and ten - only two to eight are, so I made this patch :)

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 drivers/staging/android/logger.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 226d8b5..925df5c 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -298,11 +298,11 @@ static inline int is_between(size_t a, size_t b, size_t c)
 {
 	if (a < b) {
 		/* is c between a and b? */
-		if (a < c && c <= b)
+		if (a < c && c < b)
 			return 1;
 	} else {
 		/* is c outside of b through a? */
-		if (c <= b || a < c)
+		if (c < b || a < c)
 			return 1;
 	}
 
-- 
1.7.9.5

