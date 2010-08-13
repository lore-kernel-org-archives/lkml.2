Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062Ab0HMUmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 16:42:35 -0400
Received: from www84.your-server.de ([213.133.104.84]:59849 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab0HMUmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 16:42:32 -0400
Subject: Re: [PATCH 2/3] kfifo: fix a memory leak in dma example
From: Stefani Seibold <stefani@seibold.net>
To: Andrea Righi <arighi@develer.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1281729545-1663-2-git-send-email-arighi@develer.com>
References: <1281729545-1663-1-git-send-email-arighi@develer.com>
	 <1281729545-1663-2-git-send-email-arighi@develer.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 13 Aug 2010 22:42:32 +0200
Message-ID: <1281732152.12228.1.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use a dynamically allocated kfifo in the dma example, so we need to
free it when unloading the module.

Signed-off-by: Andrea Righi <arighi@develer.com>
Acked-by: Stefani Seibold <stefani@seibold.net>
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


