Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab2GANgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 09:36:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40866 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab2GANgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 09:36:47 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Ian Abbott <abbotti@mev.co.uk>, Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 1/2] staging/comedi/drivers: release allocated I/O region if alloc_private fails
Date: Sun,  1 Jul 2012 19:06:38 +0530
Message-Id: <1341149798-12695-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if alloc_private fail, we wont' release the I/O region,
which was request_region 'ed.

release the allocated I/O region if alloc_private fails.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/comedi/drivers/fl512.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/fl512.c b/drivers/staging/comedi/drivers/fl512.c
index d1da809..52e6d14 100644
--- a/drivers/staging/comedi/drivers/fl512.c
+++ b/drivers/staging/comedi/drivers/fl512.c
@@ -125,8 +125,10 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 	dev->iobase = iobase;
 	dev->board_name = "fl512";
-	if (alloc_private(dev, sizeof(struct fl512_private)) < 0)
+	if (alloc_private(dev, sizeof(struct fl512_private)) < 0) {
+		release_region(iobase, FL512_SIZE);
 		return -ENOMEM;
+	}
 
 #if DEBUG
 	printk(KERN_DEBUG "malloc ok\n");
-- 
1.7.9.5

