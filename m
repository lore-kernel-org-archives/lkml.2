Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab1IAGCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 02:02:38 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:53122 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1IAGCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 02:02:35 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.13 with qID p8162SIi013342
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1314807479-1552-1-git-send-email-hayeswang@realtek.com> <1314807479-1552-3-git-send-email-hayeswang@realtek.com> <20110831191358.GB24634@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH net-next 3/3] r8169: support new chips of RTL8111F
Date: Thu, 1 Sep 2011 14:02:28 +0800
X-BOX-Message-Id: p8162SIi013342
Message-ID: <EB661FC07C9A4888A70A53281F905DF8@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcxoFKqzxstkbyQGQTmN088cMGhgIQAVf/wg
In-Reply-To: <20110831191358.GB24634@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Francois Romieu [mailto:romieu@fr.zoreil.com] 
> Sent: Thursday, September 01, 2011 3:14 AM
> To: Hayeswang
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next 3/3] r8169: support new chips of RTL8111F
> 
> Hayes Wang <hayeswang@realtek.com> :
> [...]
> > diff --git a/drivers/net/ethernet/realtek/r8169.c 
> > b/drivers/net/ethernet/realtek/r8169.c
> > index 68f1e2f..c04fbc0 100644
> > --- a/drivers/net/ethernet/realtek/r8169.c
> > +++ b/drivers/net/ethernet/realtek/r8169.c
> [...]
> > @@ -4476,6 +4602,49 @@ static void 
> rtl_hw_start_8168e_2(void __iomem *ioaddr, struct pci_dev *pdev)
> >  	RTL_W8(Config5, RTL_R8(Config5) & ~Spi_en);  }
> >  
> > +static void rtl_hw_start_8168f_1(void __iomem *ioaddr, 
> struct pci_dev 
> > +*pdev)
> [...]
> > +	RTL_W8(MaxTxPacketSize, 0x27);
> 
> Hmmm...
> 
> $ grep MaxTxPacketSize drivers/net/r8169.c
> 	MaxTxPacketSize	= 0xec,	/* 8101/8168. Unit of 128 bytes. */
> 	RTL_W8(MaxTxPacketSize, TxPacketMax);
> 	RTL_W8(MaxTxPacketSize, TxPacketMax);
> 	RTL_W8(MaxTxPacketSize, TxPacketMax);
> 	RTL_W8(MaxTxPacketSize, TxPacketMax);
> 	RTL_W8(MaxTxPacketSize, TxPacketMax);
> 	RTL_W8(MaxTxPacketSize, TxPacketMax);
> 	RTL_W8(MaxTxPacketSize, 0x27);
> 	RTL_W8(MaxTxPacketSize, TxPacketMax);
> 	RTL_W8(MaxTxPacketSize, TxPacketMax);
> 
> Is the 0x27 value still in units of 128 bytes ?

Yes.

> 
> Could it be TxPacketMax as everywhere else in the driver 
> instead of 0x27 ?

Yes, it is fine to be replaced with TxPacketMax.
The value is suggested by our hardware engineer. This chip supports 9K bytes for
tx, and TxPacketMax * 128 < 9K. This register doesn't acctually limit the tx
size. It influences the behavor when sending large packet. Thus, the different
setting may just result in different performance when sending large packet.

 
Best Regards,
Hayes

