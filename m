Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab0DYNoi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 09:44:38 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39624 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab0DYNo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 09:44:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Cs+FGAY4pTCKBOA35QxdU2Yg9hsA8wXFVdT+7OZNkOvcAkXK7ReybigoqGocHSgQg9
         r1ocjHi8+SAS3vnB8cg+Nw1vrXJU3bnH9NqZZBdGZZHZ0dXJaxx6f0fY0nuwLglPSjXF
         V2nhGHn7i7p8/BlaTZEH4UdsO5Q8aehNlb3as=
Date: Sun, 25 Apr 2010 22:42:58 +0900
From: Yoichi Yuasa <yuasa@linux-mips.org>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: yuasa@linux-mips.org, Naren Sankar <nsankar@broadcom.com>,
       Jarod Wilson <jarod@wilsonet.com>, Scott Davilla <davilla@4pi.com>,
       Manu Abraham <abraham.manu@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] staging: crystalhd: remove unneeded
 crystalhd_stop_device() return code
Message-Id: <20100425224258.1bb320fa.yuasa@linux-mips.org>
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
 drivers/staging/crystalhd/crystalhd_hw.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_hw.c b/drivers/staging/crystalhd/crystalhd_hw.c
index ba81d01..e407eb8 100644
--- a/drivers/staging/crystalhd/crystalhd_hw.c
+++ b/drivers/staging/crystalhd/crystalhd_hw.c
@@ -320,7 +320,7 @@ static bool crystalhd_start_device(struct crystalhd_adp *adp)
 	return true;
 }
 
-static bool crystalhd_stop_device(struct crystalhd_adp *adp)
+static void crystalhd_stop_device(struct crystalhd_adp *adp)
 {
 	uint32_t reg;
 
@@ -340,8 +340,6 @@ static bool crystalhd_stop_device(struct crystalhd_adp *adp)
 	reg = crystalhd_reg_rd(adp, PCIE_CLK_REQ_REG);
 	reg |= PCI_CLK_REQ_ENABLE;
 	crystalhd_reg_wr(adp, PCIE_CLK_REQ_REG, reg);
-
-	return true;
 }
 
 static crystalhd_rx_dma_pkt *crystalhd_hw_alloc_rx_pkt(struct crystalhd_hw *hw)
@@ -2291,10 +2289,7 @@ BC_STATUS crystalhd_hw_suspend(struct crystalhd_hw *hw)
 
 	crystalhd_put_ddr2sleep(hw);
 
-	if (!crystalhd_stop_device(hw->adp)) {
-		BCMLOG_ERR("Failed to Stop Device!!\n");
-		return BC_STS_ERROR;
-	}
+	crystalhd_stop_device(hw->adp);
 
 	return BC_STS_SUCCESS;
 }
-- 
1.7.1

