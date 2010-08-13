Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab0HMT7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 15:59:20 -0400
Received: from trinity.develer.com ([83.149.158.210]:60559 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab0HMT7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 15:59:13 -0400
From: Andrea Righi <arighi@develer.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] kfifo: fix a memory leak in dma example
Date: Fri, 13 Aug 2010 21:59:04 +0200
Message-Id: <1281729545-1663-2-git-send-email-arighi@develer.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281729545-1663-1-git-send-email-arighi@develer.com>
References: <1281729545-1663-1-git-send-email-arighi@develer.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use a dynamically allocated kfifo in the dma example, so we need to
free it when unloading the module.

Signed-off-by: Andrea Righi <arighi@develer.com>
---
 samples/kfifo/dma-example.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/samples/kfifo/dma-example.c b/samples/kfifo/dma-example.c
index 03433ca..3682278 100644
--- a/samples/kfifo/dma-example.c
+++ b/samples/kfifo/dma-example.c
@@ -105,9 +105,7 @@ static int __init example_init(void)
 
 static void __exit example_exit(void)
 {
-#ifdef DYNAMIC
-	kfifo_free(&test);
-#endif
+	kfifo_free(&fifo);
 }
 
 module_init(example_init);
-- 
1.7.0.4

