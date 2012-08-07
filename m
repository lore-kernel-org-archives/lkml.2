Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030211Ab2HGWb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:31:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824Ab2HGWbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:31:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 075/122] tg3: Fix Read DMA workaround for 5719 A0.
Date: Tue,  7 Aug 2012 15:26:03 -0700
Message-Id: <20120807221955.457966747@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <mchan@broadcom.com>

commit 10ce95d6ef36c65df7dcd3b8fcf86913f8b298bd upstream.

The workaround was mis-applied to all 5719 and 5720 chips.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/tg3.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -8975,8 +8975,7 @@ static int tg3_reset_hw(struct tg3 *tp,
 	    GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_57780 ||
 	    tg3_flag(tp, 57765_PLUS)) {
 		val = tr32(TG3_RDMA_RSRVCTRL_REG);
-		if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5719 ||
-		    GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5720) {
+		if (tp->pci_chip_rev_id == CHIPREV_ID_5719_A0) {
 			val &= ~(TG3_RDMA_RSRVCTRL_TXMRGN_MASK |
 				 TG3_RDMA_RSRVCTRL_FIFO_LWM_MASK |
 				 TG3_RDMA_RSRVCTRL_FIFO_HWM_MASK);


