Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab1FHQWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 12:22:46 -0400
Received: from mail.perches.com ([173.55.12.10]:2629 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab1FHQWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 12:22:45 -0400
Subject: Re: [PATCH 2/2] ramoops: add new line to printks
From: Joe Perches <joe@perches.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xiyou.wangcong@gmail.com,
        stevie.trujillo@gmail.com, kyungmin.park@samsung.com
In-Reply-To: <4DEE5737.9060404@gmail.com>
References: <4DE10B58.1010005@gmail.com>  <4DEE5737.9060404@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 09:22:44 -0700
Message-ID: <1307550164.16453.2.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 18:52 +0200, Marco Stornelli wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
> Add new line to each printk.

Perhaps use pr_<level> and pr_fmt instead?
---
 drivers/char/ramoops.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index 1a9f5f6..1283180 100644
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
@@ -112,14 +114,14 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	}
 
 	if (!mem_size) {
-		printk(KERN_ERR "ramoops: invalid size specification");
+		pr_err("invalid size specification\n");
 		goto fail3;
 	}
 
 	rounddown_pow_of_two(mem_size);
 
 	if (mem_size < RECORD_SIZE) {
-		printk(KERN_ERR "ramoops: size too small");
+		pr_err("size too small\n");
 		goto fail3;
 	}
 
@@ -129,21 +131,21 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	cxt->phys_addr = mem_address;
 
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
 
@@ -162,7 +164,7 @@ static int __exit ramoops_remove(struct platform_device *pdev)
 	struct ramoops_context *cxt = &oops_cxt;
 
 	if (kmsg_dump_unregister(&cxt->dump) < 0)
-		printk(KERN_WARNING "ramoops: could not unregister kmsg_dumper");
+		pr_warn("could not unregister kmsg_dumper\n");
 
 	iounmap(cxt->virt_addr);
 	release_mem_region(cxt->phys_addr, cxt->size);


