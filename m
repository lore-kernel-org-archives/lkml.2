Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab2LHF7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 00:59:39 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36117 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2LHF7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 00:59:38 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH] lib/parser.c: Fix up comments for valid return values from match_number
Date: Sat,  8 Dec 2012 14:59:27 +0900
Message-Id: <1354946367-7849-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Since, match_number as valid return values as -ENOMEM, -EINVAL and
-ERANGE. So, for all the functions calling match_number, the return
value should include these values. Fix up the comments to reflect
the correct values.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 lib/parser.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/parser.c b/lib/parser.c
index 52cfa69..807b2aa 100644
--- a/lib/parser.c
+++ b/lib/parser.c
@@ -157,7 +157,7 @@ static int match_number(substring_t *s, int *result, int base)
  *
  * Description: Attempts to parse the &substring_t @s as a decimal integer. On
  * success, sets @result to the integer represented by the string and returns 0.
- * Returns either -ENOMEM or -EINVAL on failure.
+ * Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
  */
 int match_int(substring_t *s, int *result)
 {
@@ -171,7 +171,7 @@ int match_int(substring_t *s, int *result)
  *
  * Description: Attempts to parse the &substring_t @s as an octal integer. On
  * success, sets @result to the integer represented by the string and returns
- * 0. Returns either -ENOMEM or -EINVAL on failure.
+ * 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
  */
 int match_octal(substring_t *s, int *result)
 {
@@ -185,7 +185,7 @@ int match_octal(substring_t *s, int *result)
  *
  * Description: Attempts to parse the &substring_t @s as a hexadecimal integer.
  * On success, sets @result to the integer represented by the string and
- * returns 0. Returns either -ENOMEM or -EINVAL on failure.
+ * returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
  */
 int match_hex(substring_t *s, int *result)
 {
-- 
1.7.9.5

