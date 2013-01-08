Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab3AHVha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:37:30 -0500
Received: from www84.your-server.de ([213.133.104.84]:50556 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab3AHVh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:37:27 -0500
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: stefani@seibold.net
Subject: [PATCH 2/2] fix kfifo_alloc() and kfifo_init()
Date: Tue,  8 Jan 2013 22:36:24 +0100
Message-Id: <1357680984-23007-6-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1357680984-23007-1-git-send-email-stefani@seibold.net>
References: <1357680984-23007-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This patch fix the kfifo_alloc() and kfifo_init() to alloc at least the
requested number of elements. Since the kfifo operates on power of 2 the
request size will be rounded up to the next power of two.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 lib/kfifo.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/kfifo.c b/lib/kfifo.c
index 59dcf5b..7b7f830 100644
--- a/lib/kfifo.c
+++ b/lib/kfifo.c
@@ -42,8 +42,7 @@ int __kfifo_alloc(struct __kfifo *fifo, unsigned int size,
 	 * round down to the next power of 2, since our 'let the indices
 	 * wrap' technique works only in this case.
 	 */
-	if (!is_power_of_2(size))
-		size = rounddown_pow_of_two(size);
+	size = roundup_pow_of_two(size);
 
 	fifo->in = 0;
 	fifo->out = 0;
@@ -83,8 +82,7 @@ int __kfifo_init(struct __kfifo *fifo, void *buffer,
 {
 	size /= esize;
 
-	if (!is_power_of_2(size))
-		size = rounddown_pow_of_two(size);
+	size = roundup_pow_of_two(size);
 
 	fifo->in = 0;
 	fifo->out = 0;
-- 
1.8.0.2

