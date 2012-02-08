Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab2BHJ0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 04:26:54 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:36455 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab2BHJ0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 04:26:52 -0500
Date: Wed, 8 Feb 2012 12:26:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-kernel@vger.kernel.org, Rodolfo Giometti <giometti@linux.it>
Cc: kernel-janitors@vger.kernel.org
Subject: [patch] c2port: class_create() returns an ERR_PTR
Message-ID: <20120208092640.GE6554@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F323FD9.007E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

class_create() doesn't return a NULL, it only returns ERR_PTRs.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

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
 
