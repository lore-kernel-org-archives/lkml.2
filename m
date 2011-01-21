Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab1AULST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 06:18:19 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39826 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab1AULSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 06:18:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=GDpNl6K5Wkl3DxsMmbYq1/QEFPJMD6IMUDBkJzfcfWzWq/V8JXbLriDWPyS8Fp2/qy
         /FAPJ2wUSL1UXDxV0kDp/GSjdE2e5HV3vJyOtusFZ78hVyiREphX9eeeOcSFO9gCu93Q
         HWr926usblv0IHwcyfgztn9rJqSsrgPztjP2Q=
Subject: [PATCH] video: pxa168fb: remove a redundant pxa168fb_check_var call
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lennert Buytenhek <buytenh@marvell.com>, Green Wan <gwan@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>, Marek Vasut <marek.vasut@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-fbdev@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Lennert Buytenhek <buytenh@marvell.com>, Green Wan <gwan@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>, Marek Vasut <marek.vasut@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-fbdev@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 19:18:06 +0800
Message-ID: <1295608686.3976.9.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation calls pxa168fb_check_var twice in pxa168fb_probe.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/pxa168fb.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/video/pxa168fb.c b/drivers/video/pxa168fb.c
index cea6403..35f61dd 100644
--- a/drivers/video/pxa168fb.c
+++ b/drivers/video/pxa168fb.c
@@ -701,16 +701,12 @@ static int __devinit pxa168fb_probe(struct platform_device *pdev)
 	 */
 	pxa168fb_init_mode(info, mi);
 
-	ret = pxa168fb_check_var(&info->var, info);
-	if (ret)
-		goto failed_free_fbmem;
-
 	/*
 	 * Fill in sane defaults.
 	 */
 	ret = pxa168fb_check_var(&info->var, info);
 	if (ret)
-		goto failed;
+		goto failed_free_fbmem;
 
 	/*
 	 * enable controller clock
-- 
1.7.0.4



