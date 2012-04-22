Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab2DVLhS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 07:37:18 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:53318 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab2DVLhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 07:37:15 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: kernel-janitors@vger.kernel.org, Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/staging/comedi/comedi_fops.c: add missing vfree
Date: Sun, 22 Apr 2012 13:37:09 +0200
Message-Id: <1335094629-15879-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

aux_free is freed on all other exits from the function.  By removing the
return, we can benefit from the vfree already at the end of the function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/comedi/comedi_fops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index a0861fb..06fc656 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -301,7 +301,7 @@ static int do_devconfig_ioctl(struct comedi_device *dev,
 	if (ret == 0) {
 		if (!try_module_get(dev->driver->module)) {
 			comedi_device_detach(dev);
-			return -ENOSYS;
+			ret = -ENOSYS;
 		}
 	}
 

