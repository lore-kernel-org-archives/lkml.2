Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab2F3Knd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 06:43:33 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63365 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab2F3Knb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 06:43:31 -0400
Message-ID: <1341052998.2115.3.camel@koala>
Subject: Re: UBI fastmap updates
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, nyoushchenko@mvista.com,
        artem.bityutskiy@linux.intel.com, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Heinz.Egger@linutronix.de,
        thomas.wucher@linutronix.de, shmulik.ladkani@gmail.com,
        tglx@linutronix.de, Marius.Mazarel@ugal.ro, tim.bird@am.sony.com
Date: Sat, 30 Jun 2012 13:43:18 +0300
In-Reply-To: <1340982869-77042-1-git-send-email-richard@nod.at>
References: <1340982869-77042-1-git-send-email-richard@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-tMePQ8Cd3G8uV1DnPKdF"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tMePQ8Cd3G8uV1DnPKdF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-06-29 at 17:14 +0200, Richard Weinberger wrote:
> This is the next round of UBI fastmap updates.
>=20
> Fastmap is now disabled by default.
> If you attach an image it will not automatically convert it
> to the fastmap format.
> UBI has a new module parameter "fm_auto".
> If set to 1 UBI will create a fastmap automatically on your
> flash device.
> Please see commit "Add a module parameter to enable fastmap"
> for more details.

One thing I've noticed is that you use vmalloc for some of the buffers
you do I/O on (fm_raw). This is a problem for many ARM platforms because
they cannot do DMA on such buffers. The drivers have to implement
various workarouns for this: either fall back to memcopies or do an
extra copy to a DMA-able buffers.

UBI and UBIFS already to I/O on vmalloc'ed buffers, an I am planning to
fix this, which is not easy. Would be great to not add more of these.

--=20
Best Regards,
Artem Bityutskiy

--=-tMePQ8Cd3G8uV1DnPKdF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP7thGAAoJECmIfjd9wqK0fIkP/2PjNbJFA0hCh3dc1+UIUm9A
L8xHw4QEtinTbe1ISnv3djnF6QjXGRBmi13+vMnB3br0rxltmMlaRlaGaY640lyK
PUSXrD/mNiMpRyuOv0vrlyXiq4tjcYkPEqKFqo7Z5C2pgqMeXAKD7dkTKQYwRzbf
np9ulcpkCDQA4/AmXkI1KnxD3urXwZ7GrxSJlFNOdIMGOCa0tU5VrMtp0jay9Gzh
SeE3rHUacypOEnEmELt+/PIsnyxGpu5quP1WeIJni2ltVoSjMjKUDCXIy4DtXHf+
UrgUjB/RkxDfvTwKjutO2i6lMCSt0ZGB7g+FhE9mOidsGwsdvPvKbl3owE57F085
iRRGbWK+NSaxbzV6aDQneAlJJvARHCg4kCpPm7dfttc2h/IscSmq/xD3ZF4UHViu
KZFzJXcCV7I8BOf0wwtjjzEHvlFf9YL5oDHhxvJo54XUhzrMy/W2GzRjf83aNVSF
ADn+8VJygrQhGoWW92SsG6XDKqdR6Ar+sEjjKkTK3ai/2+jDgrA++9XUKSYn20Uo
KC14L2ahK37VLroyUC7dLyoAmYAvsleoQXiT6IrY8LrT/njQpMbJzzvqJ317H7Jz
bdeoknqnLXJnHPrxeufMgEADSWar7n+x1VgLqqXXCuao+cvu0MVtkmCFMaZwAnNL
FUXGhZp0MTq0UcF7ZILx
=X9m9
-----END PGP SIGNATURE-----

--=-tMePQ8Cd3G8uV1DnPKdF--

