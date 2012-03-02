Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab2CBGwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 01:52:12 -0500
Received: from mail.southpole.se ([193.12.106.18]:43887 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab2CBGwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 01:52:10 -0500
Message-ID: <1330671102.19557.100.camel@satguru>
Subject: Re: [PATCH 3/5] OpenRISC: Export memory_start and memory_end
From: Jonas Bonn <jonas@southpole.se>
To: Richard Weinberger <richard@nod.at>
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org
Date: Fri, 02 Mar 2012 07:51:42 +0100
In-Reply-To: <1330649715-32438-3-git-send-email-richard@nod.at>
References: <1330649715-32438-1-git-send-email-richard@nod.at>
	 <1330649715-32438-3-git-send-email-richard@nod.at>
Organization: South Pole Consulting AB
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-lSTir1mnq4mtqBH548Z+"
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 71129-11880
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--=-lSTir1mnq4mtqBH548Z+
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-03-02 at 01:55 +0100, Richard Weinberger wrote:
> At least virt_addr_valid() makes use of memory_end.

virt_addr_valid looks broken... it shouldn't be comparing a virtual
address against memory_end which is phys_addr_t.

/Jonas

>=20
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/openrisc/include/asm/page.h |    4 ++--
>  arch/openrisc/kernel/setup.c     |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/openrisc/include/asm/page.h b/arch/openrisc/include/asm=
/page.h
> index b041b34..4dfe477 100644
> --- a/arch/openrisc/include/asm/page.h
> +++ b/arch/openrisc/include/asm/page.h
> @@ -71,8 +71,8 @@ typedef struct page *pgtable_t;
>  #define __pgd(x)	((pgd_t) { (x) })
>  #define __pgprot(x)	((pgprot_t) { (x) })
> =20
> -extern unsigned long memory_start;
> -extern unsigned long memory_end;
> +extern phys_addr_t memory_start;
> +extern phys_addr_t memory_end;
> =20
>  #endif /* !__ASSEMBLY__ */
> =20
> diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
> index bf5eba2..c993c92 100644
> --- a/arch/openrisc/kernel/setup.c
> +++ b/arch/openrisc/kernel/setup.c
> @@ -52,6 +52,7 @@
>  #include "vmlinux.h"
> =20
>  char __initdata cmd_line[COMMAND_LINE_SIZE] =3D CONFIG_CMDLINE;
> +phys_addr_t memory_start, memory_end;
> =20
>  static unsigned long __init setup_memory(void)
>  {
> @@ -59,7 +60,6 @@ static unsigned long __init setup_memory(void)
>  	unsigned long ram_start_pfn;
>  	unsigned long free_ram_start_pfn;
>  	unsigned long ram_end_pfn;
> -	phys_addr_t memory_start, memory_end;
>  	struct memblock_region *region;
> =20
>  	memory_end =3D memory_start =3D 0;


--=-lSTir1mnq4mtqBH548Z+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk9Qbf4ACgkQ70gcjN2673MbFwCgmzJH/JmzlgfLrR11c83ZwAmF
U/MAmQGTR7A2nxRwjS3JhocgT0Q3GzF6
=d2k8
-----END PGP SIGNATURE-----

--=-lSTir1mnq4mtqBH548Z+--

