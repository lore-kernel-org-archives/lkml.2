Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab2HUJNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:13:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52455 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2HUJNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:13:21 -0400
Date: Tue, 21 Aug 2012 11:13:06 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Alex Courbot <acourbot@nvidia.com>, Stephen Warren <swarren@nvidia.com>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] Runtime Interpreted Power Sequences
Message-ID: <20120821091306.GA4819@avionic-0098.mockup.avionic-design.de>
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com>
 <1345097337-24170-2-git-send-email-acourbot@nvidia.com>
 <1345535069.4085.7.camel@deskari>
 <1562509.b0FYTUZ1D8@percival>
 <20120821083329.GA28992@avionic-0098.adnet.avionic-design.de>
 <1345539465.4085.22.camel@deskari>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <1345539465.4085.22.camel@deskari>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:iNyPfYBCTIUFCE2qtKbJnFeY/h5HByiSm8/WNUQgTfE
 V0LAFBD+gCpZyxACgxhnkf5rM8X7x+yTombB6oXA8p+ZJfLhcp
 nrrhL2QJ8dCda0PTKp8TDLg430oyKpPIlkSGSH2RZ6wHzpoyFa
 WjmajJixqyzwFwOlqYn9pv/rEM/IW4mCV8sBXdw2iGa5ULxZa4
 Ei/JU+b2Wd4rDAFUseD3+Y7ZbNvzcZGzivE2ohzjfJJMa0ee24
 zCFGSlbdfd/NsphR69VbkLTKmdd2howv6MRPF6hVsAacD3DX89
 P4Ilg0V0QQ+yZu+4jL9oRNUJSyIzpOBZDOohAKYE9IzBLIklN+
 91Bh1BJai6RqN2YnSNFALKhbY6uy/9NYu7MB47smg0oLlSsrLm
 3TFXJWOPvpVyVcVlmgOdaQVXyA3oWCP3Do=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2012 at 11:57:45AM +0300, Tomi Valkeinen wrote:
> On Tue, 2012-08-21 at 10:33 +0200, Thierry Reding wrote:
>=20
> > I suppose power sequences aren't needed if you have a specific driver
> > for every panel out there. However that also means that you'd have to
> > write drivers for literally every panel that requires support. In the
> > end this will just result in discussion down the road how the common
> > functionality can be refactored and we may end up with power sequences
> > again.
> >=20
> > Also as you mentioned, power sequences are useful for a number of other
> > use-cases. Without power sequences you'll have to potentially create
> > extra frameworks tha reimplement parts of the power sequence code for
> > their specific hardware needs.
>=20
> Right. I think my main concern is the use of DT data, not power
> sequences as such. I've been going back and forth in my mind with this
> issue with OMAP also.
>=20
> The question is: what stuff belongs to DT data and what belongs to the
> kernel? I've been trying to go to the direction where DT is used to
> describe the HW connections of different IP blocks and to pass board
> specific configuration. Everything else is in the driver.
>=20
> This doesn't mean that we'd have a separate driver for each device. For
> example, we have a generic panel driver in OMAP, which contains a kind
> of small panel database. The panel database contains the name of the
> panel as a key, and panel specific configuration as a value. This
> configuration could also contain some kind of generic power sequence.

I see. I do like the idea of it, because it is more straightforward than
representing the whole sequence in DT. Matching could be done using the
standard compatible property.

However this also means we'll essentially just be moving the board code.
Being in a central location it would be easier to refactor commonalities
though.

> I'd like to require the board developer to only fill in to the DT data
> what panel he is using, and how it's connected on his board. Not panel's
> internal functionality.

The amount of work required by the board developer would largely depend
on whether support for the panel is already present or not. For new
panels this would mean that a new driver needs to be written, while
representing the power sequence in DT might be easier to do, and readily
available from some datasheet.

> The one benefit I see with DT based approach is that if we have, say,
> 10000 panels, we'd have quite a big database in kernel memory and a
> board may only need one or two of those. But perhaps that could be
> helped with the use of __initdata.

I haven't worked with many different panels, so maybe I can't judge this
too well, but if panel drivers were kept in a central location, then the
number can be reduced by generalizing parts of existing drivers.

Thierry

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQM1EiAAoJEN0jrNd/PrOh/w4P/Ai9Q5aSXxy8dEcIL70Wqo8F
/Hdp99c6da7cxsGUJMwpVAmGgMRGoqh+/E2tQ7SB1HP5GQSVZ9/kqCdv2EgSPWuT
KdZ1b/os3tmeZsjBb6edEedWoF7NjMp1t3W5Pvh8uyLl5XDCPYaZKznOD7OY+KYg
tOawZ78/XZmNRrG3aO2Fq2bJuu9dV87OvLnAcFAMZHcxvZIwJn5BPfWXxuUJ+N0N
+2rs34CEdhEBPpruTWRwF1N0hbwLvPSXwuTeEQdW045AfaUQbA2KRlLQTgr8gqeR
ZmS/JTTmtpcn4TB6ldUF8Bd2UTffUv6U10AAjv1pnYr5zEJ3/92F5uGu+lQUCglt
CaANzG6i1gIG0wiAkM/1knGf4aFy+iIsUnPKDYEgwgCLAUIR8llS1UiOaP0pFnnD
bZZy5tlCvPrXtemEc/8CGhu2zxYTfFuLqwCoObtYOLla7H1+g79Yv7fQcwSeIvkT
hwtrIM4OGSvojIBJQhufK3RvN+XXvUtqQo0lKTUMckoQWNoStXJqldT8/fCa4Vdd
Nungm/4HRyX/IZsdi4FgDORn0Urlnkf3Vekm9jT5n2fs+t2P/EGGjWRhtKxExftS
HaLdBesKMl00Bj9zwaNjkFDhsyZqL67ltB0zeci0ZN8QHNkNwsxyKetGlfruT90X
cxZlxzavtgsREZfS1Ssf
=53sx
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
