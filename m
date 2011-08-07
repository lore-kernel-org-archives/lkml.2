Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab1HGUBO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 16:01:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39647 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab1HGUBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 16:01:10 -0400
Message-ID: <4E3EEED2.7070201@gentoo.org>
Date: Sun, 07 Aug 2011 23:00:18 +0300
From: Stratos Psomadakis <psomas@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Amirali Shambayati <amirali.shambayati@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org
Subject: Re: Compile kernel for various times and problem of too long time
 consuming
References: <CAC-yRPQS7r-MMh13Y1m0O+oLBu2OmQqmXS8iHFtCOS9YwrxrkA@mail.gmail.com> <20110807110429.57161269.rdunlap@xenotime.net> <CAC-yRPTFiU4AwtcpDNse3+eRjjprVPYng9WFbYJMf_Ebe8MGYQ@mail.gmail.com>
In-Reply-To: <CAC-yRPTFiU4AwtcpDNse3+eRjjprVPYng9WFbYJMf_Ebe8MGYQ@mail.gmail.com>
X-Enigmail-Version: 1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig06F55FC4684121B96BDA62D2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig06F55FC4684121B96BDA62D2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/07/2011 10:48 PM, Amirali Shambayati wrote:
> Would you say how you rebuild kernel?
>
> On Sun, Aug 7, 2011 at 10:34 PM, Randy Dunlap <rdunlap@xenotime.net> wr=
ote:
>> On Sun, 7 Aug 2011 21:39:12 +0430 Amirali Shambayati wrote:
>>
>>> Hi all,
>>> Since I want to evaluate performance improvements by changing just on=
e
>>> file in kernel(noop-iosched) and compiling kernel is too much
>>> time-consuming, I want to know that if I compile kernel for more than=

>>> one time, does it take similar time to first time?
>>>
>>> I use following commands. If I don't use "make-kpkg clean" for next
>>> times, does it just compile the files which have been modified or it
>>> compile whole kernel package again?
>>>
>>> make-kpkg clean
>>> fakeroot make-kpkg --initrd --append-to-version=3D-some-string-here
>>> kernel-image kernel-headers
>> Since I never use make-kpkg, I can only tell you that when I modified
>> block/noop-iosched.c and rebuilt the kernel, here is what was rebuilt:=

>>
>>  GEN     /lnx/src/NEXT/linux-next-20110805/X32/Makefile
>>  CHK     include/linux/version.h
>>  Using /lnx/src/NEXT/linux-next-20110805 as source for kernel
>>  CHK     include/generated/utsrelease.h
>>  CALL    /lnx/src/NEXT/linux-next-20110805/scripts/checksyscalls.sh
>>  CHK     include/generated/compile.h
>>  CHK     kernel/config_data.h
>>  CC      block/noop-iosched.o
>>  LD      block/built-in.o
>>  LD      vmlinux.o
>>  MODPOST vmlinux.o
>>  GEN     .version
>>  CHK     include/generated/compile.h
>>  UPD     include/generated/compile.h
>>  CC      init/version.o
>>  LD      init/built-in.o
>>  LD      .tmp_vmlinux1
>>  KSYM    .tmp_kallsyms1.S
>>  AS      .tmp_kallsyms1.o
>>  LD      .tmp_vmlinux2
>>  KSYM    .tmp_kallsyms2.S
>>  AS      .tmp_kallsyms2.o
>>  LD      vmlinux
>>  SYSMAP  System.map
>>  SYSMAP  .tmp_System.map
>>  Building modules, stage 2.
>>  VOFFSET arch/x86/boot/voffset.h
>>  CC      arch/x86/boot/version.o
>>  OBJCOPY arch/x86/boot/compressed/vmlinux.bin
>>  LZMA    arch/x86/boot/compressed/vmlinux.bin.lzma
>>  MODPOST 575 modules
>>  MKPIGGY arch/x86/boot/compressed/piggy.S
>>  AS      arch/x86/boot/compressed/piggy.o
>>  LD      arch/x86/boot/compressed/vmlinux
>>  ZOFFSET arch/x86/boot/zoffset.h
>>  OBJCOPY arch/x86/boot/vmlinux.bin
>>  AS      arch/x86/boot/header.o
>>  LD      arch/x86/boot/setup.elf
>>  OBJCOPY arch/x86/boot/setup.bin
>>  BUILD   arch/x86/boot/bzImage
>> Setup is 14972 bytes (padded to 15360 bytes).
>> System is 1287 kB
>> CRC 64ecf4d
>> Kernel: arch/x86/boot/bzImage is ready  (#18)
>>
>>
>> so it's a minimal rebuild, not a full kernel rebuild.
>>
>> ---
>> ~Randy
>> *** Remember to use Documentation/SubmitChecklist when testing your co=
de ***
>>
just run a make at the toplevel kernel sources directory...if you change
just one file, make won't rebuild everything, just what it needs to be
rebuilt and 'relinked'...

you're rebuilding the whole kernel every time, because you're running
make-pkg clean, which I think runs make clean and cleans every object
file you've built so far...

--=20
Stratos Psomadakis
<psomas@gentoo.org>



--------------enig06F55FC4684121B96BDA62D2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk4+7t0ACgkQid1lVeNDMmCqBACfQNBbtb1zmwOF00+JhblNp8UW
djMAoKRUVqRO7bTJaZdjw4C3x+zw557s
=bQT5
-----END PGP SIGNATURE-----

--------------enig06F55FC4684121B96BDA62D2--
