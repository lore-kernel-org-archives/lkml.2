Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3AJS5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 13:57:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54124 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3AJS5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 13:57:46 -0500
Date: Thu, 10 Jan 2013 19:57:30 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 05/14] lib: Add I/O map cache implementation
Message-ID: <20130110185730.GB22944@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <201301100917.19577.arnd@arndb.de>
 <20130110102544.GA5546@avionic-0098.adnet.avionic-design.de>
 <201301101826.56248.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
In-Reply-To: <201301101826.56248.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:mWUc9W3gG/S+cfSwEAg3HF6YpLAzjYccMxmXkmjsAF7
 mev8cqnOCxpAlbY6XL0HuiyvJBeRvVt4wOz+hrcURfMnEVh2lh
 pxye0A+X3ncc9QhldcI27UC+y2AFJeEGzzzkNcVxxRE1qFPYgY
 xfRLP4thUzDH4RP36s9uj9FyDsVw9QuA0hSEJmOpc0aRrllqf5
 MAe9g0nBF2knsEc6wwGkA0fNvaFXF1u5OlA+Thk+/ZxdDK/ll0
 /1xIhLd/MIIGdzTAziOFfIcMPeNRSYbNFlVauFa5esSpeAZU9S
 Qz9UqgpaVLcQMXqk/O6xuY+O7gVheZqdUuiYusB7sjfTil3DR4
 y7ZYtwTQK5nKc2Yz8ceZcGL0iu0cGF0vfpl2NDRpof8IeSj0iJ
 uKAA6yXIDKFDX0v1wvh2a5olvEh1bCcggwVUsDhCoFQdBveb2b
 bm4WB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 10, 2013 at 06:26:55PM +0000, Arnd Bergmann wrote:
> On Thursday 10 January 2013, Thierry Reding wrote:
> > I don't understand how this would help. The encoding is like this:
> >=20
> >         [27:24] extended register number
> >         [23:16] bus number
> >         [15:11] device number
> >         [10: 8] function number
> >         [ 7: 0] register number
> >=20
> > So it doesn't matter whether I use separate areas per bus or not. As
> > soon as the whole extended configuration space needs to be accessed a
> > whopping 28 bits (256 MiB) are required.
> >=20
> > What you propose would work if only regular configuration space is
> > supported. I'm not sure if that's an option.
>=20
> I mean something like:
>=20
> struct tegra_bus_private {
> 	...
> 	void __iomem *config_space[16];
> };
>=20
>=20
> void tegra_scan_bus(struct pci_bus *bus)
> {
> 	int i;
> 	struct tegra_bus_private *priv =3D bus->dev->private;
>=20
> 	for (i=3D0; i<16; i++)
> 		priv->config_space[i] =3D ioremap(config_space_phys +
> 				 65536 * bus->primary + i * SZ_1M, 65536);
>=20
> 	...
> }

Okay, I see. It's a bit kludgy, but I guess so was the I/O map cache.
It'll take some more time to work this out and test, but I'll give it
a shot.

Thierry

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ7w8aAAoJEN0jrNd/PrOhNLUP/AztOrBB2e4h5l0+VeuzpWxz
4AiK84AP6TMOTGGgdgdCvpTWnZS4xLIL10c6QOiRIyT56gqN3aaVBtqQxph1W0mM
2EvmiIGnQ4A9ub8FyF5kVpZvS4n5r8Ostb9trr7V7h1ISCe4WTLSm7+4zqV2lfFh
xK6oOZCYIPf+yW6X2S5HVf/J4Aazci+wFfhdHYEE8jZn6Xi6Vi+PpCkUfiGncioq
H+hIcumFGaJU+VgYWaW/vuy/rgiNrKejA4vBt68pQ8yNFbVWgr0ue5gLZVWKGbX2
Cfok27eOITe3b+VA6SBZhWexafM92UzoB67VMzw9cMFsqRg7Mxc0wEqfrWiuup+8
AG5RWCAaF2QY2lkRbF2die0Tbw0IVqU1tIOYQw4vaG9B8szeti4OFFIl8XYNVe8z
jJpaj4H8992enDY0pDMAL2wfBEeTD+ZqIdfFsbM/h80UPWzr9bZDh5/rfhZ7GIwN
ESbIpQa91OWEmr1hN7TcqfL4p4GMsVSqJHsB9TK1kHBlyOFPwGdm9V6U5lXMtXRj
RVFw6UJ7Tvx0o4m4rXNQ0v9Z12ZDLSyLGwowVrRjXP2kuajr7bDU9I0eXDP1yq5Q
Cnui+x9jJVwf3LfgOMxJgP1VvcrXLM3ORWkAinde9N68fj4eSNDvlctJZNSu41jZ
xwvC4vWvB5CH8bBG2wxw
=obUg
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
