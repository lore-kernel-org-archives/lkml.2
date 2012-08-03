Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab2HCFVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 01:21:22 -0400
Received: from science.horizon.com ([71.41.210.146]:14849 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751354Ab2HCFVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 01:21:13 -0400
From: George Spelvin <linux@horizon.com>
To: vda.linux@googlemail.com, mina86@mina86.com
Cc: hughd@google.com, linux-kernel@vger.kernel.org, linux@horizon.com
Subject: [PATCH 4/4] lib: vsprintf: Fix broken comments
Date: Fri,  3 Aug 2012 01:21:11 -0400
Message-Id: <1343971271-13355-4-git-send-email-linux@horizon.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1343971271-13355-1-git-send-email-linux@horizon.com>
References: <1343971271-13355-1-git-send-email-linux@horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Numbering the 8 potential digits 2 though 9 never did make a lot of sense.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 lib/vsprintf.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 3ca77b8..692e61b 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -182,19 +182,19 @@ char *put_dec_trunc8(char *buf, unsigned r)
 
 	if (r == 0)
 		return buf;
-	q      = (r * 0x199a) >> 16;
-	*buf++ = (r - 10 * q)  + '0'; /* 6 */
+	q      = (r * 0x199a) >> 16;	/* r <= 9999 */
+	*buf++ = (r - 10 * q)  + '0';
 	if (q == 0)
 		return buf;
-	r      = (q * 0xcd) >> 11;
-	*buf++ = (q - 10 * r)  + '0'; /* 7 */
+	r      = (q * 0xcd) >> 11;	/* q <= 999 */
+	*buf++ = (q - 10 * r)  + '0';
 	if (r == 0)
 		return buf;
-	q      = (r * 0xcd) >> 11;
-	*buf++ = (r - 10 * q) + '0'; /* 8 */
+	q      = (r * 0xcd) >> 11;	/* r <= 99 */
+	*buf++ = (r - 10 * q) + '0';
 	if (q == 0)
 		return buf;
-	*buf++ = q + '0'; /* 9 */
+	*buf++ = q + '0';		/* q <= 9 */
 	return buf;
 }
 
-- 
1.7.10.4

