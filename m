Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab1GMMQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 08:16:19 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:38124 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab1GMMQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 08:16:17 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.13 with qID p6DCG9gG005370, This message is released by code: ctaloc0852
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1309939088-31994-1-git-send-email-hayeswang@realtek.com> <1309939088-31994-3-git-send-email-hayeswang@realtek.com> <20110712161258.GA6157@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH net-next v2 3/7] r8169: adjust the settings about RxConfig
Date: Wed, 13 Jul 2011 20:16:08 +0800
X-BOX-Message-Id: p6DCG9gG005370
Message-ID: <EA7F6570521F42DBA6E34CE7E23249C3@realtek.com.tw>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0016_01CC4199.B3E5B800"
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcxAsJtndu/X7NEkSdKIv/+zUdZp0QAorMSw
In-Reply-To: <20110712161258.GA6157@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_NextPart_000_0016_01CC4199.B3E5B800
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

 
 Francois Romieu [mailto:romieu@fr.zoreil.com] 
> Sent: Wednesday, July 13, 2011 12:13 AM
> To: Hayeswang
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next v2 3/7] r8169: adjust the 
> settings about RxConfig
> 
> Hayes Wang <hayeswang@realtek.com> :
> > Set the init value before reset in probe function. And then just 
> > modify the relative bits and keep the init settings.
> 
> It breaks my old PCI Netgear 8110s (RTL_GIGA_MAC_VER_03/XID 
> 04000000). Once the device is up, RxConfig is changed from 
> 0x0000e70e to 0x0000000e (missed write ?).
> 

I find that the RxConfig has to be set after the tx/rx is enabled for 8110S(x)
series.

> Is there any side effect / objection if this patch is removed 
> from the series and scheduled for a later time ?
> 

The original values are different from the suggested values, so I hope to apply
this patch.
Please try the attached file. It should fix this issue.
 
Best Regards,
Hayes

------=_NextPart_000_0016_01CC4199.B3E5B800
Content-Type: application/octet-stream;
	name="0001-r8169-fix-the-RxConfig-couldn-t-be-written.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-r8169-fix-the-RxConfig-couldn-t-be-written.patch"

>From d291f25398cd6de2d9ef8545e70f003dd091f192 Mon Sep 17 00:00:00 2001=0A=
From: Hayes <hayeswang@realtek.com>=0A=
Date: Wed, 13 Jul 2011 11:44:06 +0800=0A=
Subject: [PATCH] r8169:fix the RxConfig couldn't be written=0A=
=0A=
For 8110S, 8110SB, and 8110SC series, the initial value of RxConfig=0A=
needs to be set after the tx/rx is enabled.=0A=
=0A=
Signed-off-by Hayes Wang <hayeswang@realtek.com>=0A=
---=0A=
 drivers/net/r8169.c |    3 +++=0A=
 1 files changed, 3 insertions(+), 0 deletions(-)=0A=
=0A=
diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c=0A=
index 19d739a..f04cd8a 100644=0A=
--- a/drivers/net/r8169.c=0A=
+++ b/drivers/net/r8169.c=0A=
@@ -4065,6 +4065,9 @@ static void rtl_hw_start_8169(struct net_device =
*dev)=0A=
 	    tp->mac_version =3D=3D RTL_GIGA_MAC_VER_04)=0A=
 		RTL_W8(ChipCmd, CmdTxEnb | CmdRxEnb);=0A=
 =0A=
+	/* RxConfig needs to be initialized after tx/rx enable */=0A=
+	rtl_init_rxcfg(tp);=0A=
+=0A=
 	RTL_W8(EarlyTxThres, NoEarlyTx);=0A=
 =0A=
 	rtl_set_rx_max_size(ioaddr, rx_buf_sz);=0A=
-- =0A=
1.7.3.4=0A=
=0A=

------=_NextPart_000_0016_01CC4199.B3E5B800--
