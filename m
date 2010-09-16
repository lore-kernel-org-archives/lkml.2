Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab0IPGov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:44:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48335 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab0IPGou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:44:50 -0400
Date: Thu, 16 Sep 2010 16:44:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sundar R IYER <sundar.iyer@stericsson.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
        Daniel Walker <dwalker@fifo99.com>,
        Russell King <rmk@arm.linux.org.uk>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: FW: next build fails
Message-Id: <20100916164442.df749cc1.sfr@canb.auug.org.au>
In-Reply-To: <33A307AF30D7BF4F811B1568FE7A9B18043784FF99@EXDCVYMBSTM006.EQ1STM.local>
References: <33A307AF30D7BF4F811B1568FE7A9B18043784FF99@EXDCVYMBSTM006.EQ1STM.local>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Sep_2010_16_44_42_+1000_w9l7vRwhnh3fkipN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Sep_2010_16_44_42_+1000_w9l7vRwhnh3fkipN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 16 Sep 2010 07:44:54 +0200 Sundar R IYER <sundar.iyer@stericsson.co=
m> wrote:
>
> I am getting this build failure for our u8500_defconfig. I think some
> patch hasn't got completely merged. I patched it up at my end,=20
> but would like to know if this is valid.
>=20
> ----------------------------------------------------------------
> commit 3ee465868d599f83d4851f9b86727071c55fd726
> Author: Sundar Iyer <sundar.iyer@stericsson.com>
> Date:   Wed Sep 15 12:27:10 2010 +0530
>=20
>     ARM: fix build failure for legacy PMD_FLAGS
>=20
>     Acked-by: Linus Walleij <linus.walleij@stericsson.com>
>     Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
>=20
> diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S index 820f6ba.=
.f3cc9f6 100644
> --- a/arch/arm/mm/proc-v7.S
> +++ b/arch/arm/mm/proc-v7.S
> @@ -337,7 +337,7 @@ __v7_ca9mp_proc_info:
>         .long   PMD_TYPE_SECT | \
>                 PMD_SECT_AP_WRITE | \
>                 PMD_SECT_AP_READ | \
> -               PMD_FLAGS
> +               PMD_FLAGS_UP
>         .long   PMD_TYPE_SECT | \
>                 PMD_SECT_XN | \
>                 PMD_SECT_AP_WRITE | \
>=20

This is due to a mismerge (in linux-next) between commit
dc966984f44f16b8bb6b0644e501c7c2163ead69 ("ARM: Allow SMP kernels to boot
on UP systems") from the arm tree (which renamed PMD_FLAGS to
PMD_FLAGS_UP) and commit b7bc5d9c6556e3ca37176784036380f91b53432c ("arm:
mm: add proc info for ARM11MPCore/Cortex-A9 from ARM") from the msm tree
(which added a new use of PMD_FLAGS).

I will add the above patch as a merge fixup to my tree until the msm tree
gets merged into the arm tree (or vice versa or they both are merged into
Linus' tree).

Thanks for the heads up.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Sep_2010_16_44_42_+1000_w9l7vRwhnh3fkipN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMkbzaAAoJEDMEi1NhKgbsShoIAJE6cUEPZzl91aHBnNDVvKS1
Ap7Lplqke+j9oy7hJzGa4emay5fwnEElG1eWNZmabXGhGJf8HfsH1tnStXvn5ynx
v/o/A+ENuAzbXvnYLQj2kRi19sPTD2nfrz0ofWI3FrtCzyaOPJI3NaYNel6lzIWC
0wScZMUa2FZ1aRkWtossb73EOKK3nPdToi2DPPyGW8qoX6ZLdbMdQiuSlRC8l8Ku
vvjp9cd0ibMASWTuDG4YLq7qdc+U6QdX8Nd+wftVAz+q0b1IBC4ow/Mc2s1FKRoE
wm9DxTlD84S2O5oV/Cs7eQM/mUqGodWZ3/WJ0Wy5gfMXyYRKi5JC2rGTIAU4s+U=
=wGvU
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Sep_2010_16_44_42_+1000_w9l7vRwhnh3fkipN--
