Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab1BVMbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 07:31:16 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:45175 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1BVMbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 07:31:15 -0500
From: hayeswang <hayeswang@realtek.com>
To: "'Alexander Wuerstlein'" <arw@arw.name>
CC: "'David S. Miller'" <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        "'franois romieu'" <romieu@fr.zoreil.com>
References: <20110216223438.GZ15516@cip.informatik.uni-erlangen.de> <CDC3F2AD9A574AC4B7DDDB7D64329A79@realtek.com.tw> <20110218173013.GC15516@cip.informatik.uni-erlangen.de>
Subject: RE: r8169 hangs machine on kernel boot (bisected)
Date: Tue, 22 Feb 2011 20:30:59 +0800
X-BOX-Message-Id: p1MCUxmK003919
Message-ID: <74B28238B88A415E96A0B885B5B6A8A6@realtek.com.tw>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0004_01CBD2CF.6A3DCF50"
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcvQ+1zCPJjbfjsKRJmqYJxgsT/gOQBkDoUg
In-Reply-To: <20110218173013.GC15516@cip.informatik.uni-erlangen.de>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_NextPart_000_0004_01CBD2CF.6A3DCF50
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello,

please use the patch of the attatched file to check if it fix the issue. Thanks.
 
Best Regards,
Hayes
 

> -----Original Message-----
> From: Alexander Wuerstlein [mailto:arw@arw.name] 
> Sent: Saturday, February 19, 2011 1:30 AM
> To: Hayeswang
> Cc: 'David S. Miller'; linux-kernel@vger.kernel.org; 'franois romieu'
> Subject: Re: r8169 hangs machine on kernel boot (bisected)
> 
> Hello,
> 
> On 11-02-18 15:01, hayeswang <hayeswang@realtek.com> wrote:
> > Hello,
> > > I've just tried to boot a new computer featuring a Realtek r8168 
> > > onboard (lspci calls it Realtek Semiconductor Co., Ltd. 
> > > RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] 
> > > (rev 04), see [1]) network chip with kernel
> > > 2.6.38-rc5 and current git. Both hang on boot just after 
> USB device 
> > > initialization and just before the kernel usually does DHCP. The 
> > > previous 2.6.37 didn't hang on boot, but showed strange behaviour 
> > > (only 10MBit half duplex on autonegotiation, tons of 
> errors on the 
> > > switch interface[2]) which is why I tried the newer 
> kernel in hopes that there would be fixes.
> > > 
> > > I bisected the hang-before-dhcp bug down to commit 'r8169: magic.'
> > > (b646d90053f887c1bc243191e693a9b02d09f2c2, also see [1]). 
> Since the 
> > > commit really does its description justice and looks like 
> some weird 
> > > hardware magic, I'd like to ask the wizards on how to 
> proceed with fixing it.
> > 
> > I have try the 8168DP and it wouldn't hang. I think I need 
> more information.
> > Could you give the information about the motherboard and 
> the version of BIOS.
> > Besides, please use the realtek driver, and dump the MAC 
> information 
> > by using "ethtool -d eth0". These are helpful to find out 
> what happens. Thanks.
> 
> I'm sorry that it took me so long to answer, I've had some 
> problems booting the machine today since the PXE-Client 
> didn't get any DHCP requests through. I'm not sure if its 
> related, the problem cleared up after I opened up the machine 
> to get the motherboard data and stuff.
> 
> Long story short, new files 'bios', 'hardware' and 'ethtool-d' in
> http://wwwcip.cs.fau.de/~snalwuer/kernel-r8169
> Bios revision is the latest available from Fujitsu for that hardware.
> Hardware numbers and serials are accurate, but the 
> inscriptions on the chips I suspected to be PHYs were very 
> hard to read, so expect errors.
> The 'ethtool-d' is especially curious, since it consists of 
> only 'FF'-bytes. The ethtool register dump was taken on a 
> 2.6.37 with r8168 as a module.
> 
> fujitsu.com also has some (limited, end-user-focused) 
> hardware documentation if you enter the serial number 
> 'YL7E003277' on http://ts.fujitsu.com/support/downloads.html
> 
> If you need any further information, don't hesitate to ask.
> 
> 
> 
> Ciao,
> 
> Alexander Wuerstlein.

------=_NextPart_000_0004_01CBD2CF.6A3DCF50
Content-Type: application/octet-stream;
	name="0002-net-r8169-fix-the-wrong-parameter-of-point-address.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0002-net-r8169-fix-the-wrong-parameter-of-point-address.patch"

>From cb72287585ed3c8ca87ac03634b31bf8df6bf58f Mon Sep 17 00:00:00 2001=0A=
From: Hayes Wang <hayeswang@realtek.com>=0A=
Date: Tue, 22 Feb 2011 17:06:21 +0800=0A=
Subject: [PATCH 2/3] net/r8169: fix the wrong parameter of point address=0A=
=0A=
Correct the parameter of rtl8168_oob_notify. It results in the=0A=
wrong point address and influences RTL8168DP.=0A=
=0A=
Signed-off-by: Hayes Wang <hayeswang@realtek.com>=0A=
---=0A=
 drivers/net/r8169.c |    5 +++--=0A=
 1 files changed, 3 insertions(+), 2 deletions(-)=0A=
=0A=
diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c=0A=
index 3630dd7..336ba94 100644=0A=
--- a/drivers/net/r8169.c=0A=
+++ b/drivers/net/r8169.c=0A=
@@ -617,8 +617,9 @@ static void ocp_write(struct rtl8169_private *tp, u8 =
mask, u16 reg, u32 data)=0A=
 	}=0A=
 }=0A=
 =0A=
-static void rtl8168_oob_notify(void __iomem *ioaddr, u8 cmd)=0A=
+static void rtl8168_oob_notify(struct rtl8169_private *tp, u8 cmd)=0A=
 {=0A=
+	void __iomem *ioaddr =3D tp->mmio_addr;=0A=
 	int i;=0A=
 =0A=
 	RTL_W8(ERIDR, cmd);=0A=
@@ -630,7 +631,7 @@ static void rtl8168_oob_notify(void __iomem *ioaddr, =
u8 cmd)=0A=
 			break;=0A=
 	}=0A=
 =0A=
-	ocp_write(ioaddr, 0x1, 0x30, 0x00000001);=0A=
+	ocp_write(tp, 0x1, 0x30, 0x00000001);=0A=
 }=0A=
 =0A=
 #define OOB_CMD_RESET		0x00=0A=
-- =0A=
1.7.3.2=0A=
=0A=

------=_NextPart_000_0004_01CBD2CF.6A3DCF50--
