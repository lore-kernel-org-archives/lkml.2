Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab1LVGli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 01:41:38 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:62845 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab1LVGlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 01:41:36 -0500
Date: Thu, 22 Dec 2011 09:42:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Toon Schoenmakers <nighteyes1993@gmail.com>
Cc: sjakub@gmail.com, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: asus_oled: Fixed checkpatch.pl warnings in
 asus_oled.c
Message-ID: <20111222064211.GH26771@mwanda>
References: <1324386035.27425.2.camel@RainbowDash>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="svExV93C05KqedWb"
Content-Disposition: inline
In-Reply-To: <1324386035.27425.2.camel@RainbowDash>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4EF2D119.0148,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--svExV93C05KqedWb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 20, 2011 at 02:00:33PM +0100, Toon Schoenmakers wrote:
> >From ac6a96cdf890714ec7b8f0e6597f82a49cfbe232 Mon Sep 17 00:00:00 2001
> From: Toon Schoenmakers <nighteyes1993@gmail.com>
> Date: Tue, 20 Dec 2011 13:52:41 +0100
> Subject: [PATCH] staging: asus_oled: Fixed checkpatch.pl warnings in
> asus_oled.c
>=20

Insufficient patch description.

Patch mangled.  Read Documentation/email-clients.txt send it to
yourself, verify that it applies with `git am`.

> Signed-off-by: Toon Schoenmakers <nighteyes1993@gmail.com>
> ---
> drivers/staging/asus_oled/asus_oled.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/staging/asus_oled/asus_oled.c
> b/drivers/staging/asus_oled/asus_oled.c
> index 7bb7da7..e77e4e0 100644
> --- a/drivers/staging/asus_oled/asus_oled.c
> +++ b/drivers/staging/asus_oled/asus_oled.c
> @@ -201,7 +201,7 @@ static ssize_t set_enabled(struct device *dev,
> struct device_attribute *attr,
> struct usb_interface *intf =3D to_usb_interface(dev);
> struct asus_oled_dev *odev =3D usb_get_intfdata(intf);
> unsigned long value;
> - if (strict_strtoul(buf, 10, &value))
> + if (kstrtoul(buf, 10, &value))

We introduced a lot of new functions here so it's not just a one to
one translation from the old strict_strtoul().  For example
kstrtou8() might be more appropriate here because that's what gets
passed to enable_oled().  You would need to change the type for
value as well.

Althought it doesn't matter much.  If the user passes anything
besides 1 or 0, they deserve what they get I suppose.

Preserve the error code instead of returning -EINVAL for everything.

> return -EINVAL;

regards,
dan carpenter


--svExV93C05KqedWb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO8tFCAAoJEOnZkXI/YHqRZrcP/jS9foyi9MfG1SylIo/pES5a
5SOr7FfXahP5UuvVih7aWB71EDwB3Yr7H1ANlLTJtyM1qCxbc7j/WXbpB3CGxo+5
3z+go72s8lb7oLpcR5UC9yL2uOkSiav8kI9Llhujqcsa8+3OZI+iotUV3Jk/PYay
+N0r9X5tldvxC6Yu7c7i739TeXoCRPenIaKay1tFdgmBVGlR6N7EhJVsZvBKR0vt
eBw6i+6+LfClyhZcF7neAfu3xNmao1XoUfXpLUc1t9w/pIYyRPCRsHANxrAwTTZO
g3TBiMWPe+6fJ+Svq+bFmMwLV/PiYEd7q/wqfEe0C/gJqc3pAVgCnCUoWmx9pYY4
EkLzJSCcYUdodqhuTJ2NPI03Q7GABRyqyp91IHzH7VSVRwtD2OOfjoMGawAmb0cN
JBHdMacdOrWKL3jQI0EXSqFQMeH9QDAWY2QnQSDddl8YTKd5BNnD1PhAGGbK4R1X
R8LVRxqHs34YbTmg0m9YIuYDaghnuOd6GR3Y85Hwm+pB6gGgMaQS/sFLxtijRetg
SeHQq7V22aDoiN8OolI/I1BKW0khkxm/9haBJhKK3A3K04V39PSnDeNjeDJJ9S+e
uBZC37T69julbwxUKJX4zQFevVmDhKJodc4+1hcEGe/IwwJwJ8UZU3em6nD8LtQz
5QuVacY537hBxe5liwL7
=1Ncz
-----END PGP SIGNATURE-----

--svExV93C05KqedWb--
