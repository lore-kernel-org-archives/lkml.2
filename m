Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab2KYOZG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 09:25:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51917 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712Ab2KYOZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 09:25:03 -0500
Message-ID: <1353853489.4266.1.camel@deadeye.wl.decadent.org.uk>
Subject: Re: kmemleak report on isp1763 and sierra MC8705
From: Ben Hutchings <ben@decadent.org.uk>
To: Richard Retanubun <richardretanubun@ruggedcom.com>,
        Johan Hovold <jhovold@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Tang Nguyen <TangNguyen@ruggedcom.com>,
        linux-usb mailing list <linux-usb@vger.kernel.org>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 25 Nov 2012 15:24:49 +0100
In-Reply-To: <20121121011544.GA5381@kroah.com>
References: <Pine.LNX.4.44L0.1210291806360.31151-100000@netrider.rowland.org>
	 <509D804A.7080807@ruggedcom.com>
	 <CAMgPeKUPeJSKas2VOqbG+Nt5MOtdA3jUUCsFwUcDVhwDJJCr6A@mail.gmail.com>
	 <50A3D0E1.4060209@ruggedcom.com> <20121114175218.GA2912@localhost>
	 <20121121011544.GA5381@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-I+GAmT5iZJ7ZJlmc094q"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 163.5.223.200
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-I+GAmT5iZJ7ZJlmc094q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-11-20 at 17:15 -0800, Greg Kroah-Hartman wrote:
> On Wed, Nov 14, 2012 at 06:52:18PM +0100, Johan Hovold wrote:
> > On Wed, Nov 14, 2012 at 12:12:01PM -0500, Richard Retanubun wrote:
> > > On 10/11/12 09:30 AM, Johan Hovold wrote:
> > > Hi Johan,
> > >=20
> > > > There was a reference-count fix for the probe error path that went =
in to
> > > > v3.5. Haven't read all the details on how you trigger your leak, bu=
t at
> > > > the face of it, it could be related.
> > > >
> > > > Have a look at 0658a3366db7e27fa ("usb: use usb_serial_put in
> > > > usb_serial_probe errors). If related, you should be seeing "Ignorin=
g
> > > > blacklisted interface #n" messages when you enable debug (e.g. #def=
ine
> > > > DEBUG) in the sierra driver.
> > >=20
> > > That was it! Thanks so much for the research.
> > > I can apply it cleanly to 3.0.22 and see usb_release_dev() being
> > > called and thus no more kmemleak.
> > >=20
> > > >
> > > > Greg, it seems to me that the fix referred to above should be backp=
orted
> > > > to the earlier stable trees either way.
> > > I would vote "yes" for this also.
> > >=20
> > > While my setup circumstances may be a corner case, (modem kept
> > > resetting to re-establish PPP connection) it was leaking 1192 bytes
> > > per occurrence.
> >=20
> > The leak affects every failed probe, for example due to blacklisted
> > interfaces which is quite common, so commit 0658a3366db7 ("usb: use
> > usb_serial_put in usb_serial_probe errors) should be backported to the
> > <=3D 3.4 stable trees.
>=20
> Thanks, now applied.

Also queued up for 3.2.

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-I+GAmT5iZJ7ZJlmc094q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULIqMee/yOyVhhEJAQpKlw/+OOjr2lt+WLTJ9q7orzrNddVNhfWRcbZR
b3UWEJe9jj+hJfUdKUzeD3j1W0YXFKqjisMTqveWYwIYOBNTxPcySpfHC0S+Yd/g
mbUBwXzhO0PsKeFUcwhoEC+iSfkYmOc9eQOeEVb/X2MHDZrU/EBWA/EZffdMdRBD
ry23kT2ZFmCvhorTNk/sjyhjOYIUVX0gdx+cKmpwTgDtIMwVz0+DUtJTo3SKWcuV
W7tDL0uXNd/QvtfTCHjjahXIhlHR7rO/ZPwtC0ZzXRsCU767XCKGGgwfRPCDKceB
K2ew7weuKMCYScp7cVQ1GJqXqJLDD+KkrsoR0BQb0qCH/UfqygxqQmgJhZT9meLT
iSixV8DEC9dn8lRS8BqMym0wvNZMqctySrqXqreGgSJE7fd0FncLofGg2DAo4uWW
t2QInjBGmpWWcjcR1Uk4kB8PmY2JoM72XixMLy5LvB4Vl02lunS7IGqENpSpUxEu
ZOR2pXfMb/Q6mHcut/sxXiNEw3ckgAydFig8qYdURffNWJCv8z0xFX+Hj4LJehjR
Q9fiCoKM4nA6JMRdJChUnsRdQVDTyLQjgUDjfkjxMZhrtXepEjdTqcOYBh77DnGk
wAAliqojktFDbidfLA1ge5zaF0BWYBwi7LwTQSMeHbPCRMAQkWmc5gJKo9wu20eO
O1ev/6woiPo=
=Gooh
-----END PGP SIGNATURE-----

--=-I+GAmT5iZJ7ZJlmc094q--
