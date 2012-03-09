Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab2CIMl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 07:41:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40950 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753655Ab2CIMl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 07:41:27 -0500
Date: Fri, 9 Mar 2012 12:41:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        NeilBrown <neilb@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, gregkh@linuxfoundation.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v6 1/5] Extcon (external connector): import Android's
 switch class and modify.
Message-ID: <20120309124119.GV3273@opensource.wolfsonmicro.com>
References: <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
 <1330344939-18394-1-git-send-email-myungjoo.ham@samsung.com>
 <1330344939-18394-2-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YnIutncTLXsDZs5t"
Content-Disposition: inline
In-Reply-To: <1330344939-18394-2-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YnIutncTLXsDZs5t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 27, 2012 at 09:15:35PM +0900, MyungJoo Ham wrote:

> +#ifdef CONFIG_ANDROID
> +		extcon_class = class_create(THIS_MODULE, "switch");
> +#else /* !CONFIG_ANDROID */
> +		extcon_class = class_create(THIS_MODULE, "extcon");
> +#endif /* CONFIG_ANDROID */

This seems somewhat sad - if ANDROID is turned on the standard ABI
vanishes.  It'd be much nicer to do this with a symlink (or with
symlinks within the android directory if the driver core doesn't support
that).  That way userspace code can be written to the new ABI and will
work on Android systems without ifdefery.

--YnIutncTLXsDZs5t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWfpXAAoJEBus8iNuMP3dpJoP/2JKKc74OGa7pZTvhD3pkEV/
hOBS/GKrfjVw/kEeRz6DOOM0MFCrb287P7zummmTinHJfyP+NR/iGtO/HmLOq2Pk
Ko41ZlPghMGjTIorsRUx4KFEaUFjUe85LRAO71fgxVUrOsqF8upIg/h4C/4lQdVU
DHL7/aAXUq+OwO0UvRr6AsR/D1Nt4mwy94GhS5Z1UQnfE4q+RzbqnIMTbRcvvxFj
NR2WCIyfkVmHalXxz91NF2hFmi7b40ERRRFyuv8+9AoWmau7nTNNmDcaGSsku9sM
3O8X/BgFdwXfVq4O+qhq0nbFE3TaAYRLwdbAjXeQXTYG3978i4JmvYLZ5KyqoQWb
oQ/h5UpqIGi2ecC3lxT31ML4eL4hW8yLiOsRhVDecpYLU9OfE7oqcEPyjDWH7PLD
a1xwOYi1skhmf8yaxIiP0pHyVTed7H2mmpUaedBAdy3ltsBc67aRm8/GplZ7XCon
qQG94SSM1+piBUnIIgEAniUSIpbrf+eGE9YEedCr9RJKcCkTpJDSIwdB64ZsrnmD
PGlPvsF+1n9VSxFMatFZ09pD1zddZUJoa72XFWqQJs518O+YwVLGKPKb3XcwZGhH
uFCjK/e3l7EAjCOXA4c/L4PaQva/5LuATXE0tOtNUQh9nL1aMuMyDvMTFaIxdeIF
k7muy0N8X3mP466kT6xM
=Fa5N
-----END PGP SIGNATURE-----

--YnIutncTLXsDZs5t--
