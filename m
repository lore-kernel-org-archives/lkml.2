Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab1CPC2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 22:28:11 -0400
Received: from science.horizon.com ([71.41.210.146]:44009 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751102Ab1CPC2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:28:07 -0400
Message-ID: <20110316022804.27679.qmail@science.horizon.com>
MBOX-Line: From b5bf6b1aabcedb5b783f8961bdfed82f032d3b5d Mon Sep 17 00:00:00 2001
From: George Spelvin <linux@horizon.com>
Date: Sun, 13 Mar 2011 20:20:44 -0400
Subject: [PATCH 1/8] drivers/random: Cache align ip_random better
To: penberg@cs.helsinki.fi, herbert@gondor.hengli.com.au, mpm@selenic.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cache aligning the secret[] buffer makes copying from it infinitesimally
more efficient.
---
 drivers/char/random.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 72a4fcb..4bcc4f2 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1417,8 +1417,8 @@ static __u32 twothirdsMD4Transform(__u32 const buf[4], __u32 const in[12])
 #define HASH_MASK ((1 << HASH_BITS) - 1)
 
 static struct keydata {
-	__u32 count; /* already shifted to the final position */
 	__u32 secret[12];
+	__u32 count; /* already shifted to the final position */
 } ____cacheline_aligned ip_keydata[2];
 
 static unsigned int ip_cnt;
-- 
1.7.4.1

