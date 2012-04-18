Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab2DRIQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:16:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43977 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751393Ab2DRIQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:16:51 -0400
Date: Wed, 18 Apr 2012 09:16:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Bryan Freed <bfreed@chromium.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "max@stro.at" <max@stro.at>,
        "jbrenner@taosinc.com" <jbrenner@taosinc.com>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "grundler@chromium.org" <grundler@chromium.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: iio: light: isl29018: use regmap for register
 access
Message-ID: <20120418081647.GA3021@opensource.wolfsonmicro.com>
References: <1334652631-21032-1-git-send-email-ldewangan@nvidia.com>
 <4F8D5506.6070105@cam.ac.uk>
 <4F8D5B09.8080309@nvidia.com>
 <CAEYUcX3TbXFmKYCvfz00tpJ3K0bSExnQxV1R==dP=+vsK54KPQ@mail.gmail.com>
 <4F8E5CFD.4040501@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <4F8E5CFD.4040501@nvidia.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 18, 2012 at 11:49:41AM +0530, Laxman Dewangan wrote:

> yes, the caching is done before actual transfer and it can make
> cache dirty in case of transfer failure.
> I am not sure what should be correct handling here: make cache dirty
> or revert the value to original one?
> But using the regmap will provide the common behavior across the
> driver and all driver will have same behavior rather than handling
> on differently across driver.
> So if there is any other policy for this, it will be same for all driver.

I'd mark the cache as dirty I guess, though you'll then need to arrange
to resync it at some point (presumably after you've taken recovery
action) so that won't be enough by itself.  Or reset the device and
bring it back up manually if you think that might work.

regmap doesn't make much effort here since if physical I/O has started
failing you've generally lost the plot completely, 90% of the time it's
not going to be possible to reover the situation at all and if you can
then there's a couple of different strategies that might work and which
one is appropriate is going to depend on the device.  I'll do a patch to
flag the cache as dirty since I can't see how it'd make the situation
any worse but the driver will still need to do something to handle this
situation for that to take any effect.

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBAgAGBQJPjnhCAAoJEBus8iNuMP3dUuYP+L7taxPH8VxlVaGDLVuJhetu
6SOfxL6/0YDCz8WKttaBSdmtMQH7kL52B+ykGk3TRie2WFzlNgP33q4VOYXdnB2K
qlKENO2jx9IoaaQkb1L+NjwukIF1T/0E5VzFT7/wHdqMr+7TyA8fwVM8tBqGiw9t
0iA9xuU0PolyNtUVhtbwR6r3yuOVBHDaJbFrwvPdP5b2Oq/FLXiQ4t0XYL9fzmbC
Zz9zYK2gB3rvqkJM8PD7TzlxOa5OKG5GoDnZFCc5uLamtYTOlv0F+z+O4wgirPTU
9DxujVfH8EpnxITEuFvLXLohROgcDYHu1iMRG7TvXdSD6KRZxjXvsq04rCtAuGRq
6jYO8F8lynqtFrHr0YUFYK4sU97wJ1wDBxzLvMD4mrJKUX/9P+viEUtqSEhsB8MQ
cG6avWtX9q4fjD4bAopEx5GwWeIg5LbX5A8w4kqs7Wnt2Kb5RktooGUyT8ubPHJ3
JDc8DuuvKLRBKJXDaDL5dv1ZoiFsNw3Uj49ncLYcQXvjd25BrRpD+P3u/m9M5S94
0JvD3kfL0rBRISDZGKFMKOyz72MBzuU8HBieNMJKII0Z+YyQCjOCczz38oqmm+jt
txf06eOPSmKrYXHEyn/X/r3R+HQ1X92e7TxoWwe5yHER0D+ISeEvdy9EOie5ejSp
IDraGkcNr5UknydR9j0=
=BvsX
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
