Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab1H3Btw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 21:49:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075Ab1H3Btu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 21:49:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXhdg6GuJqSjK5SdKBrBzZwGYus2LH1yqgkSnSEp8ZXyg@mail.gmail.com>
References: <4E582577.2060805@zytor.com> <CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com>
 <4E582EAA.1040108@zytor.com> <CA+55aFxdRMxWLh1B_8v29qFafM425uH7kbYRfqoPe3TpVwOx-w@mail.gmail.com>
 <CA+55aFyVmA_26LYaJH8dnFhwo7LWM6Ck7qFxCQvnROEHSuV_aA@mail.gmail.com>
 <4E584492.5090406@zytor.com> <CA+55aFw8+fkwjgAYOzxnO1HY3uCBCuf+N6z1XX2m=FhSjD5Wqg@mail.gmail.com>
 <CAMuHMdXhdg6GuJqSjK5SdKBrBzZwGYus2LH1yqgkSnSEp8ZXyg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 29 Aug 2011 18:48:56 -0700
Message-ID: <CA+55aFzuY+U0nf58-9P5CFaYAPKMQ3fQMGGUUkjbxRRCK7=A3Q@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 12:01 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
> Which will break all this non-portable 32-bit-only source code x32 was invented
> for in the first place?

NO. HELL NO!

Guys, get a f&*king grip already!

There are absolutely ZERO compatibility issues.

If you want compatibility, you run traditional 32-bit x86.

If you want full 64-bit, you run standard x86-64 binaries.

x32 is *not* about compatibility. It's about pure performance, and
perhaps smaller binaries. Nothing else. If you start blathering about
"compatibility", you're so on the wrong track that it isn't even
funny!

I would seriously suggest that if you want compatible ioctl's, don't
use x32. There's no point. It's not why x32 exists. If this turns into
a "let's add a new compat layer", or "let's just re-do x86-32 all over
again just using "syscall", I think the whole thing is totally
pointless.

If something isn't performance-sensitive, why do it in x32 at all? It
involves new libraries, new compiler support, new calling conventions,
and it will be *less well supported* than the traditional compat mode.

The *only* reason to use x32 is:

 - you get all the new x86-64 registers, and the improved calling
convention (big registers, more of them)

 - you get a faster system call.

 - smaller memory footprint (32-bit pointers and long).

But no, "compatibility" isn't one of those reasons. You won't be able
to use old libraries, you won't even be able to use an old compiler,
and I would seriously suggest that maybe we shouldn't care about the
more esoteric ioctl's if they end up being a pain.

                             Linus
