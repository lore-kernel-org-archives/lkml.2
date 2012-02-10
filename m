Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760806Ab2BJW7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:59:21 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932870Ab2BJWos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:44:48 -0500
MIME-Version: 1.0
Message-Id: <20120210223443.198667405@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hubert Feurstein <h.feurstein@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [patch 33/55] atmel_lcdfb: fix usage of CONTRAST_CTR in suspend/resume
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -1085,7 +1085,7 @@ static int atmel_lcdfb_suspend(struct pl
 	 */
 	lcdc_writel(sinfo, ATMEL_LCDC_IDR, ~0UL);
 
-	sinfo->saved_lcdcon = lcdc_readl(sinfo, ATMEL_LCDC_CONTRAST_VAL);
+	sinfo->saved_lcdcon = lcdc_readl(sinfo, ATMEL_LCDC_CONTRAST_CTR);
 	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, 0);
 	if (sinfo->atmel_lcdfb_power_control)
 		sinfo->atmel_lcdfb_power_control(0);


