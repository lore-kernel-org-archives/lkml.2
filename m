Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab2AXVds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 16:33:48 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:36449 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab2AXVdq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 16:33:46 -0500
MIME-Version: 1.0
In-Reply-To: <4F1A0783.9010501@xenotime.net>
References: <20120120131243.7c867c7b96c75819b68aec8d@canb.auug.org.au>
	<4F1A0783.9010501@xenotime.net>
Date: Tue, 24 Jan 2012 22:33:43 +0100
X-Google-Sender-Auth: 2J3hdgPr2wNqnZIMc2K15A7wHqY
Message-ID: <CAMuHMdX8=x-=DQu0SCbqYK00+sP8a-kR=9KrUptAq-gqOXHAhA@mail.gmail.com>
Subject: Re: linux-next: Tree for Jan 20 (drivers/media/radio/wl128x/)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@xenotime.net>, Fabio Estevam <festevam@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 01:32, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 01/19/2012 06:12 PM, Stephen Rothwell wrote:
>> Changes since 20120119:
>
> on x86_64:
>
> ERROR: "st_register" [drivers/media/radio/wl128x/fm_drv.ko] undefined!
> ERROR: "st_unregister" [drivers/media/radio/wl128x/fm_drv.ko] undefined!

Also in m68k allmodconfig since a while:
http://kisskb.ellerman.id.au/kisskb/buildresult/5427875/

config RADIO_WL128X
        tristate "Texas Instruments WL128x FM Radio"
        depends on VIDEO_V4L2 && RFKILL
        select TI_ST if NET && GPIOLIB

config TI_ST
        tristate "Shared transport core driver"
        depends on NET && GPIOLIB
        select FW_LOADER

On m68k allmodconfig, GPIOLIB is not enabled, hence TI_ST
will not be selected, and st_{,un}register() won't be there.
Shouldn't the whole RADIO_WL128X depend on NET && GPIOLIB?
Or depend on TI_ST, instead of selecting it?

BTW, shouldn't it be called ti_st_un{,un}register()?
At first I thought the link error was related to SCSI tape drives ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
