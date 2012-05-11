Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab2EKDVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 23:21:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58197 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758876Ab2EKDVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 23:21:20 -0400
Message-ID: <1336706470.8274.435.camel@deadeye>
Subject: Re: [ 166/167] [PATCH] staging: r8712u: Fix regression caused by
 commit 8c213fa
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Alberto Lago Ballesteros <saniukeokusainaya@gmail.com>,
        Adrian <agib@gmx.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 11 May 2012 04:21:10 +0100
In-Reply-To: <20120509194859.GE15527@herton-ThinkPad-T420>
References: <20120509055029.588587017@decadent.org.uk>
	 <20120509055052.452419913@decadent.org.uk>
	 <20120509194859.GE15527@herton-ThinkPad-T420>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-sdAa/IZbl+PQwDBOcjUl"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sdAa/IZbl+PQwDBOcjUl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-09 at 12:49 -0700, Herton Ronaldo Krzesinski wrote:
> On Wed, May 09, 2012 at 06:53:15AM +0100, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Larry Finger <Larry.Finger@lwfinger.net>
> >=20
> > commit 2080913e017ab9f88379d93fd09546ad95faf87b upstream.
[...]
> > --- a/drivers/staging/rtl8712/usb_intf.c
> > +++ b/drivers/staging/rtl8712/usb_intf.c
> > @@ -30,6 +30,7 @@
> > =20
> >  #include <linux/usb.h>
> >  #include <linux/module.h>
> > +#include <linux/firmware.h>
> > =20
> >  #include "osdep_service.h"
> >  #include "drv_types.h"
> > @@ -620,6 +621,10 @@ static void r871xu_dev_remove(struct usb_interface=
 *pusb_intf)
> >  	struct _adapter *padapter =3D netdev_priv(pnetdev);
> >  	struct usb_device *udev =3D interface_to_usbdev(pusb_intf);
> > =20
> > +	if (padapter->fw_found)
> > +		release_firmware(padapter->fw);
> > +	/* never exit with a firmware callback pending */
> > +	wait_for_completion(&padapter->rtl8712_fw_ready);
>=20
> We also need to apply commit ee6aeff71e2f16b9fe95ce908d098c169e0f4004
> after this, due to the possible invalid padapter dereference.
[...]

That 'fix' makes no sense since netdev_priv() never returns NULL.

Larry, you should remove the test for pAdapter completely, or if pnetdev
can somehow be NULL then test *that*.

Ben.

--=20
Ben Hutchings
Life is what happens to you while you're busy making other plans.
                                                               - John Lenno=
n

--=-sdAa/IZbl+PQwDBOcjUl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT6yFp+e/yOyVhhEJAQqJvRAA0jc1vkCW4XJwdjzGfi7/H+ry0TRIiG5f
6pWYLtY4otQKiwv+dTP08uk3gQajX8P+2DTedaoUKiyrQlSTxsMv6SYtNtcXqEmi
2eh3FGPuTNl/OC8kfFF4o+zNnFgFDVfuMFSqFVb3eyWMdLC073nYG7Si2m15VVEp
AGKyI0BioUfYlxWbXbhtfXoMIBsMxwAH0HvyOMh4jqnKFCcOSx2PPSOj9ezw3ih8
l+MnvqnHl5jIOgXR25X3UDPVN2sO5ITqGV9RSPuori3tstOOsz9VDuN6syMYAnV2
8GHd+Yy0pSDNb1tQk5mnkYclJVhAMBzj0I2Fx4e3eExdTfbFKpbOCwJWcPSkywJf
eyzHncmMkNvHlR5y1YXobwSuMPnBCPrH3Wsu2VOV1xTf8118HV+F+8Mw01l2hcZU
1BUoYbTLb9WkMt7sJF3aMmeLjPJde57ONJtN/DZ7qe53rD68VdqL57Aq/fDl03VL
yLL9KleHuz6imMQ7DQN3+IHB/NtpRHtrr+Ydd/e4Z2oZ5XqePhdoEBHGDz3hLSUI
R2EJIPN6+G6eaP2EHKf/3mlmlIwUEt+N/yaZjdMsEr8E/RTT6uKnd5ckJluYc9R/
TJU5q2vL1TrE1upr1a0sG48jKtX1M+WEY+wb2yreL+5u0lK72YKBQoB5GQpM3gv3
yb72+V+r1io=
=peQr
-----END PGP SIGNATURE-----

--=-sdAa/IZbl+PQwDBOcjUl--
