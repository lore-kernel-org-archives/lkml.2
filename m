Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab1KMU7u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 15:59:50 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50446 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab1KMU7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 15:59:49 -0500
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 9/9] bq27x00: Fix OOPS caused by unregistring bq27x00 driver
Date: Sun, 13 Nov 2011 21:54:16 +0100
Message-ID: <45584927.uAIXTvEKdg@pali-elitebook>
User-Agent: KMail/4.7.3 (Linux/3.1.0-2-generic; KDE/4.7.3; x86_64; ; )
In-Reply-To: <1320108191-6647-9-git-send-email-pali.rohar@gmail.com>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com> <1320108191-6647-1-git-send-email-pali.rohar@gmail.com> <1320108191-6647-9-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart57469943.3BPAOjhCSp"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart57469943.3BPAOjhCSp
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Tuesday 01 November 2011 01:43:11 you wrote:
> * power_supply_unregister call bq27x00_battery_get_property which cal=
l
> bq27x00_battery_poll * make sure that bq27x00_battery_poll will not c=
all
> schedule_delayed_work again after unregister (which cause OOPS)
>=20
> Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>
> ---
>  drivers/power/bq27x00_battery.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/power/bq27x00_battery.c
> b/drivers/power/bq27x00_battery.c index 15ecd42..29ce907 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c
> @@ -722,6 +722,10 @@ static int bq27x00_powersupply_init(struct
> bq27x00_device_info *di)
>=20
>  static void bq27x00_powersupply_unregister(struct bq27x00_device_inf=
o *di)
>  {
> +=09/* power_supply_unregister call bq27x00_battery_get_property whic=
h call
> bq27x00_battery_poll */ +=09/* make sure that bq27x00_battery_poll wi=
ll not
> call schedule_delayed_work again after unregister (which cause OOPS) =
*/
> +=09poll_interval =3D 0;
> +
>  =09cancel_delayed_work_sync(&di->work);
>=20
>  =09bq27x00_battery_reg_exit(di);

Can somebody review this patch series? At least this last patch fix reb=
ooting=20
device Nokia N900 after unloading bq27x00_battery module with rmmod!

--=20
Pali Roh=E1r
pali.rohar@gmail.com
--nextPart57469943.3BPAOjhCSp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk7ALngACgkQi/DJPQPkQ1K2MACeOIxst+/cPzt+2gL6Kd/szGEd
GmIAoJlUuPIB/eQzqdr5GwMB4s/oIgr5
=1RN1
-----END PGP SIGNATURE-----

--nextPart57469943.3BPAOjhCSp--

