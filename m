Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab2JQN6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:58:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54360 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757099Ab2JQN6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:58:40 -0400
Date: Wed, 17 Oct 2012 16:53:06 +0300
From: Felipe Balbi <balbi@ti.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: <balbi@ti.com>, Viresh Kumar <viresh.linux@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCHv2 3/4] dw_dmac: change {dev_}printk() to corresponding
 macros
Message-ID: <20121017135306.GG11394@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350469879-16018-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1350469879-16018-4-git-send-email-andriy.shevchenko@linux.intel.com>
 <20121017130918.GD11394@arwen.pp.htv.fi>
 <1350481018.3568.3.camel@smile>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KR/qxknboQ7+Tpez"
Content-Disposition: inline
In-Reply-To: <1350481018.3568.3.camel@smile>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KR/qxknboQ7+Tpez
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 17, 2012 at 04:36:58PM +0300, Andy Shevchenko wrote:
> On Wed, 2012-10-17 at 16:09 +0300, Felipe Balbi wrote:=20
> > Hi,
> >=20
> > On Wed, Oct 17, 2012 at 01:31:17PM +0300, Andy Shevchenko wrote:
> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > ---
> > >  drivers/dma/dw_dmac.c |   15 ++++++---------
> > >  1 file changed, 6 insertions(+), 9 deletions(-)
> > >=20
> > > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> > > index c27c125..60b172a 100644
> > > --- a/drivers/dma/dw_dmac.c
> > > +++ b/drivers/dma/dw_dmac.c
> > > @@ -456,9 +456,8 @@ static void dwc_scan_descriptors(struct dw_dma *d=
w, struct dw_dma_chan *dwc)
> > > =20
> > >  static inline void dwc_dump_lli(struct dw_dma_chan *dwc, struct dw_l=
li *lli)
> > >  {
> > > -	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
> > > -			"  desc: s0x%x d0x%x l0x%x c0x%x:%x\n",
> > > -			lli->sar, lli->dar, lli->llp, lli->ctlhi, lli->ctllo);
> > > +	dev_crit(chan2dev(&dwc->chan), "  desc: s0x%x d0x%x l0x%x c0x%x:%x\=
n",
> > > +		 lli->sar, lli->dar, lli->llp, lli->ctlhi, lli->ctllo);
> >=20
> > is this really critical ? To me it looks more like a debugging message.
> This one is used in two cases, where one is marked as "error", another -
> "critical"

fair enough

> > >  static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *=
dwc)
> > > @@ -492,10 +491,8 @@ static void dwc_handle_error(struct dw_dma *dw, =
struct dw_dma_chan *dwc)
> > >  	 * controller flagged an error instead of scribbling over
> > >  	 * random memory locations.
> > >  	 */
> > > -	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
> > > -			"Bad descriptor submitted for DMA!\n");
> > > -	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
> > > -			"  cookie: %d\n", bad_desc->txd.cookie);
> > > +	dev_crit(chan2dev(&dwc->chan), "Bad descriptor submitted for DMA!\n=
");
> > > +	dev_crit(chan2dev(&dwc->chan), "  cookie: %d\n", bad_desc->txd.cook=
ie);
> >=20
> > now this is critical, indeed. I would suggest using dev_WARN_ONCE() so
> > that it's noisy enough to catch the failing user.
> To this and upper comment, there is an explanation why it's critical. I
> guess the WARN_ONCE is not good enough, for example if we have more than
> one user making such noise.

then use dev_WARN()

--=20
balbi

--KR/qxknboQ7+Tpez
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQfrhCAAoJEIaOsuA1yqREnNIP/1Uc8T1Eoa8jNaLOz8TbiCjM
TiTyzQQPBuJRixO5UwGQvO9vFAuMNff7Vqz28eXa/E/FM8B4QbCUQqKmrcTAxfd8
dUgIhyuyfkXx26RTUnwLpqS0YxfKcYYuVok8TAmWxwGrJGjqRw6VMhFeIgd2LQKx
oUlLNXod0d1TfYd+u7Mter9A+sNjM3m87zl7l2vKhK4jR4UprK/QeQBiMgvnmyhY
GcJX8LQM5GfrSBjN9cOMiznIX3Z9JfKlUjzWbaXG3+tlqTVDMnL7wzUXRmJefbhq
GB8byFRts4NgAHT0LHASkFrgLMI1ImCKitHUZW+KBa1aCvR3lnFOi0NYtYjKjLr2
lmg6fZb5szJF6YPCuPg/DZa0AII1d/CMHnTdEY7jASECDooVaJDPmRmb6w7a4MbB
iC92ZPwyt9ZwSkIBqAGEnLh2BlTpF+ZQUz5Wxu/na+0+iI58MKZ4zaQoJ04JCsIf
UVrAlQ3EIm5G/dE5yD/pkJkHDn/6tlRUifTf30rMoOEY+vfgprutuiSPnZo0cV9e
/kSfpKhtXwBU5In1VaSoHPhZ3zkUfWCYX/THjIWd7CO/GXJsj6ELJ83yni4e48nO
y47gRoShdn2L97bxyQeYR1rLwInNEaz7a/uHuO0uMAJxQSEIjtPHAWyB7MGwcBtt
XROkNZodV8xOIJQP6Y0r
=esff
-----END PGP SIGNATURE-----

--KR/qxknboQ7+Tpez--
