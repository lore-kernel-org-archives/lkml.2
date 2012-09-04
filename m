Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab2IDNDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 09:03:35 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47832 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab2IDNDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 09:03:33 -0400
Date: Tue, 4 Sep 2012 23:03:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rob Herring <robherring2@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 arm-current tree
Message-Id: <20120904230323.4e7e4a9b1b73644ef44236cd@canb.auug.org.au>
In-Reply-To: <5045F7A0.1090400@gmail.com>
References: <20120904160626.f1dcb67ebbb145053c49da8c@canb.auug.org.au>
	<201209040808.25103.arnd@arndb.de>
	<20120904090132.GG24085@n2100.arm.linux.org.uk>
	<5045F7A0.1090400@gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Sep_2012_23_03_23_+1000_XV.I60l6R4VAr+ZV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Sep_2012_23_03_23_+1000_XV.I60l6R4VAr+ZV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rob,

On Tue, 04 Sep 2012 07:44:16 -0500 Rob Herring <robherring2@gmail.com> wrot=
e:
>
> Right. The PCI i/o reserved area has a dummy physical address of 0 and=20
> needs to be skipped by ioremap searches. So we don't set=20
> VM_ARM_STATIC_MAPPING to prevent matches by ioremap. The vm_struct settin=
gs
> don't really matter when we do the real mapping of the i/o space.
>=20
> Here's my merge:

Thanks, I shall use this in tomorrow's tree.

> diff --cc arch/arm/mm/mmu.c
> index 4c2d045,c2fa21d,512b2c0..18144e6
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@@@ -785,6 -785,6 -786,19 +786,19 @@@@ void __init iotable_init(struct m=
ap_des
>         }
>    }
>   =20
> ++ void __init vm_reserve_area_early(unsigned long addr, unsigned long si=
ze,
> ++                                void *caller)
> ++ {
> ++      struct vm_struct *vm;
> ++=20
> ++      vm =3D early_alloc_aligned(sizeof(*vm), __alignof__(*vm));
> ++      vm->addr =3D (void *)addr;
> ++      vm->size =3D size;
>   -     vm->flags =3D VM_IOREMAP | VM_ARM_STATIC_MAPPING;
> +++     vm->flags =3D VM_IOREMAP | VM_ARM_EMPTY_MAPPING;
> ++      vm->caller =3D caller;
> ++      vm_area_add_early(vm);
> ++ }
> ++=20

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__4_Sep_2012_23_03_23_+1000_XV.I60l6R4VAr+ZV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQRfwbAAoJEECxmPOUX5FEJFEP/A3eBKmbTLiOUNDQW3Bi4Fej
6ul/LtfeRnmkfNRAI0/Dz/vJSDe2a8qDYaJXcTRcYOFUndg0hSQ59J30w1lwvfCu
gJHx6rlg8lTz6ZHZGYzHk/49ZJUkJJsn8syfld4Sf4YdlU/Wk8JFr3rD4UZMUXSR
gkSwAPkjVIKU3FnVMEXxbqC/GjOeonDk4hSANN8TMDFGGz6svMUuEP3J/iYHB4Of
xsPG/vHAmF0z2/oiMRW3Fugc8SDLnf/ReFwY20OOj9uEwkSLXkxpGFeTc91IdqLK
8auEoIhy7B7jlHHV60hDDFI7YqvbuQBZ1/Nm94omwGcK6II939FnLJIAv6OuAgRc
1lA9FTifLqYV3CVb5DXvQ08vzWxjbm6/A7tEt+kzR3RaoC5MzMWoaXInDyfqPeI7
jrvJmkIRzvzmXCilbSwrRvgYzte8aXkhP3uGc8XGwhN0VtXf/Pk+P/DvcBElsouW
2e34bEAa6zMwPzj3xFMY+ZeY6V46VvjHQReI0fH6SlKmerZwj/xLCv787y0OhQ7f
yyFn4V1EGxESlRbod6t+FXv/oWqVCl7UJugrLfeE2z490hNaZ6o/rNPcHC82Tlfx
CGb19cQNFL4/6ZmzwQDW/enNzG45mIb8KGJ7K13Dl0bJNtvB7fZU0HQJVLtObbNo
5kGFhYj8Acm7cj9vZdQ6
=uf1e
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Sep_2012_23_03_23_+1000_XV.I60l6R4VAr+ZV--
