Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab0FNOjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:39:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51280 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab0FNOjB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:39:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dXJp89MvU6AndgZAE6IAe8OgAkOp5QSA4CsKiLXIYbHFSED+qncXC3ZpI28jTe2tEq
         23fO1dfr5YrhONP5rVjJAir4V2TtUZMXh1oTGO/kaUscnvhRIumWrmXESPbkZR+evFr2
         C/9KmWaqyLy8HNsTHL8FEG0hkPcxCzvUIsUBk=
MIME-Version: 1.0
In-Reply-To: <201006141544.59500.toralf.foerster@gmx.de>
References: <201005271944.09541.toralf.foerster@gmx.de>
	<201006141149.24647.toralf.foerster@gmx.de>
	<20100614130039.GA4618@kryptos.osrc.amd.com>
	<201006141544.59500.toralf.foerster@gmx.de>
Date: Mon, 14 Jun 2010 16:39:00 +0200
X-Google-Sender-Auth: ih58x_uyD7wEXBR55tHH5Ht2iYM
Message-ID: <AANLkTik7aQPVl2OsOIhAtMzRHDNw6jkZYzcRNtfi7QSh@mail.gmail.com>
Subject: Re: [PATCH] x86, hweight: Fix UML boot crash
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: Borislav Petkov <bp@amd64.org>, Borislav Petkov <bp@alien8.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/14 Toralf Förster <toralf.foerster@gmx.de>:
> Borislav Petkov wrote at 15:00:39
>
>> Linus' tree doesn't contain the fix yet - rather it is in -tip:
>> http://git.kernel.org/tip/055c47272b8f5679d08ccc57efea3cb4aaeb5fc6
>>
>> You can easily cherry-pick it from there and retest.
> Issue solved works with that patch.
>
> FWIW : This command sequence produced a linux executable which crashed too:
>
> $> ~/devel/linux-2.6 $ patch -p1 < ../linux-2.6-
> tip.git-055c47272b8f5679d08ccc57efea3cb4aaeb5fc6.patch patching file
> arch/um/include/asm/arch_hweight.h
>
> $> ~/devel/linux-2.6 $ make ARCH=um CC="ccache gcc"
> make[1]: `arch/um/sys-i386/user-offsets.s' is up to date.
>  CHK     include/linux/version.h
>  CHK     include/generated/utsrelease.h
>  CALL    scripts/checksyscalls.sh
>  CHK     include/generated/compile.h
>  LINK linux
> $> start_uml.sh
> ...
>
> But after I compiled it w/o ccache
>
> $> ~/devel/linux-2.6 $ make ARCH=um
>
> linux executable works (!?!)

I assume you did a `make clean' in between?
So could this just be the problem that new include files early in the
include path are
not detected by the dependency system, as they aren't in any *.d file?

BTW, I'm also using ccache. Always. Ever. All my (cross)compilers are symlinks
to ccache ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
