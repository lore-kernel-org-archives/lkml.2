Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab1HRI0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 04:26:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:28285 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119Ab1HRI0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 04:26:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,244,1312182000"; 
   d="asc'?scan'208";a="8449681"
Subject: Re: [PATCH] checkpatch: do not test/warn of leading whitespace
 before signature tags
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Joe Perches <joe@perches.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        Anish Kumar <anish198519851985@gmail.com>,
        Andy Whitcroft <apw@canonical.com>
Date: Thu, 18 Aug 2011 01:26:00 -0700
In-Reply-To: <1313655365.32547.68.camel@Joe-Laptop>
References: <1313650112-17287-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <1313652390.32547.53.camel@Joe-Laptop>
	 <1313653632.2128.88.camel@jtkirshe-mobl>
	 <1313654341.32547.62.camel@Joe-Laptop>
	 <1313654829.2128.94.camel@jtkirshe-mobl>
	 <1313655365.32547.68.camel@Joe-Laptop>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-zHLp1dGFl6rUyrWx2S+u"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Message-ID: <1313655961.2128.107.camel@jtkirshe-mobl>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zHLp1dGFl6rUyrWx2S+u
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-08-18 at 01:16 -0700, Joe Perches wrote:
> On Thu, 2011-08-18 at 01:07 -0700, Jeff Kirsher wrote:
> > On Thu, 2011-08-18 at 00:59 -0700, Joe Perches wrote:
> > > On Thu, 2011-08-18 at 00:47 -0700, Jeff Kirsher wrote:
> > > > On Thu, 2011-08-18 at 00:26 -0700, Joe Perches wrote:
> > > > > On Wed, 2011-08-17 at 23:48 -0700, Jeff Kirsher wrote:
> > > > > > From: Bruce Allan <bruce.w.allan@intel.com>
> > > > > >=20
> > > > > > Commit 2011247 introduced additional style checks for signature=
 tags in
> > > > > > patches which is good.  Unfortunately, now whenever patches are=
 checked
> > > > > > by piping the output of 'git show' or 'stg show' through checkp=
atch it
> > > > > > warns not to use whitespace before all signature tags since the=
se (and the
> > > > > > rest of the patch description) are indented.  Remove this test/=
warning.
> > > > >=20
> > > > > I think this is not a good idea.
> > > > >=20
> > > > > checkpatch is meant for patches not git log output.
> > > > > indenting signatures can cause other problems later.
> > > > >=20
> > > > > I think you can avoid this easily by using checkpatch
> > > > > option --ignore=3DBAD_SIGN_OFF when using git log output
> > > > > as input.
> > > >=20
> > > > The problem I have with this is that the sign-off's are not bad, th=
ey
> > > > are by default indented by 'git show' or 'stg show' so checkpatch.p=
l
> > > > should handle the "default" formatting of git/stg and if there is
> > > > additional indenting not expected, then the sign-off's should be
> > > > considered bad.
> > >=20
> > > I disagree.
> > >=20
> > > checkpatch should handle the default input of patches
> > > as best it can.
> > >=20
> > > I suppose checkpatch could have a different "--input=3Dgit"
> > > or some such to avoid certain things that git might produce
> > > that a patch would not.
> >=20
> > That does sound an alternative which would be acceptable.
> >=20
> > >=20
> > > Deleting useful checks for patches isn't a good idea.
> > >=20
> > > > If this option is added, then if there were "real"
> > > > problems with the sign-off, it would not be displayed.
> > >=20
> > > So what?
> > >=20
> > > It would also be too late to do anything about
> > > it anyway as it would already be committed.
> >=20
> > If you are running it on patches already committed to maintainers tree,
> > but if you are running checkpatch.pl on a patch on your local tree
> > before you send it out, you can correct any changes necessary.=20
> >=20
> > >=20
> > > > > You could also use:=20
> > > > > git log --format=3D"commit %H%nAuthor: %an <%ae>%nDate:   %aD%n%n=
%s%n%n%b"
> > > > > so that you get the current default --format=3Dmedium
> > > > > output without indenting the commit log body.
> > > > Even doing this does not resolve the "false" warnings" that
> > > > checkpatch.pl produces regarding the sign-off's.
> > >=20
> > > I tried it.  It works for me.
> > > What about it doesn't work for you?
> > >=20
> >=20
> > I did the following using David Miller's net-next tree...
> >=20
> > git log -1 > ../test.patch
> > ./scripts/checkpatch.pl ../test.patch
> >=20
> > and I get the following:
> > WARNING: Do not use whitespace before Signed-off-by:
> > #9:=20
> >     Signed-off-by: Robin Holt <holt@sgi.com>
>=20
> Dull.
>=20
> You didn't do what I suggested, and you aren't
> checking the actual patch for the commit.
>=20
> Try:
>=20
> $ git log --format=3D"commit %H%nAuthor: %an <%ae>%nDate:   %aD%n%n%s%n%n=
%b" \
> 	-p -1 master | ./scripts/checkpatch.pl -
> total: 0 errors, 0 warnings, 826 lines checked
>=20
> Your patch has no obvious style problems and is ready for submission.
>=20
> (btw: checkpatch accepts input from standard input if you use a trailing =
"-")
>=20
>=20

I understand what you saying and asking, my point here is the that the
"default" style should be understood by checkpatch.pl and not produce
false warnings.

Sorry my example showed the long way of doing it, I get the same errors
if I were to simply do:

git log -1 | ./scripts/checkpatch.pl -


--=-zHLp1dGFl6rUyrWx2S+u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJOTMyYAAoJECTsCADr/EWUULoH/1e3ong+CTTEUiu8abG41oDn
pAozWFLVj7ypb/XDdVqWXjt9ITc4wAek1tlmsKWPSUNcbvZX2NQvOty9f6mM1g2G
/tcOJ/fpD+mOU+KkCEzWsXq3cCWpvr3LpBUV8X3/CGoqKfu9EvoOhVctlUSFgE4O
tN1/6jnm7IjfZEJ49zUbHZdnB7aKP44HLTafDGDuae6jLW2Z98gbB7uH4TlV8Cgb
CNjKVbYIsJOGjTIpzMb7jSpnf2uKbdrQtywpUcZDahCMwb8PKU7R5JuddidrenK4
0MfQJppKDwdl8N4rmhG9ew+GmTWKs5Y4KYoL/2AyAa1bKFslKbM1jOri69XIQeM=
=KqDX
-----END PGP SIGNATURE-----

--=-zHLp1dGFl6rUyrWx2S+u--

