Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab2JWJRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:17:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33749 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756798Ab2JWJRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:17:16 -0400
Date: Tue, 23 Oct 2012 10:17:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] spi: tegra: add spi driver for SLINK controller
Message-ID: <20121023091713.GQ4477@opensource.wolfsonmicro.com>
References: <1350557233-31234-1-git-send-email-ldewangan@nvidia.com>
 <5085A667.2000100@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i/CQJCAqWP/GQJtX"
Content-Disposition: inline
In-Reply-To: <5085A667.2000100@wwwdotorg.org>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i/CQJCAqWP/GQJtX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 22, 2012 at 02:02:47PM -0600, Stephen Warren wrote:
> On 10/18/2012 04:47 AM, Laxman Dewangan wrote:

> > +	/* Read back register to make sure that register writes completed */
> > +	if (reg !=3D SLINK_TX_FIFO)
> > +		readl(tspi->base + SLINK_MAS_DATA);

> Is that really necessary on every single write, or only for certain
> specific operations? This seems rather heavy-weight.

I saw that myself - I figured that since SPI is (relatively) slow itself
the simplicity gained from doing the flush unconditionally was
reasonable, further optimisation can always be done later.

> > +	val =3D tegra_slink_readl(tspi, SLINK_STATUS);

> > +	/* Write 1 to clear status register */
> > +	val_write =3D SLINK_RDY;
> > +	val_write |=3D (val & SLINK_FIFO_ERROR);

> Why not just always set SLINK_FIFO_ERROR; does it have to be set in the
> write only if the status was previously asserted? If that is true, how
> do you avoid a race condition where the bit gets set in SLINK_STATUS
> after you read it but before you write to clear it?

The whole point with this sort of interrupt scheme is usually that the
interrupt is level triggered and will just continue to be asserted if
some source within the interrupt isn't acked; the race is usually the
other way around where you may ack a status you didn't see.

> > +static unsigned int tegra_slink_read_rx_fifo_to_client_rxbuf(
>=20
> > +		bits_per_word =3D t->bits_per_word ? t->bits_per_word :
> > +						tspi->cur_spi->bits_per_word;

> That logic is repeated a few times. Shouldn't there be a macro to avoid
> cut/paste. Perhaps even in the SPI core rather than this driver.

Yes, should be in the SPI core as this pattern exists for all SPI
drivers.

> Doesn't this function need to parse all the other standardized
> properties from spi-bus.txt, or does the SPI core handle that?

No, it doesn't.  But perhaps it should (see the thing above about the
per-transfer max frequency too...).  In general SPI hasn't done much
about factoring code out of drivers until very recently.

--i/CQJCAqWP/GQJtX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhmB8AAoJELSic+t+oim9pL0P/ibamePbIB4gxsz2z6sJuj+F
B0TQvAxe9efI0u+OVlxgx2092vKyQCNspo3ZQixrDXFugFNAdMOVaLyrBsZVUZAo
3+NlHRzFYb3V/BwsTs5xfEA104TQk4e2b6CsNfqEooyZ5CwTK+utgLn6qClZdocg
pgt6BdlM4XoiZxS7tkoxWGLE7J9L7p0i9OA7P32vBxQr/uHvNcLejq3bbUUHQ/bd
si54ct21JCn6E7GVmbyLOvDo47eaxkFUiCjg4kQ0wrUF+WPwWvWIp6VBt+/aO2yv
DT1u/HRo7bOAFTp7lPDROAZC2Ln64uRHhDdeoQNg2bLQofgF6A9HnsNikxwEeOWc
vIXf2GEx9I6OkgjjQAMafyQwNKtey6OT+W2CfhxZKPjCR0JKcCgyoSkXgYi41zjc
NcDdP1BiJTtsE0HBCDLWN7xHbduV6QJCLgkYt1Z9YQn+Ecse2Pvf9KzgjK04drW7
h9RkrTGtQ122A0aB0HKmIiElfkPksgFauBaymqn1pVI4Spwn2NQ/csKk0l/Kynu6
W/A89nxPa4XG4IS73CoUU7mnd6CWp+eEoH4mr56dCtAk6DAByhorzY1YK+w6Kp/r
nAM73XOBPproolTyOBv0fh4Zad/fVckZkUWftBtXY6CpvBPz17S/OvwF5oWy6D6r
h+zdJ1DsAzEPbCfxUoK6
=t3eX
-----END PGP SIGNATURE-----

--i/CQJCAqWP/GQJtX--
