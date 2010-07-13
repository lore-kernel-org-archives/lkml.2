Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab0GMJVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:21:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47421 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab0GMJVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:21:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=qV6SG+itHbYmBpq9G6kivzSOW8OZoIe1VQ5/XgSG2nWdnDc9RF/g6ZG9ZhSsfRWLDK
         DfyLtzjg7z44K4VWRP3ozjskfSDzM3EaubevNMeBawNqrHzXuIx+VjE719NpGJvrqBeU
         bWtfArYVr3QJhaM5NmCNnSuoFMZcqhqHgcGyA=
Message-ID: <4C3C3018.3080508@gmail.com>
Date: Tue, 13 Jul 2010 11:21:28 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: grub-devel@gnu.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix for relocatable PowerPC kernels
References: <20100713054523.GC10155@kryten>
In-Reply-To: <20100713054523.GC10155@kryten>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig36EF15B636270CE21977E02E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig36EF15B636270CE21977E02E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/13/2010 07:45 AM, Anton Blanchard wrote:
> Hi,
>
> PowerPC Linux kernels can now be built relocatable so we need to check
> for that in the loader.
>
> Anton
>
>  =20
Is building as ET_DYN supported upstream? We previously had reports of
building system of some distros to be plainly borked and usualy the
distro fixed their building system pretty fast. If upstream supports
ET_DYN, then this patch is accepted with no further questions. But if
it's a borked building system it may have subtle bugs and allowing it
would probably just suppress an early symptom of other problems.
> --
>
> 2010-07-13  Anton Blanchard  <anton@samba.org>
>
> 	* loader/powerpc/ieee1275/linux.c (grub_cmd_linux): Do not reject
> 	ET_DYN files.
>
> Index: grub/loader/powerpc/ieee1275/linux.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- grub.orig/loader/powerpc/ieee1275/linux.c	2010-07-11 12:05:16.44324=
2734 +1000
> +++ grub/loader/powerpc/ieee1275/linux.c	2010-07-12 14:56:20.301991065 =
+1000
> @@ -220,7 +220,7 @@ grub_cmd_linux (grub_command_t cmd __att
>    if (! elf)
>      goto out;
> =20
> -  if (elf->ehdr.ehdr32.e_type !=3D ET_EXEC)
> +  if (elf->ehdr.ehdr32.e_type !=3D ET_EXEC && elf->ehdr.ehdr32.e_type =
!=3D ET_DYN)
>      {
>        grub_error (GRUB_ERR_UNKNOWN_OS,
>  		  "this ELF file is not of the right type");
>
> _______________________________________________
> Grub-devel mailing list
> Grub-devel@gnu.org
> http://lists.gnu.org/mailman/listinfo/grub-devel
>
>  =20


--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko



--------------enig36EF15B636270CE21977E02E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAkw8MBgACgkQNak7dOguQgmL7wD/Y3OJ6bfC/WqgQwivbumZnPDC
LOM0HXsT41f/tLbM/b4BAJSwc4PQ2AceqpqF9DSzv9dcftA67DJT4Ef3ROWG4LlF
=c0kb
-----END PGP SIGNATURE-----

--------------enig36EF15B636270CE21977E02E--
