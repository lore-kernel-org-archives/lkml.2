Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab2FRNza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 09:55:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58560 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751113Ab2FRNz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 09:55:28 -0400
Message-ID: <1340027711.9372.29.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH -stable]  ntp: Correct TAI offset during leap second
From: Ben Hutchings <ben@decadent.org.uk>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, John Stultz <johnstul@us.ibm.com>,
        stable@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Date: Mon, 18 Jun 2012 14:55:11 +0100
In-Reply-To: <20120617173456.GA3684@netboy.at.omicron.at>
References: <4FDB8563.3030805@us.ibm.com>
	 <1339944223.4942.240.camel@deadeye.wl.decadent.org.uk>
	 <20120617164751.GJ12429@burratino>
	 <20120617173456.GA3684@netboy.at.omicron.at>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-8j1trFCz33dvkHiryLuU"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8j1trFCz33dvkHiryLuU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-06-17 at 19:34 +0200, Richard Cochran wrote:
> On Sun, Jun 17, 2012 at 11:47:51AM -0500, Jonathan Nieder wrote:
> > Ben Hutchings wrote:
> > > On Fri, 2012-06-15 at 11:56 -0700, John Stultz wrote:
> >=20
> > >> commit dd48d708ff3e917f6d6b6c2b696c3f18c019feed upstream.
> > [...]
> > > This doesn't apply to 3.2.y, unsurprisingly.  Let me know if there ar=
e
> > > any urgent leap second fixes that will be needed there.
> >=20
> > 6b43ae8a619d (ntp: Fix leap-second hrtimer livelock) sounds important,
> > but the patch depends on bd3312681f69 (ntp: Add ntp_lock to replace
> > xtime_locking) which does not have a commit message explaining its
> > purpose (and that patch in turn depends on ea7cf49a7633).

If I understand the commit message for 6b43ae8a619d correctly, the
livelock results from ntp_lock and xtime_lock being acquired in opposite
orders in two threads.  Which means it wasn't possible before ntp_lock
was introduced in bd3312681f69.

> > John, is that bug present in 3.2.y and 3.0.y, too?  Any hints for
> > fixing it?
>=20
> It looks like incrementing the TAI offset was wrong even before=20
>=20
>    6b43ae8a ntp: Fix leap-second hrtimer livelock  v3.4-rc1~44^2~9
>=20
> The offset should change upon entering state OOP, so something like
> the following (untested) patch should fix it for 3.2.9.
[...]

It looks like this patch just changes the offset reported by adjtimex()
during an inserted second; is that right?

Other than that, is 3.2.y likely to be OK?  Is there a good way to test
that in advance; does
<http://codemonkey.org.uk/2012/06/15/testing-leap-code/> look
reasonable?

Ben.

--=20
Ben Hutchings
If more than one person is responsible for a bug, no one is at fault.

--=-8j1trFCz33dvkHiryLuU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT98zP+e/yOyVhhEJAQr+IA/+Nw8gBBNSzKbKJfwb/gGSh+hoIujakaLA
/P9h4tFk/P1d+sxa6YIgSOqE9NfMLHjgwbJq0eUQYLMRYiDfCoB7GBMB40ZkayRR
ouaWnrD0zciEpodHd2kzd74vkJmuozPO/aUsGH9DBONjVCUx+5fitMVscHqviSZg
d65sfPfglWxgFbM4K470KEmswo+lVi37bA7/tZAtmiepkGHnCjQgip+/v54ZtZZp
voIQgIES40Wu36o/J1Nfc5cVpGGy94+l9TuhwyqI+HxjAZKmbaw6nZMJSGUer1sA
2zmlDcm1L/DDQEAEAs9dr12XsU49ayXbLfrINBZvSBgHefQfpD7hjZeXWxygugs5
PHtoC+78R9EastUgPs+8nzJTrbop8iOCNANJXZrRnUAkQb3CHOo+4jjmFBNrXjO3
TCOdd358UOwQWFTmjeCl1XGmlKFxH3YiHnkTT51yDq9jOZrDGvNsm3KFd3wb6Uzw
9NMnmn6HR9IUnNabJmrJ3LJPcId+2uDppmc1mHY7tacirQusmR72fJs9cS5Jy3pa
tUJgqQ9CyxwN2PD+Owc2/f5P3WUB0mBuyopa5RaUAmfzWFn/dQoqX/6GzWkzy3SU
yELumf2Un4ZL3y6rw6WuG7pFMFFB9J6Ps+Hr2Eq4+dvfDTFxUcP59F4Irp6OUuU2
sVJmqQWwZlk=
=NZqQ
-----END PGP SIGNATURE-----

--=-8j1trFCz33dvkHiryLuU--
