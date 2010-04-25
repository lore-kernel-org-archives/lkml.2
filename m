Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab0DYNoY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 09:44:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49582 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab0DYNoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 09:44:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=gPwIYIWwyo/u+r28M0BAnpW4m5QS80XhywH5YI4uD8hTIYPRXfUw0YyRD0Oq3mzcUO
         tml2oZ3d2jzdJ8IT/B83YgZZDxrVkq8skLTurqH+YcIYk6YsOC15a8WSaQLbf7kklcDu
         mUMxBfCATUbuoE8sJU8iVQ3qjkZG4CHGIDXBI=
Date: Sun, 25 Apr 2010 22:42:09 +0900
From: Yoichi Yuasa <yuasa@linux-mips.org>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: yuasa@linux-mips.org, Naren Sankar <nsankar@broadcom.com>,
       Jarod Wilson <jarod@wilsonet.com>, Scott Davilla <davilla@4pi.com>,
       Manu Abraham <abraham.manu@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] staging: crystalhd: clean up
 crystalhd_put_ddr2sleep() return code
Message-Id: <20100425224209.954e3140.yuasa@linux-mips.org>
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
 drivers/staging/crystalhd/crystalhd_hw.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_hw.c b/drivers/staging/crystalhd/crystalhd_hw.c
index 01819d3..4e4d271 100644
--- a/drivers/staging/crystalhd/crystalhd_hw.c
+++ b/drivers/staging/crystalhd/crystalhd_hw.c
@@ -1565,7 +1565,7 @@ static BC_STATUS crystalhd_fw_cmd_post_proc(struct crystalhd_hw *hw,
 	return sts;
 }
 
-static BC_STATUS crystalhd_put_ddr2sleep(struct crystalhd_hw *hw)
+static void crystalhd_put_ddr2sleep(struct crystalhd_hw *hw)
 {
 	uint32_t reg;
 	link_misc_perst_decoder_ctrl rst_cntrl_reg;
@@ -1618,8 +1618,6 @@ static BC_STATUS crystalhd_put_ddr2sleep(struct crystalhd_hw *hw)
 	reg = bc_dec_reg_rd(hw->adp, DecHt_PllBCtl);
 	reg |= 0x00008000;
 	bc_dec_reg_wr(hw->adp, DecHt_PllBCtl, reg);
-
-	return BC_STS_SUCCESS;
 }
 
 /************************************************
@@ -2289,18 +2287,12 @@ BC_STATUS crystalhd_hw_unpause(struct crystalhd_hw *hw)
 
 BC_STATUS crystalhd_hw_suspend(struct crystalhd_hw *hw)
 {
-	BC_STATUS sts;
-
 	if (!hw) {
 		BCMLOG_ERR("Invalid Arguments\n");
 		return BC_STS_INV_ARG;
 	}
 
-	sts = crystalhd_put_ddr2sleep(hw);
-	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("Failed to Put DDR To Sleep!!\n");
-		return BC_STS_ERROR;
-	}
+	crystalhd_put_ddr2sleep(hw);
 
 	if (!crystalhd_stop_device(hw->adp)) {
 		BCMLOG_ERR("Failed to Stop Device!!\n");
-- 
1.7.1

