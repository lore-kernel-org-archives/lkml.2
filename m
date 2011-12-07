Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab1LGIrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 03:47:52 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:65394 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab1LGIrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 03:47:51 -0500
Message-ID: <20191.10282.826634.821906@ipc1.ka-ro>
Date: Wed, 7 Dec 2011 09:47:38 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Baruch Siach <baruch@tkos.co.il>, <netdev@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][NET] several cleanups and bugfixes for fec.c: don't
 munge MAC address from platform data
In-Reply-To: <20111207085702.GE5550@S2100-06.ap.freescale.net>
References: <cover.1323163127.git.LW@KARO-electronics.de>
	<55b78c1766da5b0d0d679f5eae3fb9fc74a6ceef.1323163127.git.LW@KARO-electronics.de>
	<20111206124857.GB14048@sapphire.tkos.co.il>
	<20190.7244.156557.313315@ipc1.ka-ro>
	<20111207085702.GE5550@S2100-06.ap.freescale.net>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Shawn Guo writes:
> On Tue, Dec 06, 2011 at 02:44:44PM +0100, Lothar Waßmann wrote:
> > Hi,
> > 
> > Baruch Siach writes:
> > > Hi Lothar,
> > > 
> > > On Tue, Dec 06, 2011 at 11:27:13AM +0100, Lothar Waßmann wrote:
> > > > When the MAC address is supplied via platform_data it should be OK as
> > > > it is and should not be modified in case of a dual FEC setup.
> > > > Also copying the MAC from platform_data to the single 'macaddr'
> > > > variable will overwrite the MAC for the first interface in case of a
> > > > dual FEC setup.
> > > > 
> > > > Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> > > > ---
> > > >  drivers/net/ethernet/freescale/fec.c |    2 +-
> > > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/ethernet/freescale/fec.c b/drivers/net/ethernet/freescale/fec.c
> > > > index e2b5ce6..11534b9 100644
> > > > --- a/drivers/net/ethernet/freescale/fec.c
> > > > +++ b/drivers/net/ethernet/freescale/fec.c
> > > > @@ -818,7 +818,7 @@ static void __inline__ fec_get_mac(struct net_device *ndev)
> > > >  			iap = (unsigned char *)FEC_FLASHMAC;
> > > >  #else
> > > >  		if (pdata)
> > > > -			memcpy(iap, pdata->mac, ETH_ALEN);
> > > > +			iap = (unsigned char *)&pdata->mac;
> > > 
> > > Since pdata might point to __initdata struct, you must hold a copy of its 
> > > content.
> > > 
> 
> As iap will anyway be copied to ndev->dev_addr after that, it may still
> be fine to take this patch, for obviously for different reason.
> 
> > No. platform_data must be present during the life time of a driver
> > using it and thus must never be __initdata!
> > 
> Then we need to fix a lot of imx/mxc platform codes, mach-mx28evk.c
> is the one for this case.
> 
Nope. The platform_data provided there is only a template that is
copied to kmalloc'ed memory by the mxs_add...() functions.

With actual platform_data in init memory no driver built as module
would work.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
