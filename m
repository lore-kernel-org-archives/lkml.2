Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab1CWBA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 21:00:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45841 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab1CWBA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 21:00:56 -0400
Date: Wed, 23 Mar 2011 12:00:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V4 1/5] cpuidle: Remove pm_idle pointer for x86
Message-Id: <20110323120044.bb8c0ae1.sfr@canb.auug.org.au>
In-Reply-To: <20110322123223.28725.21929.stgit@tringupt.in.ibm.com>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
	<20110322123223.28725.21929.stgit@tringupt.in.ibm.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Mar_2011_12_00_44_+1100_=scsemJbiHUvQ.Xl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Mar_2011_12_00_44_+1100_=scsemJbiHUvQ.Xl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Just some simple comments.

Does having this patch first in the series break APM idle?

On Tue, 22 Mar 2011 18:02:27 +0530 Trinabh Gupta <trinabh@linux.vnet.ibm.co=
m> wrote:
>
> diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> index 8d12878..17b7101 100644
> --- a/arch/x86/kernel/process_32.c
> +++ b/arch/x86/kernel/process_32.c
> @@ -74,6 +74,8 @@ static inline void play_dead(void)
>  }
>  #endif
> =20
> +extern void cpuidle_idle_call(void);

Put this declaration in a header file and include that header file here
and in the file that defines that function.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Mar_2011_12_00_44_+1100_=scsemJbiHUvQ.Xl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNiUY8AAoJEDMEi1NhKgbsuKgIAIr9IZRaFqkhVXwteJ5GC1yh
3uWm2mm72ACuFHUTUAuRgfjqgvUDd72fSU39hpNyVHPGdMmQeJiskXewliVUE6dg
Az3eBraG63tVXHQW5ss5QgUlZGY1KIRCLo3Hg/HdKXkTSjHDMdjf+Kl0Hp1SJF58
p5iq3cLN8yltQ3GhMMn8xMMh/sm/XGS8m2Uj4Jg1Y7x0yFoPZ7lC8dCElLKj0m/g
dEjUjvEY1nYibIBWK/CidpDEE2tIBKp3tgTg6CJmL8L8sqZsb2n9MLLtvmyzwUDd
qmDaMhoE4w2LkwOMFs+YN9KAUsomFsZCNsE6gO97JkEcfwPuuFazoUoYCJI5K+c=
=c25P
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Mar_2011_12_00_44_+1100_=scsemJbiHUvQ.Xl--
