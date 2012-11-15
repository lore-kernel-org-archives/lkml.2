Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602Ab2KOE3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:29:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:49452 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993078Ab2KOEMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Chris Ball <cjb@laptop.org>
Subject: [ 58/66] mmc: sh_mmcif: fix use after free
Date: Wed, 14 Nov 2012 20:11:03 -0800
Message-Id: <20121115040943.335940983@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit a0d28ba01ebd048b4ba418142b37f5cf80e6d156 upstream.

A recent commit "mmc: sh_mmcif: fix clock management" has introduced a
use after free bug in sh_mmcif.c: in sh_mmcif_remove() the call to
mmc_free_host() frees private driver data, therefore using it afterwards
is a bug. Revert that hunk.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sh_mmcif.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -1464,9 +1464,9 @@ static int __devexit sh_mmcif_remove(str
 
 	platform_set_drvdata(pdev, NULL);
 
+	clk_disable(host->hclk);
 	mmc_free_host(host->mmc);
 	pm_runtime_put_sync(&pdev->dev);
-	clk_disable(host->hclk);
 	pm_runtime_disable(&pdev->dev);
 
 	return 0;


