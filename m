Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2BQDqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 22:46:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49937 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752976Ab2BQDq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 22:46:29 -0500
Message-ID: <1329450390.3258.36.camel@deadeye>
Subject: Re: [RFC PATCH] kbuild: Build linux-tools package with 'make
 deb-pkg'
From: Ben Hutchings <ben@decadent.org.uk>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        maximilian attems <max@stro.at>, debian-kernel@lists.debian.org,
        linux-kbuild@vger.kernel.org,
        Ubuntu kernel team <kernel-team@lists.ubuntu.com>
Date: Fri, 17 Feb 2012 03:46:30 +0000
In-Reply-To: <1329448597.3258.28.camel@deadeye>
References: <1329418664-1750-1-git-send-email-joerg.roedel@amd.com>
	 <1329448597.3258.28.camel@deadeye>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-vg7fMCN0mo+VE11gg7I5"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vg7fMCN0mo+VE11gg7I5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-02-17 at 03:16 +0000, Ben Hutchings wrote:
> On Thu, 2012-02-16 at 19:57 +0100, Joerg Roedel wrote:
> > Also build a linux-tools package for installation so that
> > common tools run without issues (e.g. perf).
> >=20
> > [RFC note: This may break with x-compilation when the
> >            x-compilation environment is not set up to
> > 	   compile user-space programs. Is that acceptable?
> > 	   I also thought about a compile-time parameter
> > 	   such as 'make TOOLS=3D1 deb-pkg' or a special
> > 	   'make deb-tools-pkg' target.	Opinions? ]
> >=20
> > Cc: Michal Marek <mmarek@suse.cz>
> > Cc: maximilian attems <max@stro.at>
> > Cc: Ben Hutchings <ben@decadent.org.uk>
> > Cc: debian-kernel@lists.debian.org
> > Cc: linux-kbuild@vger.kernel.org
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  scripts/package/builddeb |   55 ++++++++++++++++++++++++++++++++++++++=
+++++++-
> >  1 files changed, 54 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> > index eee5f8e..8466380 100644
> > --- a/scripts/package/builddeb
> > +++ b/scripts/package/builddeb
> > @@ -78,17 +78,19 @@ tmpdir=3D"$objtree/debian/tmp"
> >  fwdir=3D"$objtree/debian/fwtmp"
> >  kernel_headers_dir=3D"$objtree/debian/hdrtmp"
> >  libc_headers_dir=3D"$objtree/debian/headertmp"
> > +tools_dir=3D"$objtree/debian/toolstmp"
> >  packagename=3Dlinux-image-$version
> >  fwpackagename=3Dlinux-firmware-image
> >  kernel_headers_packagename=3Dlinux-headers-$version
> >  libc_headers_packagename=3Dlinux-libc-dev
> > +tools_packagename=3Dlinux-tools-$version
>=20
> The advice I got from one of the perf developers - possibly Peter
> Zijlstra - was that changes to the perf kernel interface are backward-
> compatible but newer versions of the perf tool may depend on newer
> kernel features.  New features involve a bump to the 2nd (at the time,
> it was the 3rd) version component unless you're building from a perf
> development branch.
>=20
> So to avoid package proliferation the package name should be
> linux-tools-$VERSION.$PATCHLEVEL and the executable filenames should be
> something like perf_$VERSION.$PATCHLEVEL-$subcommand.
[...]

Sorry, the executable filename is just perf_$VERSION.$PATCHLEVEL.  Only
the manual pages for sub-commands are actually separate files.

Ben.

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-vg7fMCN0mo+VE11gg7I5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATz3Nlue/yOyVhhEJAQptqRAA1nOT0UFYbfmSCJcAaqDoBazAB2va1uHD
4KaG1E7ffkU6/J7heZSLqJBhKGKf5FDlSoZiOsrraxwLKgI6Ab7wFtkpPJ92dAs+
z8iNNGo5shuzaxo744lGI1BjSnymVSaVqHEf6KMEP/bmxnh2/QR8zibwFQxdofQV
rkvNHMgrniGAgyJZIl/kNBQ0OGEaOeq88rbgSx+wbAFdQvpjoK5RlKcdlNq7n9o2
hqT6rCeYaQluL3tk2PF5iQyBR4NLxmQAQpBGQMLuGB7JTGKcgoi4Vzdq461lQYCd
Bwx8AEmbcPFW5VcdO0RleJawrOs+G8kqnwLpw/SP29nyxXXAoMeN0uS4kSxgPlWL
HyI7hfJ0TgBI66ypXG87KtRC0Uz1at1URs65Fij4T11c34VhLdAqJnE4o/1akTcG
ZcB94oEguFs3FtdhODD0Y58jNwydIDgriD9jEOtP1z/vzjMGacnstXy3P8Rx0Q+O
3esknMT3S9Cd/gJKMV0M9DMCaTtM3EsvtXqRLn6WsXr/sWU95zRX92/lFguwEHnD
P19GxuxzXqFgOsZRbbYOQJgqghMj6RrzJLr4T+xRmtGR/CamrUWAqz41kUKgo3x2
F1TiZKPv8XxDs1TDq4ZlXb/K1rIi3p97dr+MZApklLXkVN6xD37EvtHVHkz0Y/bq
l4uuxPkMWKc=
=TdkX
-----END PGP SIGNATURE-----

--=-vg7fMCN0mo+VE11gg7I5--
