Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab2BVN5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:57:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43159 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746Ab2BVN5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:57:14 -0500
Date: Wed, 22 Feb 2012 13:57:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Append device name in the root debugfs dir
Message-ID: <20120222135709.GA14766@opensource.wolfsonmicro.com>
References: <1329918783-22610-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <1329918783-22610-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 22, 2012 at 01:53:03PM +0000, Dimitris Papastamos wrote:

>  void regmap_debugfs_init(struct regmap *map)
>  {
> -	map->debugfs = debugfs_create_dir(dev_name(map->dev),
> -					  regmap_debugfs_root);
> +	char name[64];

That's a magic number, where did it come from?

> +
> +	snprintf(name, sizeof(name), "%s-%s",
> +		 dev_name(map->dev), map->dev->driver->name);
> +
> +	map->debugfs = debugfs_create_dir(name, regmap_debugfs_root);

No, keep the directory name the same and add a new file.

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRPP/AAoJEBus8iNuMP3dsOcP/1lp/GRN1oc3PaZUglHmIpOd
BW7Rq2WA/x1zlyyygEyeasCxjXm5OPc55Gb0qldHmBZlO7V+R1LXgPLOtUfOrM3r
mDTWONi6zNaEfxJZox4cyQWLyDDJrz9TpcxV2HHMVU49U8g5U9Vtnxota0D+8qvA
Gw1UqFsGl0UPqKyyxBIauKOA+Txr1342XB/suj2cIsSx3hCHeRf+sUTcgYcD1Tvh
vounzMvK82ADEg+1rRWKQ5nhms17AySMEJ8GGAfiS/E/rkg9VwhIVwFuMv78nm+U
3RawRC4NPnXGoIrv5N8VyuBBEnY33QXE5aHepTrhPWWv1VeqlppXPr4vQ6jWmQcK
bT52I7r1qbKNQbgLFk1Pl8N+WBeYNIkT8KMsBlFQBzvmVRmIeclvOwl3cX7Z/7o6
GWv6LowZeXML/q87WkRWqxTIDHjKl5Z9Xe8Ogq25j7YSSaq9zvUxxIelLwKpJ3VH
ouIHxq8vS0yKjoBPCSfOFxf9bB3l4BrdH7v7I7f4wqqzgrbR8KSnweFlu8FSbmo3
puTo3LIn/3DPpOfeLIl5d5fta/mttv/hmae+ZoxO34hTZ7sGH2Y+RepeTjcDhyxo
UFxQzPLM6XwFvTqxGq9dGex8OgUbsnRX9UrQTF+Xo8r6Q158oJ7U7iwVv9Dx5dl8
scVnO69GoVvQeLwjd/Px
=MubP
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
