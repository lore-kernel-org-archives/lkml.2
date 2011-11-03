Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab1KCCJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:09:56 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:51258 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab1KCCJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 22:09:38 -0400
Date: Thu, 3 Nov 2011 13:09:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus <torvalds@linux-foundation.org>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20111103130924.5811caec6db378f467006fc3@canb.auug.org.au>
In-Reply-To: <20110913115533.403d4fe6d961ccc8ba9b58b7@canb.auug.org.au>
References: <20110912120501.764336af05069fa23a371b5e@canb.auug.org.au>
	<4E6D6C0D.60100@codeaurora.org>
	<20110913115533.403d4fe6d961ccc8ba9b58b7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_Nov_2011_13_09_24_+1100_F0bQ2TFBX66Sg01="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Nov_2011_13_09_24_+1100_F0bQ2TFBX66Sg01=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Tue, 13 Sep 2011 11:55:33 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Sun, 11 Sep 2011 19:18:53 -0700 Stephen Boyd <sboyd@codeaurora.org> wr=
ote:
> >
> > The device tree machine description also needs to have the .fixup and
> > .reserve callbacks added to it so that the device tree machines boot
> > properly. Perhaps the soc tree needs to pull in Russell's tree at some
> > point to resolve this subtle logical conflict or when the trees are
> > merged together someone will need to do an evil merge and add the
> > callbacks in the merge commit.
>=20
> Ah, right.  I have added this merge fixup for today and can carry it as
> necessary.

I am still applying this patch to the arm-soc merge.  I assume that it is
needed in Linus' tree now.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 13 Sep 2011 11:51:48 +1000
Subject: [PATCH] arm-soc: merge fixup for fixup/reserve being added to MACH=
INE descriptions

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/mach-msm/board-msm8x60.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-ms=
m8x60.c
index 328df27..4ad2afb 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -153,6 +153,8 @@ MACHINE_END
 #ifdef CONFIG_OF
 /* TODO: General device tree support for all MSM. */
 DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
+	.fixup =3D msm8x60_fixup,
+	.reserve =3D msm8x60_reserve,
 	.map_io =3D msm8x60_map_io,
 	.init_irq =3D msm8x60_init_irq,
 	.init_machine =3D msm8x60_dt_init,
--=20
1.7.5.4


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Nov_2011_13_09_24_+1100_F0bQ2TFBX66Sg01=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOsffUAAoJEECxmPOUX5FE8w8P/2gPsqrqM8Nj1jYdA1PwnNSq
78yPE6z+lpz1FUpEqVgd9hU6MUTBABYMMTjM86j0D1l256+Z1gunEX5OTdY8W5sn
CVLMs2FEl5VEHrqV7oQOdL+DO/LsDhFjc1iUCc+QUeiBQJgJb+75PCAL0EZ8QhLD
/KOt7MAgg3uA27smGF1RLRQeRl6LiN5rKE1Cr8T+l09hPS/hrJ9UPlK57/DXMwjP
lWWuSZ+Nf530FU8IqL64XMTE034WqtrQpm/ggc+mH/Xqx2fLEHoNYvtEUu31/yap
CTOqZ6m6cmxZsooPlDN0RbPVRjQ3RIBV76TB+QlxNS70qF5aqMp7c+c/gQ4M9VRK
zzxoDDXuoq32tYvh/zHir2W3ugqLyojKrgyWAX6dfm37dMUZfz8dKtgNU6gIrCER
tOxTdo2o3/ivibwVpr3bXX9tP1rQxlcmjXYh4SF2PsjcJCOpuKysYzkO4wiXcYPx
/nsOIuGEOXIqEg/690IVvTY1dS/j0twBNn6HdY9WTYhWruIpRj+7U8FwuQx7u8yx
OOF9mGzO6s4IaNwH9q7YPzqKVphRXNY+16Adb8scm4k3DqH7L+0dmuhYGs75CJOv
UNdzdjd8Pn/NkmRK9DyJihRbzKcfRdxId6qBTEAjm2pPFN3A/h3jpEIrdHAk/cNd
rnHt64KXIbkYaoSZxQQS
=bRW9
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Nov_2011_13_09_24_+1100_F0bQ2TFBX66Sg01=--
