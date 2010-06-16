Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab0FPQn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:43:28 -0400
Received: from athena.yggdrasilsoft.net ([208.79.213.178]:49235 "EHLO
	athena.yggdrasilsoft.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292Ab0FPQn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:43:27 -0400
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jun 2010 12:43:27 EDT
Message-ID: <4C18FD5E.7070809@tabris.net>
Date: Wed, 16 Jun 2010 09:35:42 -0700
From: Adam Schrotenboer <adam@tabris.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
CC: mingo@elte.hu, linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: excluding "." and ".." directories when calculating
 tids.
References: <4C1740B1.9070806@cn.fujitsu.com> <4C1748D6.1020007@cn.fujitsu.com> <4C185F68.1020505@cn.fujitsu.com>
In-Reply-To: <4C185F68.1020505@cn.fujitsu.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-ripemd160;
 protocol="application/pgp-signature";
 boundary="------------enigCBC39A6A3D863648D9409362"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCBC39A6A3D863648D9409362
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06/15/2010 10:21 PM, Gui Jianfeng wrote:
> Introduce a filter function to skip "." and ".." directories when calcu=
lating
> tid number.
>
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  tools/perf/util/thread.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
>
> diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
> index 1f7ecd4..9a448b4 100644
> --- a/tools/perf/util/thread.c
> +++ b/tools/perf/util/thread.c
> @@ -7,6 +7,15 @@
>  #include "util.h"
>  #include "debug.h"
> =20
> +/* Skip "." and ".." directories */
> +static int filter(const struct dirent *dir)
> +{
> +	if (dir->d_name[0] =3D=3D '.')
> +		return 0;
> +	else
> +		return 1;
> +}
> +
>  =20

Is this safe? Can you _never_ have a d_name with a leading dot, like '
=2Ehidden' ??
Maybe should
if(dir->d_name[0] =3D=3D '.' && (dir->d_name[1] =3D=3D '\0' || (dir->d_na=
me[1]
=3D=3D '.' && dir->d_name[2] =3D=3D '\0')))

Admittedly I don't think it happens in the current procfs, but I'd want
to be careful regardless.



--------------enigCBC39A6A3D863648D9409362
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEAREDAAYFAkwY/WEACgkQXNlttaeijWd95gCfW1cups/PjP+GYfKCMKLeUEgc
bscAnRC0osKtoYBf/dmHVqtvSUBpDUdA
=F42o
-----END PGP SIGNATURE-----

--------------enigCBC39A6A3D863648D9409362--
