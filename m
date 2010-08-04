Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab0HDQd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:33:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33280 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab0HDQd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:33:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=ZftEBjZUy2QaT24tfqH78oAqVxKEbbOxbRyzq1r+X/dp5drN6Epov92lPnRPTpRwEl
         70Sd24GoQk6b82YCBIKMWTjmMlL16J69uH+oLn3GaEuR/fTU3AJPaen7im0EiHC/tC+9
         JzwLlKjPrmdUmChmxjz3ivpOTcJn7CDZS4GIw=
Date: Wed, 4 Aug 2010 18:33:19 +0200
From: Dan Carpenter <error27@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [patch] rocket: release_region or error path
Message-ID: <20100804163319.GC9031@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a release_region() missing on the error path.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 0e29a23..258bc35 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -2334,7 +2334,7 @@ static int __init rp_init(void)
 	ret = tty_register_driver(rocket_driver);
 	if (ret < 0) {
 		printk(KERN_ERR "Couldn't install tty RocketPort driver\n");
-		goto err_tty;
+		goto err_controller;
 	}
 
 #ifdef ROCKET_DEBUG_OPEN
@@ -2369,6 +2369,9 @@ static int __init rp_init(void)
 	return 0;
 err_ttyu:
 	tty_unregister_driver(rocket_driver);
+err_controller:
+	if (controller)
+		release_region(controller, 4);
 err_tty:
 	put_tty_driver(rocket_driver);
 err:
