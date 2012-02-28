Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965565Ab2B1MAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 07:00:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42954 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965502Ab2B1MAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 07:00:40 -0500
Date: Tue, 28 Feb 2012 12:00:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-ID: <20120228120037.GD3683@opensource.wolfsonmicro.com>
References: <20120228165857.5abb225e1748d40f9c5d61e8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ylS2wUBXLOxYXZFQ"
Content-Disposition: inline
In-Reply-To: <20120228165857.5abb225e1748d40f9c5d61e8@canb.auug.org.au>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ylS2wUBXLOxYXZFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 28, 2012 at 04:58:57PM +1100, Stephen Rothwell wrote:

> Caused by commits ac8d91c80190 ("regmap: Supply ranges to the sync
> operations" and a0941e562e80 ("regmap: Fix x86_64 breakage") from the
> regmap tree interacting with commits "bitops: rename for_each_set_bit_cont()
> in favor of analogous list.h function" and "bitops: remove
> for_each_set_bit_cont()" from the akpm tree.

Oh, that explains what went wrong there!  I had thought that
for_each_set_bit_from() must be ARM-specific somehow when I saw your
report and didn't actually reexamime on ARM when fixing up as _cont was
in the header (admittedly I was in a rush doing the fixup).

> -	for_each_set_bit_cont(i, lzo_blocks[0]->sync_bmp,
> +	for_each_set_bit_from(i, lzo_blocks[0]->sync_bmp,

That looks about right, yes.  Not sure what the best way to handle this
is, perhaps maintain _cont() for a while?

--ylS2wUBXLOxYXZFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPTMFxAAoJEBus8iNuMP3d88IP/3CQvvsFhp7n1IbZpWcT8q4j
ustwqhRtVWC32M39o6n7ARr7m0Az1tbpsefze01nOTOI40kuSbQQU4aAJEHiiGi2
2JwanQ5PDky70P/duC5L4hjBZB+fl/xCi2m5IlwSzCQ5F0u1XXdAcmyAN+oJ1iEi
ay/7jnYSjYg4FXTTWcACZnK9I52s89g3RwABL7mJs+RCN+YdtZ5jfOPAJ+2IqweU
U4F0co5mcnEVwH5f7gN+dvsc7990ock67qAAugFi+/TcQ7qsYOxAEbV8ZPZ4K4mE
mOF5s5x48BweHUeugpTkE9nvBTclrAWanG7RHGg0PD2yXs+B0cMaNC3fU9IvDjzz
RenKJHIDMVpCi8OxEnrJuPBCDv2UV154LWm73yLjSsLDUvFDvrUo2L2tlEgR7FZ4
QLQKVJqzMGSn39BbPI0amdQj/u9BaKcU5PvSAIrl2bWuE+RokCwW0A8iVzMcOdRn
IoxZ331DUzCNbeMvDVeyaPt7qGteBno6yTHPskub6lMc09jiIScQQfuQh38elcrJ
/SN1JuHm+v53tH+t8kGsreP8tL9uwx7PpKhDABbrwRkSv4xeeO1fYRGNE+aMsNLF
aNHYZwm6/pCK53KtXBAG81WhCnYjZ8ooyvmAK35DIleUvfLLi2LKAzNoXmzbHLm5
KtPFOUnuqX9K/3mGdh0x
=ZlL0
-----END PGP SIGNATURE-----

--ylS2wUBXLOxYXZFQ--
