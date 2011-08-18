Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab1HRIHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 04:07:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:24342 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab1HRIHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 04:07:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,243,1312182000"; 
   d="asc'?scan'208";a="39737204"
Subject: Re: [PATCH] checkpatch: do not test/warn of leading whitespace
 before signature tags
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Joe Perches <joe@perches.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        Anish Kumar <anish198519851985@gmail.com>,
        Andy Whitcroft <apw@canonical.com>
Date: Thu, 18 Aug 2011 01:07:08 -0700
In-Reply-To: <1313654341.32547.62.camel@Joe-Laptop>
References: <1313650112-17287-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <1313652390.32547.53.camel@Joe-Laptop>
	 <1313653632.2128.88.camel@jtkirshe-mobl>
	 <1313654341.32547.62.camel@Joe-Laptop>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-0TTGqNtaqP/xiYhYjO7B"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Message-ID: <1313654829.2128.94.camel@jtkirshe-mobl>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0TTGqNtaqP/xiYhYjO7B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-08-18 at 00:59 -0700, Joe Perches wrote:
> On Thu, 2011-08-18 at 00:47 -0700, Jeff Kirsher wrote:
> > On Thu, 2011-08-18 at 00:26 -0700, Joe Perches wrote:
> > > On Wed, 2011-08-17 at 23:48 -0700, Jeff Kirsher wrote:
> > > > From: Bruce Allan <bruce.w.allan@intel.com>
> > > >=20
> > > > Commit 2011247 introduced additional style checks for signature tag=
s in
> > > > patches which is good.  Unfortunately, now whenever patches are che=
cked
> > > > by piping the output of 'git show' or 'stg show' through checkpatch=
 it
> > > > warns not to use whitespace before all signature tags since these (=
and the
> > > > rest of the patch description) are indented.  Remove this test/warn=
ing.
> > >=20
> > > I think this is not a good idea.
> > >=20
> > > checkpatch is meant for patches not git log output.
> > > indenting signatures can cause other problems later.
> > >=20
> > > I think you can avoid this easily by using checkpatch
> > > option --ignore=3DBAD_SIGN_OFF when using git log output
> > > as input.
> >=20
> > The problem I have with this is that the sign-off's are not bad, they
> > are by default indented by 'git show' or 'stg show' so checkpatch.pl
> > should handle the "default" formatting of git/stg and if there is
> > additional indenting not expected, then the sign-off's should be
> > considered bad.
>=20
> I disagree.
>=20
> checkpatch should handle the default input of patches
> as best it can.
>=20
> I suppose checkpatch could have a different "--input=3Dgit"
> or some such to avoid certain things that git might produce
> that a patch would not.

That does sound an alternative which would be acceptable.

>=20
> Deleting useful checks for patches isn't a good idea.
>=20
> > If this option is added, then if there were "real"
> > problems with the sign-off, it would not be displayed.
>=20
> So what?
>=20
> It would also be too late to do anything about
> it anyway as it would already be committed.

If you are running it on patches already committed to maintainers tree,
but if you are running checkpatch.pl on a patch on your local tree
before you send it out, you can correct any changes necessary.=20

>=20
> > > You could also use:=20
> > > git log --format=3D"commit %H%nAuthor: %an <%ae>%nDate:   %aD%n%n%s%n=
%n%b"
> > > so that you get the current default --format=3Dmedium
> > > output without indenting the commit log body.
> > Even doing this does not resolve the "false" warnings" that
> > checkpatch.pl produces regarding the sign-off's.
>=20
> I tried it.  It works for me.
> What about it doesn't work for you?
>=20

I did the following using David Miller's net-next tree...

git log -1 > ../test.patch
./scripts/checkpatch.pl ../test.patch

and I get the following:
WARNING: Do not use whitespace before Signed-off-by:
#9:=20
    Signed-off-by: Robin Holt <holt@sgi.com>

WARNING: Do not use whitespace before Acked-by:
#10:=20
    Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>,

WARNING: Do not use whitespace before Acked-by:
#11:=20
    Acked-by: Wolfgang Grandegger <wg@grandegger.com>,

WARNING: Do not use whitespace before Cc:
#12:=20
    Cc: U Bhaskar-B22300 <B22300@freescale.com>

WARNING: Do not use whitespace before Cc:
#13:=20
    Cc: socketcan-core@lists.berlios.de,

WARNING: Do not use whitespace before Cc:
#14:=20
    Cc: netdev@vger.kernel.org,

WARNING: Do not use whitespace before Cc:
#15:=20
    Cc: PPC list <linuxppc-dev@lists.ozlabs.org>

WARNING: Do not use whitespace before Cc:
#16:=20
    Cc: Kumar Gala <galak@kernel.crashing.org>

WARNING: Do not use whitespace before Signed-off-by:
#17:=20
    Signed-off-by: David S. Miller <davem@davemloft.net>

ERROR: Does not appear to be a unified-diff format patch

total: 1 errors, 9 warnings, 0 lines checked

../test.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.



--=-0TTGqNtaqP/xiYhYjO7B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJOTMgsAAoJECTsCADr/EWUkgYIAJrZaEm/gOw/4Rlr9UMpwVIw
8K0iAU4E6oyAiDYBcf9RUWGy8gmR6adzANOQQVf1Yfj/0pJaNxrlc7yrHXHTl3CX
czWtSA0ghAMxN+f8rmuI25LZrYm7EdNgS/rHUIdvmIjkGMgVNnzIZdAzoafZ0YfY
HUxtqaQmKvwgyrGtUR+/MA29dGTrhzv0Bv025MZgyZXcNVolZqRCIPCrJWse7nGp
/IbfAjlDiAPUq2F0OAJfUMJgYq2pTvgP1Tgbp5ZD5ztz0Mcasi3bd0L3eHBS70RN
Vy0xph7dd6ZUduPSM/Lh5rQVB4W/npjn5aUpVWwp0NA+HfRPepoGQMl6aJakX6I=
=Nm8r
-----END PGP SIGNATURE-----

--=-0TTGqNtaqP/xiYhYjO7B--

