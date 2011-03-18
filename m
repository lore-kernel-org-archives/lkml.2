Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab1CROiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 10:38:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49792 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724Ab1CROiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 10:38:11 -0400
From: "Premi, Sanjeev" <premi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>, Andy Green <andy@warmcat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Andy Green <andy.green@linaro.org>
Date: Fri, 18 Mar 2011 20:07:55 +0530
Subject: RE: [RFC PATCH 2/5] OMAP2+: add cpu id register to MAC address
 helper
Thread-Topic: [RFC PATCH 2/5] OMAP2+: add cpu id register to MAC address
 helper
Thread-Index: AcvlR2+85uRY9CCLRByXpbUKcohVigAMiSMQ
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024C3B8670@dbde02.ent.ti.com>
References: <20110312224440.27728.60593.stgit@otae.warmcat.com>
 <20110312225047.27728.1835.stgit@otae.warmcat.com>
 <201103180934.39997.arnd@arndb.de>
In-Reply-To: <201103180934.39997.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org 
> [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of Arnd Bergmann
> Sent: Friday, March 18, 2011 2:05 PM
> To: Andy Green
> Cc: linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org; 
> linux-omap@vger.kernel.org; 
> linux-arm-kernel@lists.infradead.org; patches@linaro.org; Andy Green
> Subject: Re: [RFC PATCH 2/5] OMAP2+: add cpu id register to 
> MAC address helper
> 
> On Saturday 12 March 2011, Andy Green wrote:
> > Introduce a generic helper function that can set a MAC address using
> > data from the OMAP unqiue CPU ID register.
> > 
> > Signed-off-by: Andy Green <andy.green@linaro.org>
> > ---
> > 
> >  arch/arm/mach-omap2/id.c              |   13 +++++++++++++
> >  arch/arm/mach-omap2/include/mach/id.h |    1 +
> >  2 files changed, 14 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
> > index 5f9086c..fc69ec5 100644
> > --- a/arch/arm/mach-omap2/id.c
> > +++ b/arch/arm/mach-omap2/id.c
> > @@ -506,3 +506,16 @@ void __init 
> omap2_set_globals_tap(struct omap_globals *omap2_globals)
> >         else
> >                 tap_prod_id = 0x0208;
> >  }
> > +
> > +
> > +void omap2_die_id_to_mac(u8 *mac, int length)
> > +{
> > +       struct omap_die_id odi;
> > +
> > +       omap_get_die_id(&odi);
> > +       memcpy(mac, &odi.id_0, length);
> > +
> > +       /* mark it as not multicast and outside official 
> 80211 MAC namespace */
> > +
> > +       mac[0] = (mac[0] & ~1) | 2;
> > +}
> 
> This is a pretty clever trick, but it's not an official 
> globally unique MAC
> address, right?

[sp] This 'trick' has been tried earlier in u-boot. See:
     http://www.mail-archive.com/u-boot@lists.denx.de/msg19915.html

     I am also not sure whether DIE_ID would really be unique.

~sanjeev

> Maybe we can ask TI to officially request a 
> MAC address range
> for OMAP SoCs and document an official procedure to compute it.
> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 