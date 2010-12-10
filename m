Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab0LJMiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 07:38:46 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38986 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab0LJMio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 07:38:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=uFMxlUgtWlvf5kbdKKj5czzar/iPLZfKjknisTQBUICiBAJVxy2KKCjv5nL5VAp4WO
         d4iXvMN+j56YcoT9jqSXm244+bN2K1ix80A62GFIXLPbFtzf16/9ADNWY0G7KSsc1wQ8
         mfhwPZEO8dXt4lf7yMe7jjHVzMpAYGo8Q1Evc=
Date: Fri, 10 Dec 2010 15:38:30 +0300
From: Dan Carpenter <error27@gmail.com>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] pps: class_create() returns an ERR_PTR
Message-ID: <20101210123830.GA10623@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

class_create() returns an ERR_PTR and it doesn't return NULL.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index ca5183b..ef88108 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -285,9 +285,9 @@ static int __init pps_init(void)
 	int err;
 
 	pps_class = class_create(THIS_MODULE, "pps");
-	if (!pps_class) {
+	if (IS_ERR(pps_class)) {
 		printk(KERN_ERR "pps: failed to allocate class\n");
-		return -ENOMEM;
+		return PTR_ERR(pps_class);
 	}
 	pps_class->dev_attrs = pps_attrs;
 
