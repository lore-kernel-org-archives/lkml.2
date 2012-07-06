Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab2GFDBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 23:01:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42307 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab2GFDBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 23:01:48 -0400
Date: Fri, 6 Jul 2012 13:01:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Modra <amodra@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@bakeyournoodle.com
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20120706130137.6aae96c0072af1f330249c0d@canb.auug.org.au>
In-Reply-To: <20120706005709.GB5805@bubble.grove.modra.org>
References: <20120705183345.ee84ec1048a19aa1c7129578@canb.auug.org.au>
	<20120705094348.GA5805@bubble.grove.modra.org>
	<20120706102151.fd4f769cf2aa3f753ad178bf@canb.auug.org.au>
	<20120706005709.GB5805@bubble.grove.modra.org>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jul_2012_13_01_37_+1000_s=j1HxjYDcD0K1Na"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jul_2012_13_01_37_+1000_s=j1HxjYDcD0K1Na
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On Fri, 6 Jul 2012 10:27:10 +0930 Alan Modra <amodra@gmail.com> wrote:
>
> On Fri, Jul 06, 2012 at 10:21:51AM +1000, Stephen Rothwell wrote:
> > which have now been fixed.  So would a simple patch that puts the
> > _savegpr etc functions in their own section (defined how?) fix this for
> > us?
>=20
> Ah, the kernel provides its own save/restore functions, and these get
> mashed into a .text containing normal functions with toc references by
> ld -r.  Well, you could stop using ld -r.  Otherwise, try
>=20
>  .section ".text.save.restore","ax",@progbits

OK, so that helped a lot.  Now I get this:

drivers/built-in.o: In function `.idt77252_init_ubr.isra.10':
idt77252.c:(.text+0x1ff801c): relocation truncated to fit: R_PPC64_REL24 ag=
ainst symbol `._mcount' defined in .text section in arch/powerpc/kernel/ent=
ry_64.o
drivers/built-in.o: In function `.idt77252_init_tx':
idt77252.c:(.text+0x1ff8258): relocation truncated to fit: R_PPC64_REL24 ag=
ainst symbol `._mcount' defined in .text section in arch/powerpc/kernel/ent=
ry_64.o
drivers/built-in.o: In function `.idt77252_change_qos':
idt77252.c:(.text+0x1ff86a0): relocation truncated to fit: R_PPC64_REL24 ag=
ainst symbol `._mcount' defined in .text section in arch/powerpc/kernel/ent=
ry_64.o
drivers/built-in.o: In function `.idt77252_open':
idt77252.c:(.text+0x1ff898c): relocation truncated to fit: R_PPC64_REL24 ag=
ainst symbol `._mcount' defined in .text section in arch/powerpc/kernel/ent=
ry_64.o
idt77252.c:(.text+0x1ff8f4c): relocation truncated to fit: R_PPC64_REL24 ag=
ainst symbol `_restgpr0_22' defined in .text.save.restore section in arch/p=
owerpc/lib/built-in.o
drivers/built-in.o: In function `.next_string':
solos-pci.c:(.text+0x1ff8f54): relocation truncated to fit: R_PPC64_REL24 a=
gainst symbol `_savegpr0_29' defined in .text.save.restore section in arch/=
powerpc/lib/built-in.o
solos-pci.c:(.text+0x1ff8f64): relocation truncated to fit: R_PPC64_REL24 a=
gainst symbol `._mcount' defined in .text section in arch/powerpc/kernel/en=
try_64.o
drivers/built-in.o: In function `.print_buffer':
solos-pci.c:(.text+0x1ff904c): relocation truncated to fit: R_PPC64_REL24 a=
gainst symbol `._mcount' defined in .text section in arch/powerpc/kernel/en=
try_64.o
drivers/built-in.o: In function `.atm_remove':
solos-pci.c:(.text+0x1ff91d4): relocation truncated to fit: R_PPC64_REL24 a=
gainst symbol `._mcount' defined in .text section in arch/powerpc/kernel/en=
try_64.o
solos-pci.c:(.text+0x1ff923c): relocation truncated to fit: R_PPC64_REL24 a=
gainst symbol `.sysfs_remove_group' defined in .text section in fs/built-in=
.o
drivers/built-in.o: In function `.fpga_tx':
solos-pci.c:(.text+0x1ff950c): additional relocation overflows omitted from=
 the output

I assume at this point, we are just too large.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__6_Jul_2012_13_01_37_+1000_s=j1HxjYDcD0K1Na
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP9lURAAoJEECxmPOUX5FEma8P/jg4rQ4qUlkGZlfPDLcD9vJJ
zOd832sPOWXowKwYortMlPCQAeyRY/EAAraBa2q2PWx8mkzDU0z2J3wn/l9JJpg0
U4/La53Z+FkhVf6McFwJ8gA0vR6VtknnPE64xTydWxelLxeBY2rf16DkYWu/1CjS
dToqMXPu+kGMOoL82xZ/v9KAaTd0fyANp5SUy/sg+5hTvhh0GEd12LPlosQvQV5n
9byHU7j1VL6TkfrQczmKA7AW6rkE2lxGaan1WmunfcJkvanHE4W7lVlilyerwaRM
7km8BThZrAqMhXciEG/o3k4uMapr2G0yHaOC5aSxoYDYFJJ0wOFdhigHfiWIQYxN
uquybpuv1ZFFVUHyKEaFBYImqwx3vANDqerglrnLFBROodptgCcPtOasR0/AZyQI
M0UE1/iiNCG9rBwfJVkOrbp+0i2NqmO5j7VAYTzcelHI3OExUECLKfKPtNkLjVyw
T3glwYHo0KMpeytJqiphdY+ug0RxgJhrVPukLzshDFekfAD7lcvcZNGsJoaB224I
qN5TgEXKdLSgzNWmDBz3uvVkBSaYTuewnxXfavivgaBv2MyKGtNZopAbTN4/T38S
wUreLkGwGbmvO/MtJ8q8guppqYTWqiW/TvrL3+StTvatuRkX6LNfPRYhKxr9IQcO
oMI2kByY36wlNhUhS3x+
=yxvD
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jul_2012_13_01_37_+1000_s=j1HxjYDcD0K1Na--
