Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab2C1Cwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 22:52:34 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:53511 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab2C1Cwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 22:52:32 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q2S2qP8d009362
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1332834834-5185-1-git-send-email-hayeswang@realtek.com> <1332834834-5185-2-git-send-email-hayeswang@realtek.com> <20120327225437.GC22177@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH net-next 2/5] r8169: add csi_opt
Date: Wed, 28 Mar 2012 10:52:24 +0800
Message-ID: <C4853E741FE64400AFA06E6FB7B634D9@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac0MbPSJwuE5pkWNTPWIdk+ejy644AAHvWgQ
In-Reply-To: <20120327225437.GC22177@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Francois Romieu [mailto:romieu@fr.zoreil.com] 
 [...]
> > -static void rtl_csi_access_enable_2(void __iomem *ioaddr)
> > +static void __devinit rtl_init_csi_ops(struct rtl8169_private *tp)
> >  {
> > -	rtl_csi_access_enable(ioaddr, 0x27000000);
> > +	struct csi_ops *ops = &tp->csi_ops;
> > +
> > +	switch (tp->mac_version) {
> > +	default:
> > +		ops->write	= r8169_csi_write;
> > +		ops->read	= r8169_csi_read;
> > +		break;
> > +	}
> >  }
> >  
> >  struct ephy_info {
> [...]
> > @@ -6199,6 +6267,7 @@ rtl_init_one(struct pci_dev *pdev, 
> const struct pci_device_id *ent)
> >  	rtl_init_mdio_ops(tp);
> >  	rtl_init_pll_power_ops(tp);
> >  	rtl_init_jumbo_ops(tp);
> > +	rtl_init_csi_ops(tp);
> >  
> >  	rtl8169_print_mac_version(tp);
> 
> It will enable the CSI read/write functions where they 
> previously weren't.
> 
> Is it really supposed to behave this way ?
> 
> Thanks.
> 

It seems to be fine, but I would modify them. Thanks.
 
Best Regards,
Hayes

