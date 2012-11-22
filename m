Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab2KVVkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:40:49 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63985 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab2KVVkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:40:45 -0500
Date: Thu, 22 Nov 2012 22:40:21 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Alex Courbot <acourbot@nvidia.com>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mark Zhang <markz@nvidia.com>, Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
Message-ID: <20121122214021.GA14771@avionic-0098.adnet.avionic-design.de>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com>
 <1353149747-31871-2-git-send-email-acourbot@nvidia.com>
 <20121120215429.B621F3E1821@localhost>
 <13540495.epaCf4JVn9@percival>
 <20121122133941.24B883E129E@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20121122133941.24B883E129E@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:+/YfEP1lk3zorfD9mcVhxU9ABxlOWubMNIt0VyrwHC0
 2XdeBpZQVUzgh9uyfr3tzOue2nPSs+ZLBQVG/2qdMtk/Gn2RKQ
 qcn8W/JaMu1iNqIUiY9y1kpL2kIUYNG4Bv8fcAQAtogdkm0SSQ
 NKnmrOxfiaZyJntDuH0gMceBXefFXL6IToiKuar4LqmRCFUA68
 ueBoz5MPnhI/oSQxLKfOcEOvIU1/HD5ABnUqCoB2y5M2KwEsti
 MTh6ll7+BZVZRv9w3O8zJSmnMWCXXL4FZnfLwEfJ0XZuX6ogUa
 osU+sCHsVtA10qF6hOkf94JwAwBv0PaBG0fgYL6crFtGb3JyPg
 tQWdtgN274u5zhVdtn0P32j/FTh+yP9p6E6AAKtCQ9PT0svVUI
 fMVJT7f9Q0QSSgbjWlDX2GaUqBlBLypWhc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 22, 2012 at 01:39:41PM +0000, Grant Likely wrote:
[...]
> I do think that each sequence should be contained within a single
> property, but I'm open to other suggestions.

IIRC a very early prototype did implement something like that. However
because of the resource issues this had to be string based, so that the
sequences looked somewhat like (Alex, correct me if I'm wrong):

	power-on = <"REGULATOR", "power", 1, "GPIO", "enable", 1>;

Instead we could possibly have something like:

	power-on = <0 &reg 1,
		    1 &gpio 42 0 1>;

Where the first cell in each entry defines the type (0 = regulator, 1 =
GPIO) and the rest would be a regular OF specifier for the given type of
resource along with some defined parameter such as enable/disable,
voltage, delay in ms, ... I don't know if that sounds any better. It
looks sort of cryptic but it is more "in the spirit of" DT, right Grant?

Writing this down, it seems to me like even that proposal was already
discussed at some point. Again, Alex may remember better.

Thierry

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQrpvFAAoJEN0jrNd/PrOhhywP/AiT0Ylywbi9V9FNnZ6zwngi
WtclXo/ALSEifXqZxDDw4wxS3rhQpSN34+l75lu5mbYP2FDgglRuKBrdXDGZuy7M
fcQKA5SDJAypajIijGWSWLzHZCnKVXonfHOUKeVmfq+Oo7LXUSYKYT4W3yYV9LcK
xJLtxJKJDNpIuxhcI0FaUewXRYjzhB/IFAf1IUWhV3YZ6ZfbR5PXwx/Jg6qvo5Ns
Z8PDMyth0YY0LWMIJBMpvZZk1xlL3yw8imwNLw+P1seICh0mq8QATXf5zM07DXa1
Lf8JWn/d8ueto4jCm0gavWLjexpN9baC2PUNkS313hRhbWGcnI+c95bMlpUx8QjI
PN3WUXF2vPcfrrsgIZrFjr5PrEIS4vQfC9LfrCg44UxM0IlvCRVEiFhEgbyTEeW5
qiuBaDnUMY6l39pZx7EG/hOU207u9ZaSM+w66COb630WzzpKnJd2ZTsf1H4dZ7w3
Oyozguikk5Ohw2olOKsNkIncvRZEYa6GYpKIIDhmW3GoNE+/rC/dVSXM2CDBlQWJ
A/QLnww1K0sKc0VN+m83JK/R7EvslAAv4gKVJ5U3AQbZm02k7bzUqFMw6ZHlNEw7
CeHgOX35dN+SQHtaVwC5G27hNpBoKSjubd3xzrS+F+65Rdt97If0Q7FgmU1o+b/u
zQV/10Xw4kMSFyk8raC3
=8uOp
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
