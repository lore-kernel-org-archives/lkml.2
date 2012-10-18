Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab2JROFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:05:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58190 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab2JROFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:05:04 -0400
Date: Thu, 18 Oct 2012 16:59:27 +0300
From: Felipe Balbi <balbi@ti.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: <balbi@ti.com>, Viresh Kumar <viresh.linux@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCHv2 3/4] dw_dmac: change {dev_}printk() to corresponding
 macros
Message-ID: <20121018135927.GD2739@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350469879-16018-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1350469879-16018-4-git-send-email-andriy.shevchenko@linux.intel.com>
 <20121017130918.GD11394@arwen.pp.htv.fi>
 <1350481018.3568.3.camel@smile>
 <20121017135306.GG11394@arwen.pp.htv.fi>
 <1350548131.3568.6.camel@smile>
 <20121018103413.GB1449@arwen.pp.htv.fi>
 <1350558583.3568.9.camel@smile>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hxkXGo8AKqTJ+9QI"
Content-Disposition: inline
In-Reply-To: <1350558583.3568.9.camel@smile>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hxkXGo8AKqTJ+9QI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 18, 2012 at 02:09:43PM +0300, Andy Shevchenko wrote:
> On Thu, 2012-10-18 at 13:34 +0300, Felipe Balbi wrote:=20
> > On Thu, Oct 18, 2012 at 11:15:31AM +0300, Andy Shevchenko wrote:
> > > On Wed, 2012-10-17 at 16:53 +0300, Felipe Balbi wrote:=20
> > > > On Wed, Oct 17, 2012 at 04:36:58PM +0300, Andy Shevchenko wrote:
> > > > > On Wed, 2012-10-17 at 16:09 +0300, Felipe Balbi wrote:=20
>=20
> > > > > > > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
>=20
> > > > > > > @@ -492,10 +491,8 @@ static void dwc_handle_error(struct dw_d=
ma *dw, struct dw_dma_chan *dwc)
> > > > > > >  	 * controller flagged an error instead of scribbling over
> > > > > > >  	 * random memory locations.
> > > > > > >  	 */
> > > > > > > -	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
> > > > > > > -			"Bad descriptor submitted for DMA!\n");
> > > > > > > -	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
> > > > > > > -			"  cookie: %d\n", bad_desc->txd.cookie);
> > > > > > > +	dev_crit(chan2dev(&dwc->chan), "Bad descriptor submitted fo=
r DMA!\n");
> > > > > > > +	dev_crit(chan2dev(&dwc->chan), "  cookie: %d\n", bad_desc->=
txd.cookie);
> > > > > >=20
> > > > > > now this is critical, indeed. I would suggest using dev_WARN_ON=
CE() so
> > > > > > that it's noisy enough to catch the failing user.
> > > > > To this and upper comment, there is an explanation why it's criti=
cal. I
> > > > > guess the WARN_ONCE is not good enough, for example if we have mo=
re than
> > > > > one user making such noise.
> > > >=20
> > > > then use dev_WARN()
> > > I can't see how dev_WARN could be more useful here than the dev_crit.=
 In
> > > current message we have channel and cookie to link back to the user.
> > > What does WARN add meaningful?
> >=20
> > a dump_stack()
>=20
> How could it be useful? The dwc_handle_error is called from a tasklet
> that is called from scheduler asynchronously. The tasklet is queued in
> interrupt handler.

even if it's not useful, it's a lot more verbose and more likely to get
user's attention. If someone's passing broken DMA descriptor, it should
be a really big fat warning so we can get user reports early enoough.

Anyway, it's your call, I don't mind really.

--=20
balbi

--hxkXGo8AKqTJ+9QI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQgAs/AAoJEIaOsuA1yqRE97YP/0MDv4mZhuOmX9QDO9z4/Si5
Zs/WFfZgbgAyEW5SufLagl/PQl8rL1xV0kwhcy4BhN46iw8AJHlSWC6dvPYwLAzx
Ot0HvU1XaSsxCGHmv3E0BTGA4qBsERMSBGNDQFfcDwOcxBWJXti2EUrJFn1Jwy3O
3E4htcOkVeg3bDaUZ4qBlyHF+Wkeq2L9+MEMW1xrq1owRwPeWiPlg+j6evUVmSu0
URkSsuYr0Mt17cXQCXDDXmW1qI8UXchrIGWd8TAshVgB2cThzpOW9kYc53usQewJ
hIUN2oP7QcvY7cyAOiN3YufUKy5SncSJcmibZMlPC6HVrj1tNlSTpSF5h5jVYNUT
PUGMPPDrh0H67y+PHspj3L3zkzSW+ycEUkIIZuCJFxQXYYqeQ4gDvH6t19R9Udea
1m5BfRUKL01xHQnCZuR8DJR2JjMbToGT5+malRrTHbNvzhuzsxt2C58Yq/F5+iRe
4mN7NLEmGKmtC9WlHp/uo62nVjzWkUyAxRsgWwP+3nDxJlje6Trz9SHAEMSa+YOs
QVz20A7FotUcRa5LAuOsKnuNG1aD4UuXMQLAm9X7s55nGP9+jf6mXxiTJpa5UYhA
5kV1KuLuw0sFGgXcX/0sfBA9oH/Dt2NFMFupFuZEQ5wQlDDU6RtBXpt9JEKUge5z
1I8afRMS5xVU6Qahj4qE
=RLs9
-----END PGP SIGNATURE-----

--hxkXGo8AKqTJ+9QI--
