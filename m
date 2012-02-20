Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab2BTCUY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 21:20:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49078 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753552Ab2BTCUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 21:20:23 -0500
Date: Sun, 19 Feb 2012 18:20:10 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v5 2/5] Extcon: support notification based on the state
 changes.
Message-ID: <20120220022006.GH3194@opensource.wolfsonmicro.com>
References: <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com>
 <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
 <1328856038-21912-3-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9crTWz/Z+Zyzu20v"
Content-Disposition: inline
In-Reply-To: <1328856038-21912-3-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9crTWz/Z+Zyzu20v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 10, 2012 at 03:40:35PM +0900, MyungJoo Ham wrote:
> From: Donggeun Kim <dg77.kim@samsung.com>

> State changes of extcon devices have been notified via kobjet_uevent.
> This patch adds notifier interfaces in order to allow device drivers to
> get notified easily. Along with notifier interface,
> extcon_get_extcon_dev() function is added so that device drivers may
> discover a extcon_dev easily.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

This is something I'd been going to ask for.  One related thing which
needs some thought is how we combine extcon detection methods for
hardware which uses multiple unrelated detection methods.  One of the
common examples for audio jacks is that you might have an ultra low
power detection method for detecting if something is physically present
in the jack and then use that to start up additional detection methods
that can tell what that thing actually is.  The two provide different
pieces of the picture reported to userspace.

With the ALSA and input accessory reporting methods we've got bitmasks
so this can be implemented fairly naturally but with the ABI that we've
got from Android here things aren't so easy as we need to go down to a
single value.  Perhaps some sort of bitmask to value translation layer?

--9crTWz/Z+Zyzu20v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPQa3KAAoJEBus8iNuMP3dil0P/3ZzaWiPu4D60QRaAP12B40n
UY9OB28wTWO5kYsIE5pjVkt7rmJQzqkKDcZWtnTkQQl+cJA3Viu829l/aqn/M7u6
g1sOkad/GvLXEBLt9ULmhzyhXC4yQpMqKVoXD1iGpFjybN7YJ9J73wql+3vonYgk
tl2C4essI+Bu/eGFOyX6Jtq3szir1wo2s3FMkk/WODp3g4eSddi/brzCi3nVf71k
J3K6oJScW/UFHr02hWd94MMWE1zQCJlf+SaIlKw3exfCk8q/N7DuqDeNivJ8nvBO
SDnq2a0yfRuIR9WSmBufim/L4D6jCbSoNJorfw87uarvmwduB9B9RHDDc/WTvLVQ
s03Vej0KXCEQxkI75igyhl2qY6eP2BHzzF5anRWHPabEcYdcdAG57+5kytcGjK1E
23/dYtqe+QmcdGrrF3KYOdxYyTODT65lGYsCJFNCkUMtlonjjiECaLo5u1Tz6nmo
rRu+BjXTtuPysk9fN1b9GEKh5tlAr/wcAlxwZWL5Dyagx9AzZA8+B1H10v/IwheS
Kb/0xN8wgjEBKZfdZ4rUOuW+vSGqZJWny2NMhaSmnXAUg/9kCLQXTeMwpz98OODq
Ua2vMnH4rqRkJ3AMtryJKg6cqqm9laI2wtCpSNRA2R81sCxPoER8qd2JJoCnF1DT
D6ndk13EsRO1atpHNaMT
=DiKb
-----END PGP SIGNATURE-----

--9crTWz/Z+Zyzu20v--
