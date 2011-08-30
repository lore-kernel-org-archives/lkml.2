Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab1H3CRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 22:17:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42326 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab1H3CRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 22:17:17 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzuY+U0nf58-9P5CFaYAPKMQ3fQMGGUUkjbxRRCK7=A3Q@mail.gmail.com>
References: <4E582577.2060805@zytor.com> <CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com>
 <4E582EAA.1040108@zytor.com> <CA+55aFxdRMxWLh1B_8v29qFafM425uH7kbYRfqoPe3TpVwOx-w@mail.gmail.com>
 <CA+55aFyVmA_26LYaJH8dnFhwo7LWM6Ck7qFxCQvnROEHSuV_aA@mail.gmail.com>
 <4E584492.5090406@zytor.com> <CA+55aFw8+fkwjgAYOzxnO1HY3uCBCuf+N6z1XX2m=FhSjD5Wqg@mail.gmail.com>
 <CAMuHMdXhdg6GuJqSjK5SdKBrBzZwGYus2LH1yqgkSnSEp8ZXyg@mail.gmail.com> <CA+55aFzuY+U0nf58-9P5CFaYAPKMQ3fQMGGUUkjbxRRCK7=A3Q@mail.gmail.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Mon, 29 Aug 2011 22:16:56 -0400
Message-ID: <CAGZ=bqKjnsEKz_CxcW+wRoCL_CY-kipedf2wB=BVUWRB0427tw@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 21:48, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Aug 29, 2011 at 12:01 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> Which will break all this non-portable 32-bit-only source code x32 was invented
>> for in the first place?
>
> There are absolutely ZERO compatibility issues.
>
> If you want compatibility, you run traditional 32-bit x86.
>
> If you want full 64-bit, you run standard x86-64 binaries.
>
> x32 is *not* about compatibility. It's about pure performance, and
> perhaps smaller binaries. Nothing else. If you start blathering about
> "compatibility", you're so on the wrong track that it isn't even
> funny!

I agree.

This is exactly the same reason that PowerPC64 systems are 99%+
32-bit binaries.

When "64-bit" doesn't magically mean "more registers" or "vector ops",
then all it really does is chew up twice as much RAM for every pointer.

The only programs which really care are those which map many gigs
of stuff into memory (IE: big databases, etc).  Even "git" on some
pretty outrageously large repositories can pretty easily page between
pack files without much overhead.

The goal of x32 as I understand it is to allow 32-bit x86 programs to
use all the nifty extra registers and faster instructions (IE: syscall)
without needing to deal with the 2x memory overhead of 64-bit
pointers.

Cheers,
Kyle Moffett
