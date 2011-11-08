Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1KHKcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 05:32:53 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36341 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab1KHKcw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 05:32:52 -0500
MIME-Version: 1.0
In-Reply-To: <1320744887.14409.379.camel@x61.thuisdomein>
References: <1320673476.14409.367.camel@x61.thuisdomein>
	<alpine.LNX.2.00.1111081025470.1964@pobox.suse.cz>
	<1320744887.14409.379.camel@x61.thuisdomein>
Date: Tue, 8 Nov 2011 11:32:51 +0100
X-Google-Sender-Auth: Aa2D7tHh_mwRx9-DqKtFi1qza1g
Message-ID: <CAMuHMdWTyQDJZ2LuQfdyH1U5SMFKu6YPPqnxwJdDQyoCkJqk=Q@mail.gmail.com>
Subject: Re: [PATCH] [TRIVIAL] 8250_hp300: Fix warning typo 'CONFIG_8250'
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        linux-m68k@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 10:34, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Tue, 2011-11-08 at 10:26 +0100, Jiri Kosina wrote:
>> On Mon, 7 Nov 2011, Paul Bolle wrote:
>> > 1) If SERIAL_8250_HP300 is set but neither HPDCA nor HPAPCI are set we
>> > end up with an elaborate nop, don't we? Initialization should always
>> > fail in that case. So effectively SERIAL_8250_HP300 depends on HPDCA
>> > and/or HPAPCI. Was there perhaps some problem in translating that
>> > dependency into a Kconfig dependency?
>
> [...]
>
>> > --- a/drivers/tty/serial/8250_hp300.c
>> > +++ b/drivers/tty/serial/8250_hp300.c
>> > @@ -21,7 +21,7 @@
>> >  #include "8250.h"
>> >
>> >  #if !defined(CONFIG_HPDCA) && !defined(CONFIG_HPAPCI)
>> > -#warning CONFIG_8250 defined but neither CONFIG_HPDCA nor CONFIG_HPAPCI defined, are you sure?
>> > +#warning CONFIG_SERIAL_8250 defined but neither CONFIG_HPDCA nor CONFIG_HPAPCI defined, are you sure?
>> >  #endif
>>
>> What is the point of this warning anyway? Shouldn't everything necessary
>> be taken care of by Kconfig rules?
>
> That's exactly what I'm trying to find out with my questions (aimed at
> the m68k people, see 1) above).

I already had that on my todo list...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
