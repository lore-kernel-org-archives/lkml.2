Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab1H3HGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 03:06:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43014 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1H3HGc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 03:06:32 -0400
MIME-Version: 1.0
In-Reply-To: <4E5C6ADA.3030409@zytor.com>
References: <4E582577.2060805@zytor.com>
	<CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com>
	<4E582EAA.1040108@zytor.com>
	<CA+55aFxdRMxWLh1B_8v29qFafM425uH7kbYRfqoPe3TpVwOx-w@mail.gmail.com>
	<CA+55aFyVmA_26LYaJH8dnFhwo7LWM6Ck7qFxCQvnROEHSuV_aA@mail.gmail.com>
	<4E584492.5090406@zytor.com>
	<CA+55aFw8+fkwjgAYOzxnO1HY3uCBCuf+N6z1XX2m=FhSjD5Wqg@mail.gmail.com>
	<CAMuHMdXhdg6GuJqSjK5SdKBrBzZwGYus2LH1yqgkSnSEp8ZXyg@mail.gmail.com>
	<CA+55aFzuY+U0nf58-9P5CFaYAPKMQ3fQMGGUUkjbxRRCK7=A3Q@mail.gmail.com>
	<CAGZ=bqKjnsEKz_CxcW+wRoCL_CY-kipedf2wB=BVUWRB0427tw@mail.gmail.com>
	<4E5C6ADA.3030409@zytor.com>
Date: Tue, 30 Aug 2011 09:06:31 +0200
X-Google-Sender-Auth: oCORIwKoU-bvTOBrJyKy5u7He6E
Message-ID: <CAMuHMdUJVRNPcBW60UZ+cwV75T9+xmONzTrCuDCe_dDUzg2kKg@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kyle Moffett <kyle@moffetthome.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 06:45, H. Peter Anvin <hpa@zytor.com> wrote:
> On 08/29/2011 07:16 PM, Kyle Moffett wrote:
>> The goal of x32 as I understand it is to allow 32-bit x86 programs to
>> use all the nifty extra registers and faster instructions (IE: syscall)
>> without needing to deal with the 2x memory overhead of 64-bit
>> pointers.

Good. IIRC, the PPC people were thinking about something similar back in 2007,
but it hasn't materialized yet.

> That is the major goal.  A minor goal is to bring x86-64 goodness to
> those who have an (irrational) fear of 64 bits thinking it is a major
> porting effort.  Thus, *source-level* porting effort matters, but it is
> completely subordinate to the major goal.

>From my experience, if the source code is not 64-bit clean, it will probably
be a major hassle to make it cope with changed time_t and off_t and other traps
of that kind...

As a first step, gcc should start enabling -Wall by default ;-)
And add a -Wcast option, as grepping for (C-style) casts is way too difficult...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
