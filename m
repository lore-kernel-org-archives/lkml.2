Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab2EOKZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 06:25:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:35061 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab2EOKZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 06:25:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="144161782"
Message-ID: <1337077753.2528.150.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v4] Add security.* XATTR support for the UBIFS
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Subodh Nijsure <snijsure@grid-net.com>
Cc: linux-mtd@lists.infradead.org, penguin-kernel@I-love.SAKURA.ne.jp,
        Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Date: Tue, 15 May 2012 13:29:13 +0300
In-Reply-To: <4FB17474.90808@grid-net.com>
References: <1336915488-23943-1-git-send-email-snijsure@grid-net.com>
	 <1337000538.2528.50.camel@sauron.fi.intel.com>
	 <4FB17474.90808@grid-net.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-y+6Yx0YbZ2gpvZxeQUWh"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-y+6Yx0YbZ2gpvZxeQUWh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-05-14 at 14:09 -0700, Subodh Nijsure wrote:
> On 05/14/2012 06:02 AM, Artem Bityutskiy wrote:
> > On Sun, 2012-05-13 at 06:24 -0700, snijsure@grid-net.com wrote:
> >> +int ubifs_security_getxattr(struct dentry *d, const char *name,
> >> +			    void *buffer, size_t size, int flags)
> >> +{
> >> +	if (strcmp(name, "") =3D=3D 0)
> >> +		return -EINVAL;
> >> +	return __ubifs_getxattr(d->d_inode, name, buffer, size);
> >> +}
> >> +
> >> +
> >> +int ubifs_security_setxattr(struct dentry *d, const char *name,
> >> +			    const void *value, size_t size,
> >> +			    int flags, int handler_flags)
> >> +{
> >> +	if (strcmp(name, "") =3D=3D 0)
> >> +		return -EINVAL;
> > Should this check pushed town to __ubifs_getxattr/__ubifs_setxattr ?
> If you really want to move that check into __ubifs_get/setxattr we can=
=20
> do that.

Yes, if other FSes have this check - please add it there.

> However the above implementation is consistent with ext2/ext3/ext4/jffs=
=20
> implementation.

OK, but on the other hand - how much sense does it make to have these
trivial wrappers? Should we have a wrapper per-check? :-)

BTW, to they have to be non-static?

> > Does an extended attribute in general with zero name length legitimate?
> My preference would be to remain consistent with interpretation of other=
=20
> file systems, in terms of what constitutes an
> invalid parameter. ext* filesystems seem to be declaring a blank=20
> extended attribute as invalid parameter. Man page for setxattr/getxattr=
=20
> don't explicitly state as such though.

Sure, let's add this check - I guess I was not careful enough and missed
it.

> > Did you check whether the generic code already performs this check?
> I didn't see a generic code that performs this check.

OK, thanks.

> >> +	for (xattr =3D xattr_array; xattr->name !=3D NULL; xattr++) {
> >> +		name =3D kmalloc(XATTR_SECURITY_PREFIX_LEN +
> >> +			       strlen(xattr->name) + 1, GFP_NOFS);
> >> +		if (!name) {
> >> +			err =3D -ENOMEM;
> >> +			break;
> > Where is the already allocated memory freed in this case?
> In this particular case kmalloc() failed and we are returning ENOMEM=20
> error, and in case of success, we do free the allocated memory.

Indeed, sorry for silly question.

> > You do not actually need these mutexes, because "inode" is new, it is
> > not added to any lists yet, so you own it entirely. Which means that yo=
u
> > do not even need to introduce this helper function - just call
> > 'security_inode_init_security()' directly.
> Okay, I can change the code to directly call the=20
> security_inode_init_security().

OK, thanks!

> It would great if someone else can run UBIFS with extended attributes=20
> enabled and provide an ACK! ;-)

I will run it once you send the patch I cannot nit-pick on anymore (aka
perfect patch) :-)))

Thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-y+6Yx0YbZ2gpvZxeQUWh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPsi/5AAoJECmIfjd9wqK0GG4QAIcMfouGK1t6xXx7hiwxKbtf
eq1Nu4ZW1wubE80CXpRDQfaOedgNfs/pQoINcl0tyh9xeiSF3CKhVUPcQQbDbr4H
giRBio7/j36+NmFvBO9lk+G0MVKs7bGXO58+1R1NtW5p1PeVlyOotlwDlQvSpcx6
CaYQShxzojavASsBR5Q3NhYQFHl36E5EWtkYq924IkM42JrJ4crOqwTKGiBhks7F
CCdZcqO6NoXVWo+jmSCNeItzzxY+i4RPmpLE6PVV2MZqY3aORqekA5TNZJTm4SNr
ZZQ54TxZ5RjIC1cMiQp3rpdg4sbEtTYynYSnJqmK4hLzzUDi+x3fquUxy0mL1+Qr
yssKfyxun3Z01gayYXv3Kv+mJsYP8Ba6flXiBeMTSsQJbmdSsVMyHkPK+QTKmHRx
emsrHKheyMLsoMfgFJbslrTdLd6yD+/XTJu4e9vHbdys/oBDj/BpU+j1UT+wI70H
twwWIoDK28dlGvEvRlz6DDV2NP5bo0Et9zurQmGmW63SKKrd/95Q8qGbedrCBuRv
qBmA/yFLzgI1vBx2kDZfjfiePrQrgGIalX9BGTwVFVZVgvhcIX+WTnJgQcXqzVgD
FkPSRPF4MZlN0vjTsAzlI0vOwsg8Dy40ES62g7PWAxmXTTLaVmD3vw4lEXlzNkzR
x+rVTGs8t/B4NwTr8wkk
=O8ij
-----END PGP SIGNATURE-----

--=-y+6Yx0YbZ2gpvZxeQUWh--

