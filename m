Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2FSL56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 07:57:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39190 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721Ab2FSL54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:57:56 -0400
Message-ID: <1340107067.6871.23.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH -stable]  ntp: Correct TAI offset during leap second
From: Ben Hutchings <ben@decadent.org.uk>
To: John Stultz <johnstul@us.ibm.com>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Jonathan Nieder <jrnieder@gmail.com>, stable@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Date: Tue, 19 Jun 2012 12:57:47 +0100
In-Reply-To: <4FDF7161.5020108@us.ibm.com>
References: <4FDB8563.3030805@us.ibm.com>
	 <1339944223.4942.240.camel@deadeye.wl.decadent.org.uk>
	 <20120617164751.GJ12429@burratino>
	 <20120617173456.GA3684@netboy.at.omicron.at>
	 <1340027711.9372.29.camel@deadeye.wl.decadent.org.uk>
	 <4FDF7161.5020108@us.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-6XJAxFlRdN79EJd2Vt+P"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6XJAxFlRdN79EJd2Vt+P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-06-18 at 11:20 -0700, John Stultz wrote:
> On 06/18/2012 06:55 AM, Ben Hutchings wrote:
[...]
> >>> John, is that bug present in 3.2.y and 3.0.y, too?  Any hints for
> >>> fixing it?
> >> It looks like incrementing the TAI offset was wrong even before
> >>
> >>     6b43ae8a ntp: Fix leap-second hrtimer livelock  v3.4-rc1~44^2~9
> >>
> >> The offset should change upon entering state OOP, so something like
> >> the following (untested) patch should fix it for 3.2.9.
> > [...]
> >
> > It looks like this patch just changes the offset reported by adjtimex()
> > during an inserted second; is that right?
>=20
> Yep. It just makes sure the TAI offset is adjusted at the same point=20
> that the leapsecond is inserted (as opposed to a second late).
>=20
> >
> > Other than that, is 3.2.y likely to be OK?  Is there a good way to test
> > that in advance; does
> > <http://codemonkey.org.uk/2012/06/15/testing-leap-code/>  look
> > reasonable?
> Attached is a simple leap second test you can play with.

Thanks.  That also detects inconsistency on some runs, but I don't see
anything worse.  So I don't intend to apply any of the ntp fixes to
3.2.y.

Ben.

--=20
Ben Hutchings
If more than one person is responsible for a bug, no one is at fault.

--=-6XJAxFlRdN79EJd2Vt+P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT+BpO+e/yOyVhhEJAQoeFg//d0cBJJACF0iGvBxxPLaeYl6WWhjGlcAN
u+sxvbRweoNcrG+d85UTqls4jCVLO7mb4b228sCtJEAc73sStGe8VefdQVJjic1d
Zqqm7M6OZFIgukxpz4hAgSE8xn2t8ueRPz6ZxqFg0wywvHO3vWTpZvAIpKnDfY+d
/THWoax5Y6YAfKfc7UUnohqAncIiReD78L82ZOmyvkSfXv9jAKYngWHJQp14/u8c
NIphhrQfGpOzDyWzMbHBSalQAC73884JD6Lk4fIuMijiJq2RKRc1qQk23J/6AVWA
ysqYpeQ3ocbzmTQTMqu/xTPQ4awglxm1cjbHxVVHpS+csc7/iPzJTQ5GngvJfYyK
E0NiUpHGjoQrIGNRumPcR2Yq48yw4K35MdANgzedSmi2niPADFOtmVtDPd6/tOQg
CSPqu/tT5fgTYjy+To4p4wlBDOJuN2rW3hCsLoMAlf+T+bUbejOTHXnwyvXukg0D
AfyXG/t6s3gJFb5bzylWydOP4oMWuDWQn5FFA9ECGRICZmGuB+T6g3qK1hVoRuV2
y7d/lv+Ttc5QAlKQqPRctpbjQfKmb7jWWP4F00upk301+481AkBj4HO8X+XYbOVv
DzWqWYVqo6pc1mpVwwzviIsu4JSKwPfoKMvyESijBubCEaA2SeCK/hBRVuRtr5uJ
SB6i49UPId4=
=DXpC
-----END PGP SIGNATURE-----

--=-6XJAxFlRdN79EJd2Vt+P--
