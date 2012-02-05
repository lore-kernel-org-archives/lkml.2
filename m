Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab2BEG2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 01:28:37 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40247 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab2BEG2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 01:28:36 -0500
Date: Sun, 5 Feb 2012 06:28:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Timur Tabi <timur@freescale.com>
Cc: linux-kernel@vger.kernel.org
Subject: fsl-diu: enable_lcdc() takes a pointer, not struct...
Message-ID: <20120205062835.GA23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of places missed in commit ddd3d905436b572ebadc09dcf2d12ca5b37020a0...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/drivers/video/fsl-diu-fb.c b/drivers/video/fsl-diu-fb.c
index acf292b..629ae00 100644
--- a/drivers/video/fsl-diu-fb.c
+++ b/drivers/video/fsl-diu-fb.c
@@ -1432,7 +1432,7 @@ static int fsl_diu_suspend(struct platform_device *ofdev, pm_message_t state)
 	struct fsl_diu_data *data;
 
 	data = dev_get_drvdata(&ofdev->dev);
-	disable_lcdc(data->fsl_diu_info[0]);
+	disable_lcdc(&data->fsl_diu_info[0]);
 
 	return 0;
 }
@@ -1442,7 +1442,7 @@ static int fsl_diu_resume(struct platform_device *ofdev)
 	struct fsl_diu_data *data;
 
 	data = dev_get_drvdata(&ofdev->dev);
-	enable_lcdc(data->fsl_diu_info[0]);
+	enable_lcdc(&data->fsl_diu_info[0]);
 
 	return 0;
 }
