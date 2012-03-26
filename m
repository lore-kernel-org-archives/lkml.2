Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab2CZUSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:18:55 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57918 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab2CZUSy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:18:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120326131304.018a5f4b.akpm@linux-foundation.org>
References: <201203262047.17865.vda.linux@googlemail.com>
	<201203262051.24271.vda.linux@googlemail.com>
	<20120326125129.78975baf.akpm@linux-foundation.org>
	<CAK1hOcNZ1QdsT2Gajv1y-yAfF85hOTH=18vqqH4itURLtgYfdQ@mail.gmail.com>
	<20120326131304.018a5f4b.akpm@linux-foundation.org>
Date: Mon, 26 Mar 2012 22:18:52 +0200
X-Google-Sender-Auth: 7m2kYu0gvzzJ-ooyyU_3pKNQD6A
Message-ID: <CAMuHMdWK-0m9-LUc90e7e8pYsOsECkZ3gjBYVAP-A4p7p=Pyug@mail.gmail.com>
Subject: Re: [PATCH 1/1] vsprintf: optimize decimal conversion (again)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
        Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 22:13, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 26 Mar 2012 21:56:38 +0200
> Denys Vlasenko <vda.linux@googlemail.com> wrote:
>
>> >> +#if BITS_PER_LONG != 32 || (~(0ULL)>>1) != ((1ULL<<63)-1)
>> >
>> > What's this for?
>>
>> The second check should be just BITS_PER_LONG_LONG != 64,
>> but we don't have BITS_PER_LONG_LONG.
>
> So let's add BITS_PER_LONG_LONG rather than hacking around its absence!

I don't think Linux runs on anything with BITS_PER_LONG_LONG != 64...

BTW, what about CPUs with slow 32x32 multiplication and/or slow 64-bit
division?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
