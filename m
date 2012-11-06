Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab2KFLb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:31:27 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42624 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2KFLbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:31:24 -0500
Message-ID: <5098F508.60100@ti.com>
Date: Tue, 6 Nov 2012 13:31:20 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Chuansheng Liu <chuansheng.liu@intel.com>
CC: <FlorianSchandinat@gmx.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] OMAPDSS: APPLY: Fix the usage of wait_for_completion_timeout
References: <1352222317.15558.1584.camel@cliu38-desktop-build>  <1352222480.15558.1587.camel@cliu38-desktop-build> <1352222555.15558.1589.camel@cliu38-desktop-build>
In-Reply-To: <1352222555.15558.1589.camel@cliu38-desktop-build>
X-Enigmail-Version: 1.4.5
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigD9A59708EBD537A66DB2F5E7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigD9A59708EBD537A66DB2F5E7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2012-11-06 19:22, Chuansheng Liu wrote:
>=20
> The return value of wait_for_completion_timeout() is always
>> =3D 0 with unsigned int type.
>=20
> So the condition "ret < 0" or "ret >=3D 0" is pointless.
>=20
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  drivers/video/omap2/dss/apply.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/video/omap2/dss/apply.c b/drivers/video/omap2/dss/=
apply.c
> index 19d66f4..ec42a6a 100644
> --- a/drivers/video/omap2/dss/apply.c
> +++ b/drivers/video/omap2/dss/apply.c
> @@ -414,8 +414,6 @@ static void wait_pending_extra_info_updates(void)
>  	r =3D wait_for_completion_timeout(&extra_updated_completion, t);
>  	if (r =3D=3D 0)
>  		DSSWARN("timeout in wait_pending_extra_info_updates\n");
> -	else if (r < 0)
> -		DSSERR("wait_pending_extra_info_updates failed: %d\n", r);
>  }
> =20
>  int dss_mgr_wait_for_go(struct omap_overlay_manager *mgr)

Thanks. I'll apply this to omapdss tree to avoid any conflicts.

 Tomi





--------------enigD9A59708EBD537A66DB2F5E7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQmPUIAAoJEPo9qoy8lh713aoP/iZHUmdCFlmLWGOJHFQBWns3
OI9X7bM5/0qgAMpBkEHh2CEFTSH73nc7kaN+fdRt/7U+Lb/JyzsFX0iEJz2u2f2k
TtybLq3l9/Yj54N/GpyzHyN5tObFv+29ocUDiz0G4q1Q5z4/oT12/zmUq7w9dXl8
mfxg0cSQ2faSc9vu0v+SWXDAOhBzdMvA1g7QlqYC5MDzlHMwAcHu/fMkAwwHOeLt
3YBlUAqV8TbsAQvUpvkZSB4gTsy63wN+q1gLIi1ujlPahRxwhQnFDr/JcUTDFpsO
g0Xzf7BR8G73wIYM67BHXq6TD6rvING2S5xYH55jucoTO+FT2t85PHoKfU5WsbnO
b1vRrFlSPl91PfPeSvZImzFpgkbyFO0/Bmxa8IZ19EE/grYo5M7GcT7n6plk7SNY
+O0iRzXqTAXOf7S8mmIaJl78OQMkcEX8aoeAfjDHSeQWKCHU/w3cSVBegEfQFlBB
FuQSJN+4cZLRuikbxjdZQ3dopMIX8BLsBH2VZvARjDAWmrf7/CecJxyWbTs3jH7R
D8AbOi80y9X8zuSw50fOD1gnjvV6jSCp5l3nLZB5BK0ST1emDhnfG4AMhNAa2Ydw
C5n+ZFyYqs2VhnfZq/wRriv2aUFbDHZB19rgN8WNfgwHCQ0EUQ/V9/xWJRlQigIN
sNxcv+6eKz0LRmD5AEgR
=FXHl
-----END PGP SIGNATURE-----

--------------enigD9A59708EBD537A66DB2F5E7--
