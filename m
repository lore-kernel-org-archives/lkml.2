Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab1E1Oy4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 10:54:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62347 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab1E1Oyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 10:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=rWR9W6/ODan93s45XDYEaNtXpb4pflpse771YwnlxGNQ9xSlHqGYQ1ju3pSGySPqnX
         1S8ELAmP3Mdp/xsGXhiCeOZfeeK4e5wP1iCjur0cCH0cAwLxTfoRy8b+Hnh+ZDVpIFwg
         8uClYJuMCOR3I/ofTa1nmIjis9thcZX+3yQbk=
Message-ID: <4DE10B58.1010005@gmail.com>
Date: Sat, 28 May 2011 16:48:56 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: xiyou.wangcong@gmail.com, stevie.trujillo@gmail.com,
        kyungmin.park@samsung.com
Subject: [PATCH 2/2] ramoops: add new line to printks
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Add new line to each printk.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index bf5f9f6..6662c1b 100644
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

