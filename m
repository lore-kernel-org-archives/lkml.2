Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761706Ab2KBMzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 08:55:42 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51984 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991Ab2KBMzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 08:55:39 -0400
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Nov 2012 08:55:39 EDT
X-Sasl-enc: 5BsYfHrkvTl7HH85+LZ/mlOpGDzcuBp/YNua/j15/0Sh 1351860419
Message-ID: <5093C0B8.6080807@imap.cc>
Date: Fri, 02 Nov 2012 13:46:48 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiaotian Feng <xtfeng@gmail.com>
CC: linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>,
        Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <isdn@linux-pingi.de>,
        gigaset307x-common@lists.sourceforge.net
Subject: Re: [PATCH] isdn/gigaset: use tasklet_kill in device remove/release
 process
References: <1351680291-27202-1-git-send-email-xtfeng@gmail.com>
In-Reply-To: <1351680291-27202-1-git-send-email-xtfeng@gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig69D0554EB9A2D812C3C3F961"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig69D0554EB9A2D812C3C3F961
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 31.10.2012 11:44, schrieb Xiaotian Feng:
> Some driver uses tasklet_disable in device remove/release process,
> tasklet_disable will inc tasklet->count and return. If the tasklet
> is not handled yet under some softirq pressure, the tasklet will be
> placed on the tasklet_vec, never have a chance to be excuted. This migh=
t
> lead to a heavy loaded ksoftirqd, wakeup with pending_softirq, but
> tasklet is disabled. tasklet_kill should be used in this case.
>=20
> Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
> Cc: Hansjoerg Lipp <hjlipp@web.de>
> Cc: Tilman Schmidt <tilman@imap.cc>
> Cc: Karsten Keil <isdn@linux-pingi.de>
> Cc: gigaset307x-common@lists.sourceforge.net=20
Acked-by: Tilman Schmidt <tilman@imap.cc>

> ---
>  drivers/isdn/gigaset/interface.c |    1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/isdn/gigaset/interface.c b/drivers/isdn/gigaset/in=
terface.c
> index 67abf3f..284c7f3 100644
> --- a/drivers/isdn/gigaset/interface.c
> +++ b/drivers/isdn/gigaset/interface.c
> @@ -544,7 +544,6 @@ void gigaset_if_free(struct cardstate *cs)
>  	if (!drv->have_tty)
>  		return;
> =20
> -	tasklet_disable(&cs->if_wake_tasklet);
>  	tasklet_kill(&cs->if_wake_tasklet);
>  	cs->tty_dev =3D NULL;
>  	tty_unregister_device(drv->tty, cs->minor_index);
>=20

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)




--------------enig69D0554EB9A2D812C3C3F961
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlCTwMIACgkQMdB4Whm86/lwLgCggLX4n2CmIsID7sL1OjIEoqxo
CC8AnjpYTenl0ABJLhLmChFQePaaJqrX
=LIel
-----END PGP SIGNATURE-----

--------------enig69D0554EB9A2D812C3C3F961--
