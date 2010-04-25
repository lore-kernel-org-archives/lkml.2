Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab0DYNoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 09:44:30 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39624 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab0DYNoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 09:44:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=DXbvdbyQH4QUITQwbjhaAM9EjnFRRu4fffO2n9mWcCdAe4uXCM9GIZK9JcivLMg9Px
         7egQPXM4kfcBQJXLBMbnLJaeEo4wct0CJ8wmScR5yojnb0PMlFEKrPERbc4OAc+ShlM2
         4QEjYVSvN6X8uEQbsy7FqugWjHML7ex6MhLAg=
Date: Sun, 25 Apr 2010 22:42:34 +0900
From: Yoichi Yuasa <yuasa@linux-mips.org>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: yuasa@linux-mips.org, Naren Sankar <nsankar@broadcom.com>,
       Jarod Wilson <jarod@wilsonet.com>, Scott Davilla <davilla@4pi.com>,
       Manu Abraham <abraham.manu@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] staging: crystalhd: remove unneeded
 crystalhd_put_in_reset() return code
Message-Id: <20100425224234.a2f77b8f.yuasa@linux-mips.org>
In-Reply-To: <20100425221851.223dc284.yuasa@linux-mips.org>
References: <20100425221851.223dc284.yuasa@linux-mips.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
---
 drivers/staging/crystalhd/crystalhd_hw.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_hw.c b/drivers/staging/crystalhd/crystalhd_hw.c
index 4e4d271..ba81d01 100644
--- a/drivers/staging/crystalhd/crystalhd_hw.c
+++ b/drivers/staging/crystalhd/crystalhd_hw.c
@@ -119,7 +119,7 @@ static bool crystalhd_bring_out_of_rst(struct crystalhd_adp *adp)
 	return true;
 }
 
-static bool crystalhd_put_in_reset(struct crystalhd_adp *adp)
+static void crystalhd_put_in_reset(struct crystalhd_adp *adp)
 {
 	link_misc_perst_deco_ctrl rst_deco_cntrl;
 	link_misc_perst_clk_ctrl  rst_clk_cntrl;
@@ -171,8 +171,6 @@ static bool crystalhd_put_in_reset(struct crystalhd_adp *adp)
 
 	/* restore the transaction configuration register */
 	crystalhd_reg_wr(adp, PCIE_TL_TRANSACTION_CONFIGURATION, temp);
-
-	return true;
 }
 
 static void crystalhd_disable_interrupts(struct crystalhd_adp *adp)
@@ -332,8 +330,7 @@ static bool crystalhd_stop_device(struct crystalhd_adp *adp)
 	crystalhd_clear_errors(adp);
 	crystalhd_clear_interrupts(adp);
 
-	if (!crystalhd_put_in_reset(adp))
-		BCMLOG_ERR("Failed to Put Link To Reset State\n");
+	crystalhd_put_in_reset(adp);
 
 	reg = crystalhd_reg_rd(adp, PCIE_DLL_DATA_LINK_CONTROL);
 	reg |= ASPM_L1_ENABLE;
-- 
1.7.1

