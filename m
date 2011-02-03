Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab1BCKWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 05:22:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55548 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab1BCKWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 05:22:21 -0500
Date: Thu, 3 Feb 2011 11:22:19 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: rename_rev.pl script for reviewing renames
Message-ID: <20110203102219.GB6508@pengutronix.de>
References: <20110203100828.GO20606@bicker>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFHRwCdBEJvubb2X"
Content-Disposition: inline
In-Reply-To: <20110203100828.GO20606@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UFHRwCdBEJvubb2X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 03, 2011 at 01:08:28PM +0300, Dan Carpenter wrote:
> There are a lot of refactoring patches where people change camel case
> names to kernel style names etc.  I've written a script to make it
> easier to review them.  It's attached.

Cool, thanks for sharing. I guess my comments won't matter much, here
they are anyway :)

> sub usage() {
>     print "cat diff | transform.pl old new old new old new...\n";

Filename of the tool does not match.

>     # white space at the end of lines
>     $line =3D~ s/ *$//g;
>     $line =3D~ s/\t*$//g;

Character class here as well? Will also get mixtures of the two.

> while (<>) {
>     my $line =3D $_;

You could work here with plain $_, but I assume you don't do on purpose.

>=20
>     if ($line =3D~ /^---/) {
> 	next;
>     }
>     if ($line =3D~ /^\+\+\+/) {
> 	next;
>     }

Use an alternation in the regexp?

>     my $output =3D filter($line);
>     if ($line =3D~ /^-/) {
> 	print $oldfh $output;
> 	next;
>     }
>     if ($line =3D~ /^\+/) {
> 	print $newfh $output;
> 	next;
>     }

Ditto.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--UFHRwCdBEJvubb2X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1KgdsACgkQD27XaX1/VRubWgCgnY8xBrCS1X/0No5fmsxymVxv
u44AoLZ2vVLR2H1yFhLXfT4dRKK3FHHo
=SFwk
-----END PGP SIGNATURE-----

--UFHRwCdBEJvubb2X--
