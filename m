Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934458Ab2JKC2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:28:39 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34530 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933786Ab2JKC0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:26:35 -0400
X-Sasl-enc: 4SWsxU8Ja1foOavLBhl43aoXRN3QPT58Wza/ibv6gOEE 1349922394
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Francois Romieu <romieu@fr.zoreil.com>,
        Hayes Wang <hayeswang@realtek.com>,
        Jonathan Nieder <jrnieder@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 71/84] r8169: 8168c and later require bit 0x20 to be set in Config2 for PME signaling.
Date: Thu, 11 Oct 2012 11:03:55 +0900
Message-Id: <20121011015429.837494956@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

commit d387b427c973974dd619a33549c070ac5d0e089f upstream.

The new 84xx stopped flying below the radars.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Hayes Wang <hayeswang@realtek.com>
Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/r8169.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -299,6 +299,8 @@ enum rtl_registers {
 	Config0		= 0x51,
 	Config1		= 0x52,
 	Config2		= 0x53,
+#define PME_SIGNAL			(1 << 5)	/* 8168c and later */
+
 	Config3		= 0x54,
 	Config4		= 0x55,
 	Config5		= 0x56,
@@ -1249,6 +1251,10 @@ static void __rtl8169_set_wol(struct rtl
 		RTL_W8(Config1, options);
 		break;
 	default:
+		options = RTL_R8(Config2) & ~PME_SIGNAL;
+		if (wolopts)
+			options |= PME_SIGNAL;
+		RTL_W8(Config2, options);
 		break;
 	}
 


