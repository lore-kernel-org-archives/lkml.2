Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2A3QLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:11:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59735 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753756Ab2A3QLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:11:19 -0500
Date: Mon, 30 Jan 2012 16:11:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [RFC 2/2] regmap: make use of cached entries in debugfs
Message-ID: <20120130161116.GK4882@opensource.wolfsonmicro.com>
References: <1327932497-28319-1-git-send-email-w.sang@pengutronix.de>
 <1327932497-28319-2-git-send-email-w.sang@pengutronix.de>
 <20120130145627.GJ4882@opensource.wolfsonmicro.com>
 <20120130153427.GH15596@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aziWXe2aaRGlkyg3"
Content-Disposition: inline
In-Reply-To: <20120130153427.GH15596@pengutronix.de>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aziWXe2aaRGlkyg3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 30, 2012 at 04:34:27PM +0100, Wolfram Sang wrote:
> On Mon, Jan 30, 2012 at 02:56:28PM +0000, Mark Brown wrote:

> > > -		if (!regmap_readable(map, i))
> > > +		if (map->cache_type == REGCACHE_NONE && !regmap_readable(map, i))

> > This isn't quite what you said in the changelog

> Sorry, I reread and can't find the diff?

Oh, right, you're not actually saying you'll only give cached values
back - my mistake.

> > and isn't going to play nicely with sparse register maps

> sparse == RBTREE? What does "play nicely" mean here? Too slow?

A sparse register map is one that doesn't contain all possible register
addresses, it's orthogonal to the cache - you can have an uncached
device where we know some addresses don't exist or for a cached device
the cache could be any type.

The check for regmap_readable() is there because it causes the debugfs
code to not display registers that don't exist, otherwise we could
easily DoS the output to the point of illegibility by including large
numbers (potentially thousands) of nonexistant registers in the
output making it hard for humans to find the ones that actually exist.

> > - it should be

> > 	if (regmap_cached(map, i) || regmap_readable(map, i))

> > or so (regmap_cached() doesn't exist at present but it seems reasonable
> > that it should).

> Sigh, I have to give up for now. Sadly, I am already way beyond my
> schedule regarding the amplifier driver and need to work on other things
> now.

Oh well.  I might get round to it sometime but essentially all the chips
I work with have read/write support so the issue never comes up.

--aziWXe2aaRGlkyg3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJsEdAAoJEBus8iNuMP3dsxsP/R1dEovjR5WNBlCmjvNp5hDP
ZdBqSqmLVUrDgnz/n/AeY6HYqUhoGl+psqLv4HAn4PLySPTqkWr+CjELgkS1NZgt
sj5l6+c8cYYaxzYe4Jvy/GY5lIs+XaoQ8i5PskOvDN170KI55UAlj+YBClqUCh5x
Uj/WyysOtm5/0TAGxAMrTZm7BC2a1xDAL+3suc9zMj+YRz0Q4CqwysXlBumvGTj6
vKttnRMAiNON7Qpp3aYv3pZ6uHqh2Vwm89DKjyzTZc07Y2AWlE6hsS2X8OW8ZGCu
ujgAunQvNscdlAJN6F+kmH8ZBxGHsFnLvJ5bTckOvyFCQB9Zm8gbX9qj+tK08Sho
Y3wNTv8xzNaQWkEoym/m6oyddYolMZpfGoVs5mhKLXamonVXJEe187aCb5hFg8A/
5ER50MjVIATbgeB4Or0sn0b+A8XwxpWH8Y+7jQeZq4UOarnCLx1uXv9zLt6DLO6B
L7VopW0NIP6lAFRnYL+4pxk217ObzZedtTf84NvpkyZK8Oc+cTnChKzCCrztSvrB
6459AcqEyV5ME1YmTgquc0rKgSdjwEwVgyEnTjn02ygi1aPzCEJmyC8YlyyNOKTU
t13CaWScaJaF4j7jCQ3QngqzMXFVYgLRLhe76qpZs0VTtNBwjRgf+kKl61VeAqvg
ZqMDSoOgX3I5nNRaGpQV
=49tP
-----END PGP SIGNATURE-----

--aziWXe2aaRGlkyg3--
