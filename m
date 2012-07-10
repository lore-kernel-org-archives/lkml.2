Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab2GJFgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 01:36:46 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:36377 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab2GJFgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 01:36:45 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q6A5aXJM003379, This message is released by code: ctlocs8528
From: Hayes Wang <hayeswang@realtek.com>
To: <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wfg@linux.intel.com>, Hayes Wang <hayeswang@realtek.com>
Subject: Re: [PATCH net-next 6/6] r8169: support RTL8168G
Date: Tue, 10 Jul 2012 13:36:30 +0800
Message-ID: <1341898590-1253-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <c558386b836ee97762e12495101c6e373f20e69d.1341872752.git.romieu@fr.zoreil.com>
References: <c558386b836ee97762e12495101c6e373f20e69d.1341872752.git.romieu@fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix incorrct argument in rtl_hw_init_8168g.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 7ff3423..c29c5fb 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -6753,14 +6753,14 @@ static void __devinit rtl_hw_init_8168g(struct rtl8169_private *tp)
 	msleep(1);
 	RTL_W8(MCU, RTL_R8(MCU) & ~NOW_IS_OOB);
 
-	data = r8168_mac_ocp_read(ioaddr, 0xe8de);
+	data = r8168_mac_ocp_read(tp, 0xe8de);
 	data &= ~(1 << 14);
 	r8168_mac_ocp_write(tp, 0xe8de, data);
 
 	if (!rtl_udelay_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42))
 		return;
 
-	data = r8168_mac_ocp_read(ioaddr, 0xe8de);
+	data = r8168_mac_ocp_read(tp, 0xe8de);
 	data |= (1 << 15);
 	r8168_mac_ocp_write(tp, 0xe8de, data);
 
-- 
1.7.10.4

