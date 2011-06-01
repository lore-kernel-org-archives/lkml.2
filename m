Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401Ab1FARmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:42:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41596 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759278Ab1FARmQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:42:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=RxSvndLyUvqRInukwoliC6ZfJBPjitOnKJ8THq16JYHNJFIo1JC/be6nsUQU0OuyYx
         h2YuL23/8l/wKdk8oiEgsnniFNsQBdi1UZhuw44+Emo3tYFEtcp3ljtzMyKIcSPrEjwb
         ABLflDhRGnd/4evqtpjV0b1MgJIVqfNdqS3Wk=
MIME-Version: 1.0
In-Reply-To: <10442.1306949732@turing-police.cc.vt.edu>
References: <cover.1306847455.git.luto@mit.edu> <7e604b2dd699a30204fda3d1011f3af5a2c56572.1306847455.git.luto@mit.edu>
 <10442.1306949732@turing-police.cc.vt.edu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 1 Jun 2011 13:41:56 -0400
X-Google-Sender-Auth: bG3oIiWaiN8ZZ2YDvqjVpkGqJOM
Message-ID: <BANLkTinKKmXYBLwc_cQBVcs-jgh_1SV6NQ@mail.gmail.com>
Subject: Re: [PATCH v3 10/10] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
To: Valdis.Kletnieks@vt.edu
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 1:35 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Tue, 31 May 2011 09:16:04 EDT, Andy Lutomirski said:
>
>> +What:        CONFIG_UNSAFE_VSYSCALLS (x86_64)
>
> Wow. I went nuts trying to find where this was because I couldn't find it in
> Linus's tree I pulled a little while ago, before I realized you added it in patch 8
> and deprecated it in patch 10.
>
> Speaking of which:
>
> +         On a system with recent enough glibc (probably 2.14 or
> +         newer) and no static binaries, you can say N without a
> +         performance penalty to improve security
>
> So I checked my laptop (Fedora 16 Rawhide), and found a bunch of static binaries. The ones
> that look like people may care:
>
> # file /sbin/* | grep statically
> /sbin/grub:                ELF 32-bit LSB executable, Intel 80386, version 1 (GNU/Linux), statically linked, for GNU/Linux 2.6.18, stripped
> /sbin/insmod.static:       ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, for GNU/Linux 2.6.32, stripped
> /sbin/ldconfig:            ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, for GNU/Linux 2.6.32, stripped
> /sbin/sln:                 ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, for GNU/Linux 2.6.32, stripped
>

The binaries will still work -- they'll just take a small performance
hit (~220ns on Sandy Bridge) every time they call time().

Somehow I doubt that grub, ldconfig, and sln care much.

The only things I can see being a problem are big enterprise packages
like, say, Oracle's server, but I think that most of those things are
dynamically linked anyway.

Also, on systems that use a non-tsc clocksource, this hit should be
lost in the noise, except for time().  On my systems, HPET already
takes nearly a microsecond to read and the acpi clock takes over 3us.

> Might be a challenge to get rid of them though.  Unless we don't care anymore
> about "use a statically linked ldconfig to fix a corrupted ls.so.cache" and
> "reboot from a rescue disk" the only choice.  I think the insmod.static ends up
> getting used in initrds to get the root filesystem mounted, we may care about
> that as well.. ;)

You'll just have to wait a few hundred extra ns to get your system fixed :)

--Andy
