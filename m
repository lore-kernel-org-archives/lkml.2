Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab0LDVd6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 16:33:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56722 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab0LDVd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 16:33:57 -0500
Date: Sat, 4 Dec 2010 22:33:48 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "adrian.hunter@nokia.com" <adrian.hunter@nokia.com>,
        "prakity@marvell.com" <prakity@marvell.com>
Subject: Re: [PATCH v3 2/3]set timeout control reg for such SDHCI host
Message-ID: <20101204213348.GE671@pengutronix.de>
References: <20101202112613.GC10358@intel.com> <20101202115329.GE3345@pengutronix.de> <5D8008F58939784290FAB48F54975198320B3E41F7@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ryJZkp9/svQ58syV"
Content-Disposition: inline
In-Reply-To: <5D8008F58939784290FAB48F54975198320B3E41F7@shsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ryJZkp9/svQ58syV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 03, 2010 at 10:38:59AM +0800, Dong, Chuanxiao wrote:
>  >=20
> > On Thu, Dec 02, 2010 at 07:26:13PM +0800, Chuanxiao Dong wrote:
> >=20
> > > +	if (host->quirks & SDHCI_QUIRK_FORCE_ERASE_SINGLE) {
> > > +		/* Set the timeout to be the maximum value */
> > > +		if (cmd->erase_timeout)
> > > +			sdhci_writeb(host, 0xE, SDHCI_TIMEOUT_CONTROL);
> > > +	}
> > > +
> > >  	sdhci_writew(host, SDHCI_MAKE_CMD(cmd->opcode, flags),
> > > SDHCI_COMMAND);
> >=20
> > Hmm, this looks like another argument for Philip's idea to always use t=
he maximum
> > timeout value and skip the quirks related to it?
>=20
> Yes, if always using the maximum timeout value is OK for other command, t=
he patch2 can be removed I think.
> The new added quirk in the serials patches is used to set the limitation =
of request queue, not only just to set the timeout control reg.
> Even the timeout value was set to be 0xE (the maximum value), erasing too=
 many sectors can still be failed since the timeout time was still not long=
er enough.
> So the count of erased sectors passed down by request queue should be red=
uced by using this quirk.

Yes, I think I understand the issue. Have you tried adding a callback, so we
don't have the options between MAX_UINT and '1' but rather MAX_UINT and ret=
urn
value of the callback?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ryJZkp9/svQ58syV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkz6s7wACgkQD27XaX1/VRuaVwCfeqwPNsEcK6rfLHK5jyyQICoB
3rwAnRN9LfQvg9NIys8grMMBC9hHFJo4
=yJdq
-----END PGP SIGNATURE-----

--ryJZkp9/svQ58syV--
