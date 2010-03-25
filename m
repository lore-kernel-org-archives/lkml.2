Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab0CYEnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 00:43:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42657 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab0CYEnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 00:43:15 -0400
Date: Thu, 25 Mar 2010 15:43:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: linux-next: build failure after merge of the kgdb tree
Message-Id: <20100325154307.9cdeae10.sfr@canb.auug.org.au>
In-Reply-To: <20100323150443.608ad7f0.sfr@canb.auug.org.au>
References: <20100323150443.608ad7f0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__25_Mar_2010_15_43_07_+1100_klyDtB+uwJAmFzl1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Mar_2010_15_43_07_+1100_klyDtB+uwJAmFzl1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jason, Dmitry,

On Tue, 23 Mar 2010 15:04:43 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the kgdb tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> kernel/debug/kdb/kdb_main.c: In function 'kdb_sr':
> kernel/debug/kdb/kdb_main.c:1822: error: '__sysrq_enabled' undeclared (fi=
rst use in this function)
>=20
> Caused by commit ab28988df9667f8dd70c7434c8ca463beb00b300 ("kdb: core for
> kgdb back end (1 of 2)") from the kgdb tree interacting with commit
> edc6e384f9d96e54a6d03068d3b03fa5b56b6449 ("") fromInput: implement SysRq
> as a separate input handler the input tree.

I got this again today (I stopped reverting the input tree commits that I
was reverting for another build problem).  The patch below still seems to
work OK.

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 23 Mar 2010 14:45:22 +1100
> Subject: [PATCH] kgdb: update for sysrq handling change
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  kernel/debug/kdb/kdb_main.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
> index f1f9309..bad8e63 100644
> --- a/kernel/debug/kdb/kdb_main.c
> +++ b/kernel/debug/kdb/kdb_main.c
> @@ -1819,10 +1819,8 @@ static int kdb_sr(int argc, const char **argv)
>  {
>  	if (argc !=3D 1)
>  		return KDB_ARGCOUNT;
> -	if (!__sysrq_enabled) {
> -		kdb_printf("Auto activating sysrq\n");
> -		__sysrq_enabled =3D 1;
> -	}
> +
> +	sysrq_toggle_support(1);
> =20
>  	kdb_trap_printk++;
>  	handle_sysrq(*argv[1], NULL);

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__25_Mar_2010_15_43_07_+1100_klyDtB+uwJAmFzl1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuq6dsACgkQjjKRsyhoI8yddQCeKjotJHOjMUAGnWfr+jshttjM
djgAn2LR02RvVwP/BtWW6sbNxjSdgabN
=vMT0
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Mar_2010_15_43_07_+1100_klyDtB+uwJAmFzl1--
