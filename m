Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab0LINsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 08:48:35 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:57677 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab0LINsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 08:48:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=OE9Vg5jFFJ4S7lqcyT4dimgDHBYZYoFFBRycO1JWxaBXtld4D+RuTH0Go4gXt4oy+4
         nAjY4NlMcQHuIqfSCSvuIgz8uTKaizkcoiT2+OPtzF1x9tYfiMWDCAIxFdTYcxR0ALE+
         ACeq8aNv8dDodrTEFwJfpfj+SQEBgqLR3R7hA=
Date: Thu, 9 Dec 2010 16:48:20 +0300
From: Dan Carpenter <error27@gmail.com>
To: giometti@linux.it
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] c2port: class_create() returns an ERR_PTR
Message-ID: <20101209134819.GW10623@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>, giometti@linux.it,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

class_create() returns an ERR_PTR and it doesn't return a NULL.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/misc/c2port/core.c b/drivers/misc/c2port/core.c
index 19fc7c1..f428d86 100644
--- a/drivers/misc/c2port/core.c
+++ b/drivers/misc/c2port/core.c
@@ -984,9 +984,9 @@ static int __init c2port_init(void)
 		" - (C) 2007 Rodolfo Giometti\n");
 
 	c2port_class = class_create(THIS_MODULE, "c2port");
-	if (!c2port_class) {
+	if (IS_ERR(c2port_class)) {
 		printk(KERN_ERR "c2port: failed to allocate class\n");
-		return -ENOMEM;
+		return PTR_ERR(c2port_class);
 	}
 	c2port_class->dev_attrs = c2port_attrs;
 
