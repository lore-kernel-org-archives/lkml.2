Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab2JNPLv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:11:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46175 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754300Ab2JNOmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:10 -0400
Message-Id: <20121014143551.767772854@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Francois Romieu <romieu@fr.zoreil.com>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [ 133/147] r8169: 8168c and later require bit 0x20 to be set in Config2 for PME
 signaling.
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

commit d387b427c973974dd619a33549c070ac5d0e089f upstream.

The new 84xx stopped flying below the radars.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/realtek/r8169.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 9b0b00b..207aadc 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -315,6 +315,8 @@ enum rtl_registers {
 	Config0		= 0x51,
 	Config1		= 0x52,
 	Config2		= 0x53,
+#define PME_SIGNAL			(1 << 5)	/* 8168c and later */
+
 	Config3		= 0x54,
 	Config4		= 0x55,
 	Config5		= 0x56,
@@ -1422,6 +1424,10 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 		RTL_W8(Config1, options);
 		break;
 	default:
+		options = RTL_R8(Config2) & ~PME_SIGNAL;
+		if (wolopts)
+			options |= PME_SIGNAL;
+		RTL_W8(Config2, options);
 		break;
 	}
 


