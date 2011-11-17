Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab1KQTdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 14:33:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51548 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab1KQTds convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 14:33:48 -0500
MIME-Version: 1.0
In-Reply-To: <1321182176.20271.43.camel@x61.thuisdomein>
References: <1321180296-22543-1-git-send-email-geert@linux-m68k.org>
	<1321182176.20271.43.camel@x61.thuisdomein>
Date: Thu, 17 Nov 2011 20:33:47 +0100
X-Google-Sender-Auth: jkwnQc50OFhC5fALl_5CMhXV_YE
Message-ID: <CAMuHMdXsHgUd_oggpKoS2t6Tm8MnEjLnWmi4Hswz_nQjSWsozA@mail.gmail.com>
Subject: Re: [PATCH] m68k: Remove references to obsolete CONFIG_SERIAL167
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-m68k@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 13, 2011 at 12:02, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Sun, 2011-11-13 at 11:31 +0100, Geert Uytterhoeven wrote:
>> commit 51c9d654c2def97827395a7fbfd0c6f865c26544 ("Staging: delete tty
>> drivers") removed the MVME167 serial driver, but forgot to remove these
>> references.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>>  arch/m68k/Kconfig.devices           |    2 +-
>>  arch/m68k/configs/multi_defconfig   |    1 -
>>  arch/m68k/configs/mvme16x_defconfig |    1 -
>>  3 files changed, 1 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/m68k/Kconfig.devices b/arch/m68k/Kconfig.devices
>> index 6033f5d..e01eeb2 100644
>> --- a/arch/m68k/Kconfig.devices
>> +++ b/arch/m68k/Kconfig.devices
>> @@ -128,7 +128,7 @@ config DN_SERIAL
>>
>>  config SERIAL_CONSOLE
>>       bool "Support for serial port console"
>> -     depends on (AMIGA || ATARI || SUN3 || SUN3X || VME || APOLLO) && (ATARI_MFPSER=y || ATARI_MIDI=y || AMIGA_BUILTIN_SERIAL=y || MULTIFACE_III_TTY=y || SERIAL=y || SERIAL167 || DN_SERIAL)
>> +     depends on (AMIGA || ATARI || SUN3 || SUN3X || VME || APOLLO) && (ATARI_MFPSER=y || ATARI_MIDI=y || AMIGA_BUILTIN_SERIAL=y || MULTIFACE_III_TTY=y || SERIAL=y || DN_SERIAL)
>
> 0) The SERIAL=y part can also be dropped. There's no Kconfig symbol
> SERIAL.

OK, will do.

> 1) I've been looking at this impressive dependency list a few days back.
> My impression was that it can be reduced to only AMIGA_BUILTIN_SERIAL=y.
> (After that this Kconfig symbol might better be renamed to
> AMIGA_BUILTIN_SERIAL_CONSOLE.)
>
> I might have a draft patch to drop the dependencies somewhere. I need to
> have another look at that (draft) patch before I can submit it.

You are right: all drivers (except for AMIGA_BUILTIN_SERIAL) got lost due to
bitrot, or never made it to mainline. Will fix.

But please keep SERIAL_CONSOLE.

BTW, updating the m68k defconfigs is also on my list.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
