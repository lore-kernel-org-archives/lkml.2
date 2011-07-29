Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab1G2Pde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 11:33:34 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65118 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1G2Pdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 11:33:32 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110729081319.0083b3ec.rdunlap@xenotime.net>
References: <CA+icZUV7R5hqTupiuZZKWcsZ5LOBGmY6xgmMTM7W3ojJo0Sp4w@mail.gmail.com>
	<20110728160136.771e2c0a.rdunlap@xenotime.net>
	<CA+icZUXLpThpEem+DPimemYVHqSKb5NAb5h_L-rMPWsD+WJTYg@mail.gmail.com>
	<20110728220926.6d1a91f4.rdunlap@xenotime.net>
	<CA+icZUVsJNSDzBvvH810POEydpaZxJZfM8J9bD+93+4d+88D_A@mail.gmail.com>
	<CA+icZUX=qM+xhJkteXs=F_RJP+k-Tzf3+Cp4ZdeatZ0cgHegBw@mail.gmail.com>
	<CA+icZUUZGfYasCCGKWNbFe5FFs1j15H+rc0jp_oO-uFqLVX=0A@mail.gmail.com>
	<20110729081319.0083b3ec.rdunlap@xenotime.net>
Date: Fri, 29 Jul 2011 17:33:31 +0200
Message-ID: <CA+icZUUa8eDfDDEwdk1o2Dh5fcNZh_2+UBxYsJk1tLLxsQETCQ@mail.gmail.com>
Subject: Re: linux-next: Tree for July 28 ("copy_from_user_overflow" undefined)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Helge Deller <deller@gmx.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: multipart/mixed; boundary=90e6ba309434f367dd04a93700c4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--90e6ba309434f367dd04a93700c4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 29, 2011 at 5:13 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Fri, 29 Jul 2011 13:07:16 +0200 Sedat Dilek wrote:
>
>> On Fri, Jul 29, 2011 at 11:45 AM, Sedat Dilek
>> <sedat.dilek@googlemail.com> wrote:
>> > On Fri, Jul 29, 2011 at 11:02 AM, Sedat Dilek
>> > <sedat.dilek@googlemail.com> wrote:
>> >> On Fri, Jul 29, 2011 at 7:09 AM, Randy Dunlap <rdunlap@xenotime.net> =
wrote:
>> >>> On Fri, 29 Jul 2011 03:34:26 +0200 Sedat Dilek wrote:
>> >>>
>> >>>> On Fri, Jul 29, 2011 at 1:01 AM, Randy Dunlap <rdunlap@xenotime.net=
> wrote:
>> >>>> > On Thu, 28 Jul 2011 16:05:31 +0200 Sedat Dilek wrote:
>> >>>> >
>> >>>> >> Hi,
>> >>>> >>
>> >>>> >> just see this build-break on the last mile:
>> >>>> >>
>> >>>> >> [...]
>> >>>> >> =C2=A0 OBJCOPY arch/x86/boot/compressed/vmlinux.bin
>> >>>> >> =C2=A0 HOSTCC =C2=A0arch/x86/boot/compressed/relocs
>> >>>> >> =C2=A0 HOSTCC =C2=A0arch/x86/boot/compressed/mkpiggy
>> >>>> >> /mnt/sdb3/linux-kernel/linux-3.0/debian/build/source_i386_none/a=
rch/x86/boot/compressed/relocs.c:
>> >>>> >> In function 'print_absolute_symbols':
>> >>>> >> /mnt/sdb3/linux-kernel/linux-3.0/debian/build/source_i386_none/a=
rch/x86/boot/compressed/relocs.c:405:14:
>> >>>> >> warning: variable 'sh_symtab' set but not used
>> >>>> >> [-Wunused-but-set-variable]
>> >>>> >> ERROR: "copy_from_user_overflow" [fs/binfmt_misc.ko] undefined!
>> >>>> >> make[5]: *** [__modpost] Error 1
>> >>>> >> make[4]: *** [modules] Error 2
>> >>>> >> make[4]: *** Waiting for unfinished jobs....
>> >>>> >> =C2=A0 RELOCS =C2=A0arch/x86/boot/compressed/vmlinux.relocs
>> >>>> >> =C2=A0 GZIP =C2=A0 =C2=A0arch/x86/boot/compressed/vmlinux.bin.gz
>> >>>> >> =C2=A0 MKPIGGY arch/x86/boot/compressed/piggy.S
>> >>>> >> =C2=A0 AS =C2=A0 =C2=A0 =C2=A0arch/x86/boot/compressed/piggy.o
>> >>>> >> =C2=A0 LD =C2=A0 =C2=A0 =C2=A0arch/x86/boot/compressed/vmlinux
>> >>>> >> =C2=A0 ZOFFSET arch/x86/boot/zoffset.h
>> >>>> >> =C2=A0 OBJCOPY arch/x86/boot/vmlinux.bin
>> >>>> >> =C2=A0 AS =C2=A0 =C2=A0 =C2=A0arch/x86/boot/header.o
>> >>>> >> =C2=A0 LD =C2=A0 =C2=A0 =C2=A0arch/x86/boot/setup.elf
>> >>>> >> =C2=A0 OBJCOPY arch/x86/boot/setup.bin
>> >>>> >> =C2=A0 BUILD =C2=A0 arch/x86/boot/bzImage
>> >>>> >> Setup is 15596 bytes (padded to 15872 bytes).
>> >>>> >> System is 2471 kB
>> >>>> >> CRC eb598167
>> >>>> >> Kernel: arch/x86/boot/bzImage is ready =C2=A0(#1)
>> >>>> >> make[3]: *** [sub-make] Error 2
>> >>>> >> make[2]: *** [all] Error 2
>> >>>> >>
>> >>>> >> I have these binfmt kernel-config options set:
>> >>>> >>
>> >>>> >> CONFIG_BINFMT_ELF=3Dy
>> >>>> >> # CONFIG_BINFMT_AOUT is not set
>> >>>> >> CONFIG_BINFMT_MISC=3Dm
>> >>>> >
>> >>>> > How does someone turn off this error message?
>> >>>> >
>> >>>> > I have:
>> >>>> > # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
>> >>>> > # CONFIG_STRICT_DEVMEM is not set
>> >>>> >
>> >>>> > and I still cannot get this error to go away (on x86_64).
>> >>>> >
>> >>>> >
>> >>>> > ---
>> >>>> > ~Randy
>> >>>> > *** Remember to use Documentation/SubmitChecklist when testing yo=
ur code ***
>> >>>> >
>> >>>>
>> >>>> Can you say with which linux-next version you saw this first?
>> >>>> My last version was next-20110722 (which was OK).
>> >>>
>> >>> It looks like 2011-0727 has lots of these errors in my randconfig bu=
ilds,
>> >>> but I can't say that they are all incorrect, so it's not very conclu=
sive.
>> >>>
>> >>> ---
>> >>> ~Randy
>> >>> *** Remember to use Documentation/SubmitChecklist when testing your =
code ***
>> >>>
>> >>
>> >> I can confirm next-20110726 is fine.
>> >>
>> >> # egrep 'BINFMT|DEBUG_STRICT_USER_COPY_CHECKS|STRICT_DEVMEM'
>> >> /boot/config-3.0.0-next20110726.3-686-small
>> >> CONFIG_BINFMT_ELF=3Dy
>> >> CONFIG_BINFMT_AOUT=3Dm
>> >> CONFIG_BINFMT_MISC=3Dm
>> >> CONFIG_STRICT_DEVMEM=3Dy
>> >> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
>> >>
>> >> So, the binfmt_misc culprit was introduced between next-20110726
>> >> (good) and next-20110727 (bad).
>> >> I'll try to look into the diff, but can't promise.
>> >>
>> >> - Sedat -
>> >>
>> >
>> > [ CCing all people from 0416 patch ]
>> >
>> > OK, here a quick review and looking for suspicious commits:
>> >
>> > $ git format-patch next-20110726..next-20110727
>> >
>> > 487 patches in total.
>> >
>> > $ grep copy_from_user_overflow -nr *.patch
>> >
>> > 0389-x86_64-allmodconfig.patch
>> > 0414-Enabling-DEBUG_STRICT_USER_COPY_CHECKS-causes-the-fo.patch
>> > 0415-Strict-user-copy-checks-are-only-really-supported-on.patch
>> > 0416-The-help-text-for-this-config-is-duplicated-across-t.patch
>> >
>> > 0416 has thrown out...
>> >
>> > -void copy_from_user_overflow(void)
>> > -{
>> > - =C2=A0 =C2=A0 =C2=A0 WARN(1, "Buffer overflow detected!\n");
>> > -}
>> > -EXPORT_SYMBOL(copy_from_user_overflow);
>> >
>> > ...and consilidated that in...
>> >
>> > --- /dev/null
>> > +++ b/lib/usercopy.c
>> > @@ -0,0 +1,8 @@
>> > +#include <linux/module.h>
>> > +#include <linux/bug.h>
>> > +
>> > +void copy_from_user_overflow(void)
>> > +{
>> > + =C2=A0 =C2=A0 =C2=A0 WARN(1, "Buffer overflow detected!\n");
>> > +}
>> > +EXPORT_SYMBOL(copy_from_user_overflow);
>> >
>> > ...BUT builds usercopy.o only on
>> > CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS...
>> >
>> > -- a/lib/Makefile
>> > +++ b/lib/Makefile
>> > @@ -14,6 +14,7 @@ lib-y :=3D ctype.o string.o vsprintf.o cmdline.o \
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 proportions.o prio_heap.o ratelimit.o show=
_mem.o \
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 is_single_threaded.o plist.o decompress.o =
find_next_bit.o
>> >
>> > +lib-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) +=3D usercopy.o
>> > =C2=A0lib-$(CONFIG_MMU) +=3D ioremap.o
>> > =C2=A0lib-$(CONFIG_SMP) +=3D cpumask.o
>> >
>> > So, I can rebuild next-201107{27,28} with
>> > CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=3Dy and look again if th=
e
>> > build-breakage in binfmt_misc is gone.
>> >
>> > Any comments from x86 folk?
>> >
>> > - Sedat -
>> >
>>
>> I was able to compile next-20110728 by reverting:
>>
>> commit ab3b49d018924085e5d949c1af53fae0da9a8d94
>> "The help text for this config is duplicated across the x86, parisc,
>> and s390 Kconfig.debug files."
>>
>> The revert-patch is attached, also my kernel-config.
>>
>> Randy, can you test with it for x86_64, please?
>> Thanks in advance.
>
> Yes, that works for me. =C2=A0Thanks for your work on this problem.
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code =
***
>

