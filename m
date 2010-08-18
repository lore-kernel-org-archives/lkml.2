Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab0HRA4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 20:56:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43667 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab0HRA4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 20:56:19 -0400
Date: Wed, 18 Aug 2010 10:56:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: John Johansen <john.johansen@canonical.com>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: linux-next: Fix AppArmor build warnings after merge of the
 security-testing tree
Message-Id: <20100818105609.642a5e61.sfr@canb.auug.org.au>
In-Reply-To: <4C57819F.4000405@canonical.com>
References: <20100802121601.363af4a9.sfr@canb.auug.org.au>
	<4C57819F.4000405@canonical.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__18_Aug_2010_10_56_09_+1000_C_M=OzKi4VFUXLVO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Aug_2010_10_56_09_+1000_C_M=OzKi4VFUXLVO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 02 Aug 2010 19:40:31 -0700 John Johansen <john.johansen@canonical.c=
om> wrote:
>
> the follow patch fixes the AppArmor build warnings from the security-next=
 tree merge

Thanks.

> From: John Johansen <john.johansen@canonical.com>
> Date: Mon, 2 Aug 2010 19:31:57 -0700
> Subject: [PATCH] AppArmor: Fix build warnings from linux-next merge
>=20
> Patch AppArmor to fix build warnings for changes that exist in the
> linux-next tree.
>=20
> Signed-off-by: John Johansen <john.johansen@canonical.com>
	.
	.
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> index d5666d3..f56978a 100644
> --- a/security/apparmor/lsm.c
> +++ b/security/apparmor/lsm.c
> @@ -607,9 +607,11 @@ static int apparmor_setprocattr(struct task_struct *=
task, char *name,
>  	return error;
>  }
> =20
> -static int apparmor_task_setrlimit(unsigned int resource,
> +static int apparmor_task_setrlimit(struct task_struct *tsk,
> +				   unsigned int resource,
>  				   struct rlimit *new_rlim)
>  {
> +	/* Use current profile instead of profile on @tsk */
>  	struct aa_profile *profile =3D aa_current_profile();
>  	int error =3D 0;

This last change seems to have been lost along the way.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__18_Aug_2010_10_56_09_+1000_C_M=OzKi4VFUXLVO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEbBAEBAgAGBQJMay+pAAoJEDMEi1NhKgbsrioH93zeZH4ArwPMBucHH1tAmgGD
nicV8GF7akmqVVw/bJZl9MRUIqaEHx+YgVglmaqwUn5M7uJOA708qEYT9o0iImNx
59bRnUuH2DmaAHY0L7VCaKN4uyExKr6hDIhiUzDYHk0KGeZrwssyXP56oXkGTAhe
6AvDLsk51gotxwXEfCDmyhHLWpi0f1Ab0/wtSpvup0W4V6qhU8OFRC98EjSh7p+D
Ct7FYKDvZzeVp1vjxqXKg+e84dRb+Nxo923bfMJbLlUwXzdqJatH/943eGKnvYJW
KYNwk97GffswYoQuKf2iDw898Xi2+BbeNG5MiK7oQRqA8xfvSOES+eEXlG9/oA==
=XQi8
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Aug_2010_10_56_09_+1000_C_M=OzKi4VFUXLVO--
