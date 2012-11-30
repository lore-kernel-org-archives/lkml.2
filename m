Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab2K3HYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 02:24:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63120 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab2K3HYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 02:24:05 -0500
Date: Fri, 30 Nov 2012 08:23:57 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Terje Bergstrom <tbergstrom@nvidia.com>, linux-tegra@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 2/8] video: tegra: Add syncpoint wait and interrupts
Message-ID: <20121130072357.GF26474@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-3-git-send-email-tbergstrom@nvidia.com>
 <20121129084400.GA28781@avionic-0098.adnet.avionic-design.de>
 <50B7AC6E.4050906@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L2Brqb15TUChFOBK"
Content-Disposition: inline
In-Reply-To: <50B7AC6E.4050906@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:7V22obW5Ja+Q2ymuAlWxj9+SAAeiY6e4f+DOoPAid0T
 9rq2w+Z4nTOr0t4nVwjoSY7kFLBj9P+O7y5G4gTaOzFKsayuBh
 AJfhCpCyELDgCU1Jcc5OO79TV0gYAMglF/KO/1pfi4Kqsa2U20
 G6PM6bRMLzhZg3PGEYX1+njylyaOnUDqgHMhdSrTjxDoovLt8L
 v6/lpC0ACadcioijV3j7rwDiUopeZKYT5CzELYZRZzivBmZkk5
 Xeh7ptEGy44oGmE7pBqsDKj6rjxwH+pyDkuKRRhceLC6ameljh
 3mIilBGu6bvTsIAxl8pd99GFQqNIdwha9sNqnTj1BlrbLHJNbq
 dcpV4isVehdkdFjQi6rwAthZgaGPqZd6qhFuaY7ZlwwmKHCTrF
 6a8xI2f+k/e02HodcmYuEvlVOdVcAHg6OlCC7mA/0lm3esj1Oa
 XxxaY
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L2Brqb15TUChFOBK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 29, 2012 at 11:41:50AM -0700, Stephen Warren wrote:
> On 11/29/2012 01:44 AM, Thierry Reding wrote:
> > On Mon, Nov 26, 2012 at 03:19:08PM +0200, Terje Bergstrom wrote:
>=20
> >> diff --git a/drivers/video/tegra/host/host1x/host1x_intr.c
> >> b/drivers/video/tegra/host/host1x/host1x_intr.c
> > [...]
> >> +/* Spacing between sync registers */ +#define REGISTER_STRIDE 4
> >=20
> > Erm... no. The usual way you should be doing this is either make
> > the register definitions account for the stride or use accessors
> > that apply the stride. You should be doing the latter anyway to
> > make accesses. For example:
> >=20
> > static inline void host1x_syncpt_writel(struct host1x *host1x,=20
> > unsigned long value, unsigned long offset) { writel(value,
> > host1x->regs + SYNCPT_BASE + offset); }
> >=20
> > static inline unsigned long host1x_syncpt_readl(struct host1x
> > *host1x, unsigned long offset) { return readl(host1x->regs +
> > SYNCPT_BASE + offset); }
> >=20
> > Alternatively, if you want to pass the register index instead of
> > the offset, you can use just multiply the offset in that function:
> >=20
> > writel(value, host1x->regs + SYNCPT_BASE + (offset << 2));
> >=20
> > The same can also be done with the non-syncpt registers.
>=20
> It seems like reasonable documentation to replace "<< 2" with "*
> REGISTER_STRIDE" here.

Given that it is a very common pattern, << 2 seems enough documentation
to me, but sure, if you prefer to be extra explicit that's fine with me.

Thierry

--L2Brqb15TUChFOBK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQuF8NAAoJEN0jrNd/PrOhhAgP/0dsjWCTylvnvrbB60Xfy0NH
veT4LTrEabepeQRz6VaRb4kC0Xbh9jJe6HDFgTrTrBRkTsOJYIXFmcdyLpOOAApZ
HM3W9b9FPZHzLIqdwhJwl3hEO0IziAGyGfux7Jt0saSEcLSDXaspwEoSORYUh/wN
ERdBd6FRNuIWxNrENI1ian9NWWSI8UeaPTzn/CrM8nh5NmM1iP9wt0Ssb1bdZtLK
B9eHnE8KdBj1qTXnHXiPfm29NNq3KFqE0PR4STD7+8Pwjo01hC4mWKOMUoodBLA1
Ph3vSQYB0IyI2BY5KwPNRqI68fY0j723/zUG7ix6z0spjl+zMUfwn6ZtBXb2uZPl
3/35lNFzlCfkmhvr65usS9oXQ+ivd7SbjLt9FEVvaSG6njuMrexMvXZVuKRgmDkX
rmaRMcvDbO6mRQUXAYgt7BboiQQDXQ7kecilT2JHzvB6Mv6hvpqNX8fpV1urAMU9
3pEJyPzfrWQqt/vh5OhmeL1NZF9VAubC0HAgUa1sbRKB9TxfktUiynzt7jalOyDk
vj+Ot7g9SdjQMCRttqbPoGhTp9AsbWgbku/7alkoqYb4W1iqWhlZinLEYTEyhMzN
TLBpMhTOCDpvxn3EdQTDeqKpwIM22bwsZQCSWAD9CkT+sXWInlB6VMzg0mf+HSVc
h+StfsAYls5sOrifLVSi
=BhV8
-----END PGP SIGNATURE-----

--L2Brqb15TUChFOBK--
