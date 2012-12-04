Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab2LDVcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 16:32:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51439 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab2LDVcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 16:32:03 -0500
Date: Tue, 4 Dec 2012 22:31:53 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
Message-ID: <20121204213153.GA20784@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com>
 <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de>
 <50B73710.2040102@nvidia.com>
 <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de>
 <50B874C7.5030208@nvidia.com>
 <20121130103850.GA28367@avionic-0098.adnet.avionic-design.de>
 <50B9EA76.10803@nvidia.com>
 <20121201145814.GB18209@avionic-0098.adnet.avionic-design.de>
 <50BCFC34.5030203@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <50BCFC34.5030203@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:VZrAz9P7HUVLoarTrO1GqjTT8GhLngC3EvAN40ukYf2
 gfO34hLPwvj8A8xrA8FbtFVy2Ot2k57or0VijbPk/6lbAkcxJU
 Tl3vnPpYwGYfJ+2NEK7mDrN3H/nczQ8MFr919lbXPKbvxLrbm6
 d6WVFyV7+yIrAz2oFeY2JRkY1+9qkqvZQFcDcv3WVhC1hURJBH
 dRUrbzdc+OtlBTAVauc05KzGm5y3G/vNVKOGrEpwcjA65Dj3+I
 i1Zc4BhOtQa1OjNwcL1YNtACOsbVGarGv7Jj4pqld9Ug2f4dt3
 7S0qilwx1MYG37hQhZtP8JrncSXFb37d5LcD23NuZo1P8CddEc
 CCOrw0avb4BsafFum6DwBSM8yIqasHzH0YR1N+WCNcMnQbOxUT
 hr9wdu6UO6bL/6rACu3ydj05IrTVVtTrpQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 03, 2012 at 12:23:32PM -0700, Stephen Warren wrote:
> On 12/01/2012 07:58 AM, Thierry Reding wrote:
> > On Sat, Dec 01, 2012 at 01:31:02PM +0200, Terje Bergstr=C3=B6m wrote:
> ...
> >> I was thinking of definitions like this:
> >>=20
> >> static inline u32 host1x_sync_cfpeek_ctrl_cfpeek_addr_f(u32 v) {=20
> >> return (v & 0x1ff) << 0; }
> >>=20
> >> versus
> >>=20
> >> #define host1x_sync_cfpeek_ctrl_cfpeek_addr_f(v) ((v) >> 16) &
> >> 0x3ff
> >>=20
> >> Both of these produce the same machine code and have same usage,
> >> but the latter has type checking and code coverage analysis and
> >> the former is (in my eyes) clearer. In both of these cases the
> >> usage is like this:
> >>=20
> >> writel(host1x_sync_cfpeek_ctrl_cfpeek_ena_f(1) |
> >> host1x_sync_cfpeek_ctrl_cfpeek_channr_f(chid) |
> >> host1x_sync_cfpeek_ctrl_cfpeek_addr_f(rd_ptr), m->sync_aperture +
> >> host1x_sync_cfpeek_ctrl_r());
> >=20
> > Again there's no precedent for doing this with static inline
> > functions. You can do the same with macros. Type checking isn't an
> > issue in these cases since we're talking about bitfields for which
> > no proper type exists.
>=20
> I suspect the inline functions could encode signed-vs-unsigned fields,
> perhaps catch u8 variables when they should have been u32, etc.?

I don't see how this would be relevant here. These definitions are only
used in the driver internally and not a public API, therefore none of
those checks should really be needed. If somebody writes code for this
driver and uses the register definitions, they better know what they're
doing. Or at least wrong usage should be filtered out through review.

In my opinion the consistency with how other drivers are written far
outweigh the benefits provided by inline functions. That said, I'm out
of arguments and I don't have a final say anyway, so if it is decided
to stick with inline functions I can find a way to live with them.

Thierry

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQvmvJAAoJEN0jrNd/PrOh6QYP/2cFfxZmifZ9aG6E7vHYhSVk
PKTY5rPlstqzcxGCS/D6IsFUx36RdhGOV1QqJr4/iLtGWL4zHSh0JH7fgGjNgxFb
8Dbqo4BI11tuXO3R2ugI+HCnFaRV/EaXziYq/bvrJLKBH+5B6TNI3m682ypzQMq1
4rmsPZH7CiDU6AGURRl8kwrzC+g+cZ2NDRfeKYR/PEODHb0fSycx0OGDoPzXMJMb
UrbK342//kd4o6VFdsPKxPGve2hmne1ueu5jXimhmOq8KtpqELugEXkItmVZAA6w
KCAaOg0q+cg3AG9fjKc9EJAhgdRkmVj4E9Ah7UNho/mf47F7TDNQEQGvHoeVF9qy
48SwylIXZPyNraIlX6LgdcGYqkt93YBG+CE/8VjdNt62BNd3ra/2AcPAzVOjdcsO
My1S3EuRkIppTHW8/8GZA6Ece20JhbLHNVTwsmYtH4PpS8QyeE+B9FGSP7AUbsSp
yp/rn5/yTgKjA4dELoUBLoRWF3B8620toX3lmRb4ZHVDyh9b0QeqiFndjPjB0nWs
nIqCGccYrd0WScXFzAOXqzKeS7KipQeaEPMJ0LJi0K8baTjGKod9pR/VAuH6ItH8
OG6+XmHCNSZkYue0dfLfrykS02Rsgjcgi5P72xqP1tuqCN5/mCqEQePnLNOHESn4
zk7v52ATRdrQhpnTo0Hg
=QLVR
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
