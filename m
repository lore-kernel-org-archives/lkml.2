Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab2JZPYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:24:48 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59357 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab2JZPYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:24:46 -0400
MIME-Version: 1.0
Date: Fri, 26 Oct 2012 23:24:46 +0800
Message-ID: <CAPgLHd82USvTqYFzhySieaS_YS_oyC75XHwraRkfS48u1WLhog@mail.gmail.com>
Subject: [PATCH -next] staging: comedi: skel: use module_comedi_driver to
 simplify the code
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
 drivers/staging/comedi/drivers/skel.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/skel.c b/drivers/staging/comedi/drivers/skel.c
index f292d79..e1b78a1 100644
--- a/drivers/staging/comedi/drivers/skel.c
+++ b/drivers/staging/comedi/drivers/skel.c
@@ -628,18 +628,7 @@ static void __exit driver_skel_cleanup_module(void)
 module_init(driver_skel_init_module);
 module_exit(driver_skel_cleanup_module);
 #else
-static int __init driver_skel_init_module(void)
-{
-	return comedi_driver_register(&driver_skel);
-}
-
-static void __exit driver_skel_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_skel);
-}
-
-module_init(driver_skel_init_module);
-module_exit(driver_skel_cleanup_module);
+module_comedi_driver(driver_skel);
 #endif
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");


