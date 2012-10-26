Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801Ab2JZPXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:23:03 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:39736 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630Ab2JZPXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:23:00 -0400
MIME-Version: 1.0
Date: Fri, 26 Oct 2012 23:23:00 +0800
Message-ID: <CAPgLHd-u=6wB7br+AVoHaADLkDQRK5055eGQnVQNSBNn5H1yYw@mail.gmail.com>
Subject: [PATCH -next] staging: comedi: use module_comedi_driver to simplify
 the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use the module_comedi_driver() macro to make the code simpler
by eliminating module_init and module_exit calls.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/comedi/drivers/das800.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das800.c b/drivers/staging/comedi/drivers/das800.c
index 1ba26b4..85ab24c 100644
--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -342,22 +342,7 @@ static int das800_probe(struct comedi_device *dev)
 	return -1;
 }
 
-/*
- * A convenient macro that defines init_module() and cleanup_module(),
- * as necessary.
- */
-static int __init driver_das800_init_module(void)
-{
-	return comedi_driver_register(&driver_das800);
-}
-
-static void __exit driver_das800_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_das800);
-}
-
-module_init(driver_das800_init_module);
-module_exit(driver_das800_cleanup_module);
+module_comedi_driver(driver_das800);
 
 /* interrupt service routine */
 static irqreturn_t das800_interrupt(int irq, void *d)

