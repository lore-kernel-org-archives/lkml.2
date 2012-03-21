Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab2CUAjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 20:39:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54850 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab2CUAjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 20:39:05 -0400
Date: Wed, 21 Mar 2012 11:38:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Ungerer <gerg@snapgear.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the tip tree with the m68knommu
 tree
Message-Id: <20120321113852.93618d6fa5977e9a71caa298@canb.auug.org.au>
In-Reply-To: <20120302134903.7992cf17cb0c50b9a2b3842c@canb.auug.org.au>
References: <20120302134903.7992cf17cb0c50b9a2b3842c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Mar_2012_11_38_52_+1100_Ybw/a6oOP4kupOgk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Mar_2012_11_38_52_+1100_Ybw/a6oOP4kupOgk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg, Geert,

On Fri, 2 Mar 2012 13:49:03 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the tip tree got conflicts in
> arch/m68k/kernel/process_no.c and arch/m68k/kernel/process_mm.c between
> commit 8d8b74c955fd ("m68k: merge the MMU and non-MMU versions of
> process.c") from the m68knommu tree and commit bd2f55361f18 ("sched/rt:
> Use schedule_preempt_disabled()") from the tip tree.

That tip tree commit is now in Linus' tree, so I am now applying the
patch below after merging the m68knommu tree.

> The former merged these two files into a single process.c, so I removed
> them.  I then applied the following merge fix patch.
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 2 Mar 2012 13:43:03 +1100
> Subject: [PATCH] sched/rt: Use schedule_preempt_disabled() in m68k
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/m68k/kernel/process.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
> index f053e24..c54ef927 100644
> --- a/arch/m68k/kernel/process.c
> +++ b/arch/m68k/kernel/process.c
> @@ -78,9 +78,7 @@ void cpu_idle(void)
>  	while (1) {
>  		while (!need_resched())
>  			idle();
> -		preempt_enable_no_resched();
> -		schedule();
> -		preempt_disable();
> +		schedule_preempt_disabled();
>  	}
>  }
> =20
> --=20
> 1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__21_Mar_2012_11_38_52_+1100_Ybw/a6oOP4kupOgk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPaSMcAAoJEECxmPOUX5FEn/EQAKZLebHgOFAUxQniXOTcWy9U
74YkVtWAPXKq0IMLVJr0CJNPaLv5yS6a/8cm2pZq8Duxh3BDqzyC/UyYUR7YhT3z
GIQ/tR4QtiqDyUsHrWFLBLKDH/maWRWmeICMt/FYBStBn0OgpjRDMwsscadkSirh
PSJ69LfZM+Zv1N7aBGG1BsW4UUQ1r9ilyOBwRXTt/J+wKvacLwUGe/dwKbxcl0LS
TBgx5U/CPb6bUH4JDGGRB/ecrbKBOAkRaoooAYTozqSccvGHf9v0fTZYKOr92FMh
A53Imkpo/fQ/U/2A99d040WulGfn3TRmsnCe+GvlBkK2+2PLN/QLxGD2TlpEpPcG
EqwvjJGpcT4YOTXd/K52kf1qmKbwnROXTQCJiDpMa8yJJNIdGv6KxeD06cfXtnyX
ej3NOQ26naKOSF6+/PuCey61DcupV05cW69fqK6Y8DEcCdP9B6g9XkrVq+VLroZc
+86qCOpYzG/u0Rzr3Gr7tpCMgdLoBK1wSU3IrA4/GkdFBdII1vNp7eigNM9xnLnq
kFAEAjZB3KfObfnc9XtSDwANpdkJ0oSf9iPFLmkBKXlLuA8PvNXB8OJnAT1QOvvr
5XzHUASImPczau6jIybUotMWqPtAiSYvuQBjt2ZEKkJq5+8TriDms5JRYNgfkPHy
kNdKPOx6Ck3WqZciKhCT
=Cb9/
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Mar_2012_11_38_52_+1100_Ybw/a6oOP4kupOgk--
