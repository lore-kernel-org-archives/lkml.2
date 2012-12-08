Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab2LHK5o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 05:57:44 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62018 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab2LHK5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 05:57:41 -0500
MIME-Version: 1.0
In-Reply-To: <20121207211606.6c5d5bc8@pyramind.ukuu.org.uk>
References: <CAHTX3d+VNDVQjnTnAB=Ywxo7odvNmCPu=wGZ03-xWLecSMsS9A@mail.gmail.com>
	<20121207211606.6c5d5bc8@pyramind.ukuu.org.uk>
Date: Sat, 8 Dec 2012 11:57:39 +0100
X-Google-Sender-Auth: B5XZV767OMqfL1gLxDVdfiKcgU0
Message-ID: <CAMuHMdVNszTFRjqiUoZ42+noaOcGjLZyZ9O30c5UVNNJhp0LMw@mail.gmail.com>
Subject: Re: Using IO functions across ARM, PPC and Microblaze architectures
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Michal Simek <monstr@monstr.eu>, linux-arch@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        David Hinds <dahinds@users.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 7, 2012 at 10:16 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Because I need to use IO functions which will behave
>> on arm as little endian and on powerpc as big endian
>> and on microblaze depends on endian setting.
>> I haven't found any IO function which I could use by 3 architectures
>> without using preprocessor macros or runtime detection
>
> Its a rather weird mix. We can do "always big" and "always little"
>
>> 1. Using helper function + preprocessor macros
>> (using static inline function also possible)
>
> Then someone comes along and sticks a daughterboard into the system with
> the same device the other way around and there are years
>
>> 2. Using function pointers
>
> Probably smarter. 8250.c works this way and it has to handle some
> extremely bizarre mappings.
>
>> b) Runtime initialization - here is the question if there is
>> any standard function which I could use.
>
> Set the pointers up and pass them as data with your platform device, that
> way the function definitions are buried in your platform code where they
> depend.

Or embed a struct io_ops * in struct device, to be set up by the bus driver?

Wasn't David Hinds working on something like this in the context of PCMCIA
a few decades ago?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
