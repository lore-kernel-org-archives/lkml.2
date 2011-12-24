Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab1LXBUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 20:20:24 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40296 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab1LXBUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 20:20:22 -0500
Message-ID: <4EF528CC.1020800@gentoo.org>
Date: Sat, 24 Dec 2011 03:20:12 +0200
From: Stratos Psomadakis <psomas@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: JBottomley@parallels.com, matthew@wil.cx,
        James.Bottomley@HansenPartnership.com
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Martin.vGagern@gmx.net, kernel@gentoo.org
Subject: Re: [PATCH] scsi/sym53c8xx_2: Fix NULL pointer dereference in slave_destroy
References: <1322958234-9749-1-git-send-email-psomas@gentoo.org>
In-Reply-To: <1322958234-9749-1-git-send-email-psomas@gentoo.org>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE5289A1B0A86530A85E6EAAC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE5289A1B0A86530A85E6EAAC
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
resent (directly to the SCSI and sym53c8xx_2 maintainers)

--=20
Stratos Psomadakis
<psomas@gentoo.org>



--------------enigE5289A1B0A86530A85E6EAAC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk71KNEACgkQid1lVeNDMmCQAwCeM79TwQOH0QONKUaStLcmpdDv
sHsAoJDmw6w2x/iIpD1MIms5Iw+/3Awh
=75sb
-----END PGP SIGNATURE-----

--------------enigE5289A1B0A86530A85E6EAAC--
