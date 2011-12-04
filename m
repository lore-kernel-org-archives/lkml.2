Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab1LDRjF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 12:39:05 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43716 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab1LDRjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 12:39:03 -0500
Message-ID: <4EDBB02F.8070106@gentoo.org>
Date: Sun, 04 Dec 2011 19:38:55 +0200
From: Stratos Psomadakis <psomas@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        JBottomley@parallels.com, matthew@wil.cx, Martin.vGagern@gmx.net
Subject: Re: [PATCH] scsi/sym53c8xx_2: Fix NULL pointer dereference in slave_destroy
References: <1322958234-9749-1-git-send-email-psomas@gentoo.org>
In-Reply-To: <1322958234-9749-1-git-send-email-psomas@gentoo.org>
X-Enigmail-Version: 1.3.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2381399EFD701D1BF6F3A34D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2381399EFD701D1BF6F3A34D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/04/2011 02:23 AM, psomas@gentoo.org wrote:
> From: Stratos Psomadakis <psomas@gentoo.org>
>
> sym53c8xx_slave_destroy unconditionally assumes that sym53c8xx_slave_al=
loc has
> succesesfully allocated a sym_lcb. This can lead to a NULL pointer dere=
ference
> (exposed by commit 4e6c82b).
>
> Signed-off-by: Stratos Psomadakis <psomas@gentoo.org>
> Cc: stable@vger.kernel.org
Reported-by:  Martin von Gagern <Martin.vGagern@gmx.net>
Tested-by: Martin von Gagern <Martin.vGagern@gmx.net>

> ---
>
>  drivers/scsi/sym53c8xx_2/sym_glue.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8=
xx_2/sym_glue.c
> index b4543f5..76432f8 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_glue.c
> +++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
> @@ -839,6 +839,10 @@ static void sym53c8xx_slave_destroy(struct scsi_de=
vice *sdev)
>  	struct sym_lcb *lp =3D sym_lp(tp, sdev->lun);
>  	unsigned long flags;
> =20
> +	/* if slave_alloc returned before allocating a sym_lcb, return */
> +	if (!lp)
> +		return;
> +
>  	spin_lock_irqsave(np->s.host->host_lock, flags);
> =20
>  	if (lp->busy_itlq || lp->busy_itl) {
--=20
Stratos Psomadakis
<psomas@gentoo.org>



--------------enig2381399EFD701D1BF6F3A34D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7bsC8ACgkQid1lVeNDMmB7igCffkbgFNgsjoLsSLSlAPxOflxd
ws0An20GlVqiK0rGk1VNx+rNg8zFozRs
=ms1Y
-----END PGP SIGNATURE-----

--------------enig2381399EFD701D1BF6F3A34D--
