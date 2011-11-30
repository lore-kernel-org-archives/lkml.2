Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1K3NQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:16:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab1K3NQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:16:25 -0500
Message-ID: <4ED62CA0.2080600@redhat.com>
Date: Wed, 30 Nov 2011 14:16:16 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Nitin Gupta <ngupta@vflare.org>, Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] Staging: zram: Add a missing GFP_KERNEL specifier in
 zram_init_device()
References: <4ED62C38.1020106@redhat.com>
In-Reply-To: <4ED62C38.1020106@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The allocation of zram->compress_buffer is misssing a GFP_* specifier.
This is equivalent to GFP_NOWAIT but it is more likely a omission.
Since the allocation just above it uses GFP_KERNEL, there is no reason
to use GFP_NOWAIT here. Therefore, add GFP_KERNEL.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 zram_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 34f4b96..a263a1b 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -665,7 +665,8 @@ int zram_init_device(struct zram *zram)
 		goto fail_no_table;
 	}
 
-	zram->compress_buffer = (void *)__get_free_pages(__GFP_ZERO, 1);
+	zram->compress_buffer =
+		(void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
 	if (!zram->compress_buffer) {
 		pr_err("Error allocating compressor buffer space\n");
 		ret = -ENOMEM;

