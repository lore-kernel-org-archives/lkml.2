Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab2A3O4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:56:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56048 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753637Ab2A3O4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:56:30 -0500
Date: Mon, 30 Jan 2012 14:56:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [RFC 2/2] regmap: make use of cached entries in debugfs
Message-ID: <20120130145627.GJ4882@opensource.wolfsonmicro.com>
References: <1327932497-28319-1-git-send-email-w.sang@pengutronix.de>
 <1327932497-28319-2-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q5r20fdKX+PFtYHw"
Content-Disposition: inline
In-Reply-To: <1327932497-28319-2-git-send-email-w.sang@pengutronix.de>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--q5r20fdKX+PFtYHw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 30, 2012 at 03:08:17PM +0100, Wolfram Sang wrote:

> -		if (!regmap_readable(map, i))
> +		if (map->cache_type == REGCACHE_NONE && !regmap_readable(map, i))

This isn't quite what you said in the changelog and isn't going to play
nicely with sparse register maps - it should be

	if (regmap_cached(map, i) || regmap_readable(map, i))

or so (regmap_cached() doesn't exist at present but it seems reasonable
that it should).

--q5r20fdKX+PFtYHw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJq95AAoJEBus8iNuMP3dhWUQAJo9K5KovoVNOXWmJxmjWaHM
YxJnscbLxqbSEGRtLVUD9IOq1++Ag5Dtco63/811dfSk9kK32Wj3T5SUvaN+/pIr
OSlFo4ieNKQIMb2j1VN7axjqumXb/o0VViiCnHJ9x463AE1HyhdIyXajllFoS7/y
jLe+weaOgxIHGDDo1o0Jes+76l24Ha3Hz7wjDBBbL07qnSzeWpXzim6fy9O1OjAo
vN/zk0r2no0uMJpO/2AzvgyFRpqQcDuOdTqcYee6J129vELZkMdRjNIGsIUtbaxn
Gvnp4szYtZYmPhcG45QWNKqUbIS9O8sn9n5HmUFgQYmgolCUHXNh6JyMFcr53dIr
nHDoexnPv1+7jreteZW51F5n7iGr69HLxlfyPFw2LQal4HZw0q4Bhh70Qzekh2PV
2uGS8JqeEXUbzB0ARk85C2/jVV+qWeVj9cbfTHHU1gLIbvA4sx5xujkktlHzU7lR
tONEmsjcmsM5/B9Q697beZt2Tj07r6miea7okUoDXrP9MUB9XRyeBnmAGWb0m0Ga
DFfYNQ3PaU+suzDCNiYa4ygKSCmjgYfl3Cdodkz6IZzkpRMBuLI749UV8wHPAzo5
IAafPjTJQPE+eRHSTMnEUqUZCKvrSZrUltxr7geTa6Gk1X4hh1Wxg4nH+V1xrKIp
XUKgWQ7aKHHkNEc6MmLE
=D3yf
-----END PGP SIGNATURE-----

--q5r20fdKX+PFtYHw--
