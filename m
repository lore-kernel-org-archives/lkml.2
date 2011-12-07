Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab1LGKpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 05:45:39 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:25396
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755049Ab1LGKph convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 05:45:37 -0500
X-SpamScore: -9
X-BigFish: VS-9(zzc89bh1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 7 Dec 2011 18:58:17 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: <netdev@vger.kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH][NET] several cleanups and bugfixes for fec.c: preserve
 MII/RMII setting in fec_stop()
Message-ID: <20111207105816.GH5550@S2100-06.ap.freescale.net>
References: <cover.1323163127.git.LW@KARO-electronics.de>
 <d6f4de9e4cfb393754b42815a2ef1a59c96eab83.1323163127.git.LW@KARO-electronics.de>
 <20111207094146.GG5550@S2100-06.ap.freescale.net>
 <20191.17172.493079.722098@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20191.17172.493079.722098@ipc1.ka-ro>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 11:42:28AM +0100, Lothar Waﬂmann wrote:
> Hi,
> 
> Shawn Guo writes:
> > On Tue, Dec 06, 2011 at 11:27:14AM +0100, Lothar Waﬂmann wrote:
> > > Additionally to setting the ETHER_EN bit in FEC_ECNTRL the MII/RMII
> > > setting in FEC_R_CNTRL needs to be preserved to keep the MII interface
> > 
> > s/MII/RMII?  From what I see from imx28 and imx6q RM, the reset state
> > for this setting is MII mode.
> > 
> > > functional.
> > > 
> > > Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
> > > ---
> > >  drivers/net/ethernet/freescale/fec.c |    5 ++++-
> > >  1 files changed, 4 insertions(+), 1 deletions(-)
> > 
> > I assume this is fixing a problem you are seeing on imx28 only.
> > Do you see the problem on imx53/51?
> > 
> No. i.MX53 uses the RMII gasket which is not affected by resetting the
> controller. And imMX51 does not support RMII at all.
> 
> > > 
> > > diff --git a/drivers/net/ethernet/freescale/fec.c b/drivers/net/ethernet/freescale/fec.c
> > > index 11534b9..ab0afb5 100644
> > > --- a/drivers/net/ethernet/freescale/fec.c
> > > +++ b/drivers/net/ethernet/freescale/fec.c
> > > @@ -515,6 +515,7 @@ fec_stop(struct net_device *ndev)
> > >  	struct fec_enet_private *fep = netdev_priv(ndev);
> > >  	const struct platform_device_id *id_entry =
> > >  				platform_get_device_id(fep->pdev);
> > > +	u32 rmii_mode = readl(fep->hwp + FEC_R_CNTRL) & (1 << 8);
> > 
> > This bit is only available on ENET (imx28 and imx6q).  Do we want to
> > do the same thing for FEC (imx25/27/35/51/53)?
> > 
> No. AFAICT that's not necessary there.
> 
So you need to check it's actually running on ENET before accessing
the bit.

-- 
Regards,
Shawn

