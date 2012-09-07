Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958Ab2IGCzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 22:55:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52413 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597Ab2IGCzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 22:55:18 -0400
Message-ID: <1346986512.17321.42.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 16/32] ext4: make sure the journal sb is written in
 ext4_clear_journal_err()
From: Ben Hutchings <ben@decadent.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 07 Sep 2012 03:55:12 +0100
In-Reply-To: <20120820035650.114172576@linuxfoundation.org>
References: <20120820035647.862247088@linuxfoundation.org>
	 <20120820035650.114172576@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-5I3+UCm2MKsh/WtRpC/6"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5I3+UCm2MKsh/WtRpC/6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-08-19 at 20:57 -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>=20
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Theodore Ts'o <tytso@mit.edu>
>=20
> commit d796c52ef0b71a988364f6109aeb63d79c5b116b upstream.
>=20
> After we transfer set the EXT4_ERROR_FS bit in the file system
> superblock, it's not enough to call jbd2_journal_clear_err() to clear
> the error indication from journal superblock --- we need to call
> jbd2_journal_update_sb_errno() as well.  Otherwise, when the root file
> system is mounted read-only, the journal is replayed, and the error
> indicator is transferred to the superblock --- but the s_errno field
> in the jbd2 superblock is left set (since although we cleared it in
> memory, we never flushed it out to disk).
>=20
> This can end up confusing e2fsck.  We should make e2fsck more robust
> in this case, but the kernel shouldn't be leaving things in this
> confused state, either.
[...]

Is this needed for 3.2?  It looked like it depended on
24bcc89c7e7c64982e6192b4952a0a92379fc341 which is strictly too big a
change for a stable series.  But perhaps there's a way to avoid that
dependency.

Ben.

--=20
Ben Hutchings
Usenet is essentially a HUGE group of people passing notes in class.
                      - Rachel Kadel, `A Quick Guide to Newsgroup Etiquette=
'

--=-5I3+UCm2MKsh/WtRpC/6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUEliEOe/yOyVhhEJAQr+OA/+OPvJb8IxrFl/OuLM0+eEaUEXUsUvcrVZ
E0yQGlL5gcErbWfnT5wKGHogZpxwkErI1PYjq0GYyNp3hpT57OF2M/TNCGqfOOl4
6qozqB9KGC3nrxiqZVN9hPmfmxTAv+V3zsvO1exvKK6uYtcUEtjPGW2DZHspSNIt
ln6POmKDp9C31P/5s6UH0RqZRSNbKk7Ue7MKnrk3LFK7mirvXNZvpqkga1QoOs8C
spXE1pqZ5QFisIWqxi3WuSLhA96nTw+Nn9WFC/7lGq7sW8idAKD/0Jy2gcE6/mfq
X5lsxQJNqRDFxKwHb6VDTNw+n1uocPDPm+lHFQc1DuyyDMupsBnHKFZ/CrXz0KEO
FamUS8/DZvusmZ0nzHCdY287LviqrwXtRyQrPoqS9XJMwHzDQTpPe6HJcgQWZLkb
S84M2vYoY4A54/6rzWbhbXGRA7C3jUK8/sSCLX45yQEvrHviPfuPzwpb1Yfo5VQ8
rbM5brzxZMD/DI9TFz1XaMrZ/NEky7ZUH0cyBrpoDQPjUWP2p57umDxb84iTn4xH
zXmmccpzy9r6QEuzbhaZAwkP++BKJd/oxOQPxx28p4zt3CTa7SKNBGaHsROnBWX3
qpS8x6lqguO2Tassp4nTxowGO5ZD9Ke/LEif5b4L69/xQbh70riaXpKG3rWcYETu
5FcdWTdjytg=
=rnAF
-----END PGP SIGNATURE-----

--=-5I3+UCm2MKsh/WtRpC/6--
