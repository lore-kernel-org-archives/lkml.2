Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab2KNKvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:51:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60441 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932836Ab2KNKv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:51:29 -0500
Date: Wed, 14 Nov 2012 19:51:08 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: arizona: Move chip reset to before register patch
Message-ID: <20121114105106.GK7407@opensource.wolfsonmicro.com>
References: <20121112175648.GA29044@opensource.wolfsonmicro.com>
 <20121113055618.GC18224@opensource.wolfsonmicro.com>
 <20121113131219.GA29198@opensource.wolfsonmicro.com>
 <20121114012007.GD4415@opensource.wolfsonmicro.com>
 <20121114104854.GB23525@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Tv3+oRj6D9L8lW+H"
Content-Disposition: inline
In-Reply-To: <20121114104854.GB23525@opensource.wolfsonmicro.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Tv3+oRj6D9L8lW+H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 14, 2012 at 10:48:54AM +0000, Charles Keepax wrote:
> On Wed, Nov 14, 2012 at 10:20:09AM +0900, Mark Brown wrote:

> > Just do a sync, make sure that we mark the map as dirty when we do the
> > reset via register write and it'll not have any effect anyway.  We
> > should also check if we've got the LDO and use that for reset too
> > actually...

> The way the code is layed out at the moment if we don't
> successfully get the LDO we won't get as far as the register
> write reset. Meaning that if we can do the reset by cycling the
> power on the LDO is there any point in having the option to do
> the reset via a register write later?

No, we can't rely on having control over the LDO - it might be always
on.  But we should ideally try to use it as a fallback, using a notifier
to find out if that worked or not.

--Tv3+oRj6D9L8lW+H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQo3eUAAoJELSic+t+oim9lOoQAJSH1fK/8c3VBvOOgEYQDfww
+siWRfjtWTnum8rIcF/sAmYAMkF0DjlF8eU4WSRsaPZ2m4YTfKruyQC7jogNSHoo
f0ChstaENwbqR0yvQdVZb/hyjrkNifLH/dn3qReWKA/Ej58hRtP2Vd/HTY+UM6gC
Qo0sNaCRBBD7NK+mrCqXyeRlZ7PXH1aNGArX+sQjOxHo3n2dHlwSiivTY65puEa4
jN+v/m6QyMmzBdr5xsM63zpFBvjne48UsQ+3t1bapD77dqsVYE2QjPNDO6OYacG1
iZkFUGUM2dJpfyxqhpjcDc8xFYcpfx1Y6/3CDZKBhuV011rNwogEhDrBzScD72kR
0NOX92QalaqVUJsCy6qyjP4DwNPu8p3B3akU7jT/ztHHfJoZp4Wz5XmiWLrXz2Tv
jScwVLpPRZyA36oOgZIXQwtTJLuUygjmZQ9PS88/ccn0ZnsR8fANZcBKB8y35bv8
XF4ZkJWtbxCrV3L579WAr2XPxAGkTa3rVddlgM4apeBJjZYTw9aXKcUUj5sZGT65
1vD4gbU0OiQb7KXCVUKfJiF6WW+75UyFaUydNnsQ6bfPF55yg9NLRQoDYi2+rkPA
GZ6kihNdwp8ZpeNm5WKuuhPmoYDYqWOp3NUq9O2C+Og/r4+uJvSCdPPdTqf9OIxn
VE3fk/8fy/MwygeCH/Kb
=IIX2
-----END PGP SIGNATURE-----

--Tv3+oRj6D9L8lW+H--
