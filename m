Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab1CPC2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 22:28:17 -0400
Received: from science.horizon.com ([71.41.210.146]:44024 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751113Ab1CPC2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:28:07 -0400
Message-ID: <20110316022804.27692.qmail@science.horizon.com>
MBOX-Line: From 9d41b0d9ef0c146072d573fd1f3e60e21eb4e66e Mon Sep 17 00:00:00 2001
From: George Spelvin <linux@horizon.com>
Date: Mon, 14 Mar 2011 12:46:32 -0400
Subject: [PATCH 3/8] drivers/char/random: make get_random_int_hash a structure
To: penberg@cs.helsinki.fi, herbert@gondor.hengli.com.au, mpm@selenic.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'll need to add some fields to it in later work.
---
 drivers/char/random.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index fdbf7b6..113508e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1624,7 +1624,10 @@ EXPORT_SYMBOL(secure_dccp_sequence_number);
  * value is not strongly cryptographically secure, but for several uses the
  * cost of depleting entropy is too high.
  */
-DEFINE_PER_CPU(__u32 [4], get_random_int_hash);
+struct cpu_random {
+	u32 hash[4];
+};
+DEFINE_PER_CPU(struct cpu_random, get_random_int_data);
 static u32 __get_random_int(u32 *hash)
 {
 	struct keydata const *keyptr = get_keyptr();
@@ -1640,10 +1643,10 @@ static u32 __get_random_int(u32 *hash)
 
 unsigned int get_random_int(void)
 {
-	u32 *hash = get_cpu_var(get_random_int_hash);
-	u32 ret = __get_random_int(hash);
+	struct cpu_random *r = &get_cpu_var(get_random_int_data);
+	u32 ret = __get_random_int(r->hash);
 
-	put_cpu_var(get_random_int_hash);
+	put_cpu_var(r);
 	return ret;
 }
 
-- 
1.7.4.1

