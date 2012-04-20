Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab2DTUh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 16:37:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54894 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab2DTUh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 16:37:27 -0400
Date: Fri, 20 Apr 2012 22:37:12 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 2/3] i2c-eg20t: Call init() when wait-event timeout occurs
Message-ID: <20120420203712.GA12691@pengutronix.de>
References: <1332741325-7746-1-git-send-email-tomoya.rohm@gmail.com>
 <1332741325-7746-2-git-send-email-tomoya.rohm@gmail.com>
 <20120418150544.GE19802@pengutronix.de>
 <CANKRQng5nb0nU_e1o6TLnvOwPoXX1C_bJguNyjrsVfo+mubKaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <CANKRQng5nb0nU_e1o6TLnvOwPoXX1C_bJguNyjrsVfo+mubKaw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 19, 2012 at 03:19:14PM +0900, Tomoya MORINAGA wrote:
> On Thu, Apr 19, 2012 at 12:05 AM, Wolfram Sang <w.sang@pengutronix.de> wr=
ote:
> > On Mon, Mar 26, 2012 at 02:55:24PM +0900, Tomoya MORINAGA wrote:
> >>
> >> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
> >
> > Woha, that's copy&paste code all over. May I ask to refactor this?
> > Something like:
> >
> > =A0 =A0 =A0 =A0rtn =3D pch_..._wait_for_checked_xfer();
> > =A0 =A0 =A0 =A0if (rtn)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rtn;
> > =A0 =A0 =A0 =A0// All the things you have to do when rtn =3D=3D 0
> >
> > in that new function (the name was only a suugestion), you can do all
> > the checks which are now copy-pasted, e.g.:
> >
> > =A0458 =A0 =A0 =A0 =A0 rtn =3D pch_i2c_wait_for_xfer_complete(adap);
> > =A0459 =A0 =A0 =A0 =A0 if (rtn =3D=3D 0) {
> > =A0460 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pch_i2c_getack(adap)) {
> > =A0461 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pch_dbg(adap, "R=
eceive NACK for slave address"
> > =A0462 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
"setting\n");
> > =A0463 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> > =A0464 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > =A0465 =A0 =A0 =A0 =A0 } else if (rtn =3D=3D -EIO) { /* Arbitration Los=
t */
> > =A0466 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pch_err(adap, "Lost Arbitration\=
n");
> > =A0467 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pch_clrbit(adap->pch_base_addres=
s, PCH_I2CSR, I2CMAL_BIT);
> > =A0468 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pch_clrbit(adap->pch_base_addres=
s, PCH_I2CSR, I2CMIF_BIT);
> > =A0469 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pch_i2c_init(adap);
> > =A0470 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EAGAIN;
> > =A0471 =A0 =A0 =A0 =A0 } else { /* wait-event timeout */
> > =A0472 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pch_i2c_stop(adap);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 // Your current fixes added here
> > =A0473 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ETIME;
> > =A0474 =A0 =A0 =A0 =A0 }
> > =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> >
> > It is only pseudo-code, but I think it can be done and will help the dr=
iver.
> >
>=20
> OK.
> I'm ready to submit new patch you are saying.

Applied to next, thanks to the follow up patches :)

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+RyPgACgkQD27XaX1/VRvuUACgkfCGye5aI8RRzx2M2/3d3ufl
1o4An1XPt0XuVN/2YIuHbDBLQRqNz29n
=Nfal
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