Cool, you tested so fast, thanks.

While watching DebConf11 live-stream, I played a bit with trying to
fix the problem.

I added back partially copy_from_user_overflow() back to
arch/x86/lib/usercopy.c, so both x86_32 and x86_64 benefit from the
change (initially copy_from_user_overflow() was in
arch/x86/lib/usercopy_{32,64}).
The attached patch works!

I am still not understanding why there are several usercopy.c files
below arch/ dir.
The one "remained" in x86 includes only copy_from_user_nmi() and could
IMHO be renamed to usercopy_nmi.c with adaptation in
arch/x86/lib/Makefile.

x86 folks?

- Sedat -

$ find ./ -name usercopy.c
./lib/usercopy.c
./arch/mn10300/lib/usercopy.c
./arch/x86/lib/usercopy.c
./arch/cris/arch-v10/lib/usercopy.c
./arch/cris/arch-v32/lib/usercopy.c
./arch/m32r/lib/usercopy.c

--90e6ba309434f367dd04a93700c4
Content-Type: plain/text; name="arch_x86_lib_usercopy.c.diff"
Content-Disposition: attachment; filename="arch_x86_lib_usercopy.c.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqpb26e20

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2xpYi91c2VyY29weS5jIGIvYXJjaC94ODYvbGliL3VzZXJj
b3B5LmMKaW5kZXggOTdiZTljYi4uYjQwM2NjMSAxMDA2NDQKLS0tIGEvYXJjaC94ODYvbGliL3Vz
ZXJjb3B5LmMKKysrIGIvYXJjaC94ODYvbGliL3VzZXJjb3B5LmMKQEAgLTYsNiArNiw3IEBACiAK
ICNpbmNsdWRlIDxsaW51eC9oaWdobWVtLmg+CiAjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+Cisj
aW5jbHVkZSA8bGludXgvYnVnLmg+CiAKIC8qCiAgKiBiZXN0IGVmZm9ydCwgR1VQIGJhc2VkIGNv
cHlfZnJvbV91c2VyKCkgdGhhdCBpcyBOTUktc2FmZQpAQCAtNDEsMyArNDIsOSBAQCBjb3B5X2Zy
b21fdXNlcl9ubWkodm9pZCAqdG8sIGNvbnN0IHZvaWQgX191c2VyICpmcm9tLCB1bnNpZ25lZCBs
b25nIG4pCiAJcmV0dXJuIGxlbjsKIH0KIEVYUE9SVF9TWU1CT0xfR1BMKGNvcHlfZnJvbV91c2Vy
X25taSk7CisKK3ZvaWQgY29weV9mcm9tX3VzZXJfb3ZlcmZsb3codm9pZCkKK3sKKwlXQVJOKDEs
ICJCdWZmZXIgb3ZlcmZsb3cgZGV0ZWN0ZWQhXG4iKTsKK30KK0VYUE9SVF9TWU1CT0woY29weV9m
cm9tX3VzZXJfb3ZlcmZsb3cpOwo=
--90e6ba309434f367dd04a93700c4--
