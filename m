Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab2CLAxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:53:03 -0400
Received: from 1wt.eu ([62.212.114.60]:63126 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692Ab2CLAtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:49:15 -0400
Message-Id: <20120312004411.724609398@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:44:21 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Hubert Feurstein <h.feurstein@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 10/13] atmel_lcdfb: fix usage of CONTRAST_CTR in suspend/resume
In-Reply-To: <fec4dd6c17083169f2e217caca7375ef@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Hubert Feurstein <h.feurstein@gmail.com>

commit 9f1065032ceb7e86c7c9f16bb86518857e88a172 upstream.

An error was existing in the saving of CONTRAST_CTR register
across suspend/resume.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/atmel_lcdfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index d5e8010..8c5e432 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -1052,7 +1052,7 @@ static int atmel_lcdfb_suspend(struct platform_device *pdev, pm_message_t mesg)
 	 */
 	lcdc_writel(sinfo, ATMEL_LCDC_IDR, ~0UL);
 
-	sinfo->saved_lcdcon = lcdc_readl(sinfo, ATMEL_LCDC_CONTRAST_VAL);
+	sinfo->saved_lcdcon = lcdc_readl(sinfo, ATMEL_LCDC_CONTRAST_CTR);
 	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, 0);
 	if (sinfo->atmel_lcdfb_power_control)
 		sinfo->atmel_lcdfb_power_control(0);
-- 
1.7.2.1.45.g54fbc



