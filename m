Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab0DSV55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:57:57 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41845 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467Ab0DSV5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:57:55 -0400
X-Sasl-enc: cjj/JA4v4i2CVesTptvKs15JBADek8JI0e4YSr+AjkiH 1271714273
Message-ID: <4BCCD09A.4040205@imap.cc>
Date: Mon, 19 Apr 2010 23:52:26 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: tip: origin tree build failure, [patch] fix isdn/gigaset build
 failure
References: <20100419.003857.260094283.davem@davemloft.net> <20100419172731.GA4358@elte.hu> <20100419.103304.35342954.davem@davemloft.net> <20100419180520.GA9244@elte.hu> <alpine.LFD.2.00.1004191112550.14500@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004191112550.14500@i5.linux-foundation.org>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC3F2EF1F61AD8624EE0C6337"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC3F2EF1F61AD8624EE0C6337
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 19.04.2010 20:14 schrieb Linus Torvalds:
> Maybe add the #include <linux/sched.h> into gigaset.h, instead of=20
> common.c?

Yes, that's the correct fix. Thanks a lot!

For the record, the cause of the build failure was my removal of
#include <linux/usb.h> from gigaset.h, entailing the loss of one
indirect inclusion of sched.h. There's another indirect inclusion
of sched.h from gigaset.h via interrupt.h, hardirq.h and
smp_lock.h, but that one only operates if CONFIG_PREEMPT is set.
So the reason I did not see the build failure myself was that I
only tested with CONFIG_PREEMPT=3Dy.

> ---
>  drivers/isdn/gigaset/gigaset.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/isdn/gigaset/gigaset.h b/drivers/isdn/gigaset/giga=
set.h
> index d32efb6..05947f9 100644
> --- a/drivers/isdn/gigaset/gigaset.h
> +++ b/drivers/isdn/gigaset/gigaset.h
> @@ -20,6 +20,7 @@
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> =20
>  #include <linux/kernel.h>
> +#include <linux/sched.h>
>  #include <linux/compiler.h>
>  #include <linux/types.h>
>  #include <linux/ctype.h>

Acked-by: Tilman Schmidt <tilman@imap.cc>

in case it still matters.

Thanks again,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigC3F2EF1F61AD8624EE0C6337
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkvM0KwACgkQQ3+did9BuFs6+QCfWTWNIGnEda6mVCZqmGEbnYPi
3oIAoIzvHLbgXLh2YePYwUKL7ijKyNoQ
=w8PZ
-----END PGP SIGNATURE-----

--------------enigC3F2EF1F61AD8624EE0C6337--
