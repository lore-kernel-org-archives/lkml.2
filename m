Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab2J1T6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:58:11 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:15711 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2J1T6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:58:09 -0400
Date: Tue, 25 Nov 2008 15:57:54 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: =?ISO-8859-15?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        Trilok Soni <tsoni@codeaurora.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Du, Changbin" <changbin.du@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] [media] rc: Fix double free in gpio_ir_recv_remove()
Message-ID: <alpine.LNX.2.00.0811251556020.1109@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since rc_unregister_device() frees its argument there's no need to
subsequently call rc_free_device() on the same variable - in fact it's
a double free bug.
Easily fixed by just removing the rc_free_device() call.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/media/rc/gpio-ir-recv.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index c698408..fe0941d 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -148,7 +148,6 @@ static int __devexit gpio_ir_recv_remove(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 	rc_unregister_device(gpio_dev->rcdev);
 	gpio_free(gpio_dev->gpio_nr);
-	rc_free_device(gpio_dev->rcdev);
 	kfree(gpio_dev);
 	return 0;
 }
-- 
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

