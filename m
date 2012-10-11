Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466Ab2JKBNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:13:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51459 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933028Ab2JKBNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:13:43 -0400
X-Sasl-enc: jCY0RCkJU6tx6yxJrda6897MboYb5HrZD2yxX6UhvTT8 1349918022
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Hayes Wang <hayeswang@realtek.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 099/120] r8169: 8168c and later require bit 0x20 to be set in Config2 for PME signaling.
Date: Thu, 11 Oct 2012 10:00:51 +0900
Message-Id: <20121011005845.160604557@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

commit d387b427c973974dd619a33549c070ac5d0e089f upstream.

The new 84xx stopped flying below the radars.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Hayes Wang <hayeswang@realtek.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/realtek/r8169.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -319,6 +319,8 @@ enum rtl_registers {
 	Config0		= 0x51,
 	Config1		= 0x52,
 	Config2		= 0x53,
+#define PME_SIGNAL			(1 << 5)	/* 8168c and later */
+
 	Config3		= 0x54,
 	Config4		= 0x55,
 	Config5		= 0x56,
@@ -1426,6 +1428,10 @@ static void __rtl8169_set_wol(struct rtl
 		RTL_W8(Config1, options);
 		break;
 	default:
+		options = RTL_R8(Config2) & ~PME_SIGNAL;
+		if (wolopts)
+			options |= PME_SIGNAL;
+		RTL_W8(Config2, options);
 		break;
 	}
 


