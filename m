Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1FHTxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:53:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56313 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab1FHTxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:53:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UGixEh5XkJz6WRBIsdex0EKnQrzftstvp1WAZog0tA6/e+vNiagzrmzexf5CUyGEUC
         QUsZuJ8voXEyt2n3Dt2j17qc7Lje9bLC88S2/sXQU1bzqPKuMgd0aAofXhCOEiDd+qsu
         BDNWCA8fa68yEhiq6JCfeq3RWHJ4VuSN9RfvU=
Message-ID: <4DEFD1D2.5030808@gmail.com>
Date: Wed, 08 Jun 2011 21:47:30 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Joe Perches <joe@perches.com>, xiyou.wangcong@gmail.com,
        stevie.trujillo@gmail.com, kyungmin.park@samsung.com
Subject: [PATCH 2/2 v3] ramoops: add new line to each print
References: <4DE10B58.1010005@gmail.com>  <4DEE5737.9060404@gmail.com> <1307550164.16453.2.camel@Joe-Laptop> <4DEFC885.2080202@gmail.com>
In-Reply-To: <4DEFC885.2080202@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Add new line to each print.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
CC: Kyungmin Park <kyungmin.park@samsung.com>
CC: Américo Wang <xiyou.wangcong@gmail.com>
CC: Joe Perches <joe@perches.com>
Reported-by: Stevie Trujillo <stevie.trujillo@gmail.com>
---
ChangeLog:
- v3: removed double line from pr_info
- v2: used pr_<level> instead of printk
- v1: initial draft

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index df092e1..5b4a5e1 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/kmsg_dump.h>
@@ -111,14 +113,14 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	int err = -EINVAL;
 
 	if (!pdata->mem_size) {
-		printk(KERN_ERR "ramoops: invalid size specification");
+		pr_err("invalid size specification\n");
 		goto fail3;
 	}
 
 	rounddown_pow_of_two(pdata->mem_size);
 
 	if (pdata->mem_size < RECORD_SIZE) {
-		printk(KERN_ERR "ramoops: size too small");
+		pr_err("size too small\n");
 		goto fail3;
 	}
 
@@ -128,21 +130,21 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	cxt->phys_addr = pdata->mem_address;
 
 	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
-		printk(KERN_ERR "ramoops: request mem region failed");
+		pr_err("request mem region failed\n");
 		err = -EINVAL;
 		goto fail3;
 	}
 
 	cxt->virt_addr = ioremap(cxt->phys_addr,  cxt->size);
 	if (!cxt->virt_addr) {
-		printk(KERN_ERR "ramoops: ioremap failed");
+		pr_err("ioremap failed\n");
 		goto fail2;
 	}
 
 	cxt->dump.dump = ramoops_do_dump;
 	err = kmsg_dump_register(&cxt->dump);
 	if (err) {
-		printk(KERN_ERR "ramoops: registering kmsg dumper failed");
+		pr_err("registering kmsg dumper failed\n");
 		goto fail1;
 	}
 
@@ -161,7 +163,7 @@ static int __exit ramoops_remove(struct platform_device *pdev)
 	struct ramoops_context *cxt = &oops_cxt;
 
 	if (kmsg_dump_unregister(&cxt->dump) < 0)
-		printk(KERN_WARNING "ramoops: could not unregister kmsg_dumper");
+		pr_warn("could not unregister kmsg_dumper\n");
 
 	iounmap(cxt->virt_addr);
 	release_mem_region(cxt->phys_addr, cxt->size);
@@ -186,6 +188,7 @@ static int __init ramoops_init(void)
 		 * if we didn't find a platform device, we use module parameters
 		 * building platform data on the fly.
 		 */
+		pr_info("platform device not found, using module parameters\n");
 		dummy_data = kzalloc(sizeof(struct ramoops_platform_data),
 				     GFP_KERNEL);
 		if (!dummy_data)
