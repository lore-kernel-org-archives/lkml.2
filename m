Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab1FGQ6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 12:58:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52954 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228Ab1FGQ6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:58:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=u6dsTmnfntlfO9mvbRyhZ9NpYRI0EuZvtCff+Cu5Jb8KH+7rdg+vFPprVUHD0pVNZC
         YV7KpDwhfMhxCrVCaTlGDzh+RuabztUJXfoF14i2LkpCMDtuPWBbznS6t1d1rF/PZb1k
         mw7zshfhVTexKHtpg5MWmX5Sv3P2EbPvhLrxk=
Message-ID: <4DEE5737.9060404@gmail.com>
Date: Tue, 07 Jun 2011 18:52:07 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: xiyou.wangcong@gmail.com, stevie.trujillo@gmail.com,
        kyungmin.park@samsung.com
Subject: [PATCH 2/2] ramoops: add new line to printks
References: <4DE10B58.1010005@gmail.com>
In-Reply-To: <4DE10B58.1010005@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Add new line to each printk.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
CC: Kyungmin Park <kyungmin.park@samsung.com>
CC: Américo Wang <xiyou.wangcong@gmail.com>
Reported-by: Stevie Trujillo <stevie.trujillo@gmail.com>
---
diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index df092e1..20e9d3e 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -111,14 +111,14 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	int err = -EINVAL;
 
 	if (!pdata->mem_size) {
-		printk(KERN_ERR "ramoops: invalid size specification");
+		printk(KERN_ERR "ramoops: invalid size specification\n");
 		goto fail3;
 	}
 
 	rounddown_pow_of_two(pdata->mem_size);
 
 	if (pdata->mem_size < RECORD_SIZE) {
-		printk(KERN_ERR "ramoops: size too small");
+		printk(KERN_ERR "ramoops: size too small\n");
 		goto fail3;
 	}
 
@@ -128,21 +128,21 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	cxt->phys_addr = pdata->mem_address;
 
 	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
-		printk(KERN_ERR "ramoops: request mem region failed");
+		printk(KERN_ERR "ramoops: request mem region failed\n");
 		err = -EINVAL;
 		goto fail3;
 	}
 
 	cxt->virt_addr = ioremap(cxt->phys_addr,  cxt->size);
 	if (!cxt->virt_addr) {
-		printk(KERN_ERR "ramoops: ioremap failed");
+		printk(KERN_ERR "ramoops: ioremap failed\n");
 		goto fail2;
 	}
 
 	cxt->dump.dump = ramoops_do_dump;
 	err = kmsg_dump_register(&cxt->dump);
 	if (err) {
-		printk(KERN_ERR "ramoops: registering kmsg dumper failed");
+		printk(KERN_ERR "ramoops: registering kmsg dumper failed\n");
 		goto fail1;
 	}
 
@@ -161,7 +161,7 @@ static int __exit ramoops_remove(struct platform_device *pdev)
 	struct ramoops_context *cxt = &oops_cxt;
 
 	if (kmsg_dump_unregister(&cxt->dump) < 0)
-		printk(KERN_WARNING "ramoops: could not unregister kmsg_dumper");
+		printk(KERN_WARNING "ramoops: could not unregister kmsg_dumper\n");
 
 	iounmap(cxt->virt_addr);
 	release_mem_region(cxt->phys_addr, cxt->size);
