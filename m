Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab2CULeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 07:34:17 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:20266
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160Ab2CULeP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 07:34:15 -0400
X-SpamScore: -15
X-BigFish: VS-15(zzbb2dIc89bh1432N98dK1447Mzz1202hzz8275dhz2dh2a8h668h839hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 21 Mar 2012 19:45:17 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Florian Fainelli <florian@openwrt.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Tabi Timur-B04825 <B04825@freescale.com>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH 1/1] net: phylib: add error checking if no phy found
Message-ID: <20120321114516.GC4905@shlinux2.ap.freescale.net>
References: <1331636302-18256-1-git-send-email-b29396@freescale.com>
 <4F5F5ABF.5030103@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4F5F5ABF.5030103@openwrt.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 10:33:35PM +0800, Florian Fainelli wrote:
> Hi,
> 
> Le 03/13/12 11:58, Dong Aisheng a écrit :
> > From: Dong Aisheng<dong.aisheng@linaro.org>
> >
> > Signed-off-by: Dong Aisheng<dong.aisheng@linaro.org>
> > ---
> >   drivers/net/phy/mdio_bus.c |   11 ++++++++++-
> >   1 files changed, 10 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> > index 88cc5db..d8e044d 100644
> > --- a/drivers/net/phy/mdio_bus.c
> > +++ b/drivers/net/phy/mdio_bus.c
> > @@ -101,6 +101,7 @@ static struct class mdio_bus_class = {
> >   int mdiobus_register(struct mii_bus *bus)
> >   {
> >   	int i, err;
> > +	u32 phynum = 0;
> >
> >   	if (NULL == bus || NULL == bus->name ||
> >   			NULL == bus->read ||
> > @@ -134,12 +135,20 @@ int mdiobus_register(struct mii_bus *bus)
> >   			if (IS_ERR(phydev)) {
> >   				err = PTR_ERR(phydev);
> >   				goto error;
> > +			} else if (phydev != NULL) {
> > +				phynum++;
> >   			}
> >   		}
> >   	}
> >
> > +	if (!phynum) {
> > +		err = -ENODEV;
> > +		printk(KERN_ERR "%s: no phys found\n", bus->name);
> > +		goto error;
> > +	}
> 
> I am not sure if this is a good idea to change it, especially if:
> - the MII bus probing is also done later (quite some drivers do this)
> - if we want to attach a fixed PHY because we could not probe one at 
> registration time
> 
You're correct.
It seems keep it as before is the right solution right now.
Thanks for the info.

Regards
Dong Aisheng

