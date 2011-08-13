Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab1HMUop (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 16:44:45 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:63078 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab1HMUon convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 16:44:43 -0400
MIME-Version: 1.0
Date: Sat, 13 Aug 2011 22:44:42 +0200
X-Google-Sender-Auth: 6e1JeZmLEvba_kuOaYrMDV-WSLU
Message-ID: <CAMuHMdVr9iAyqQJUgHq4gcLg+gp7GxF=sH+SBKBuqVWYymXs8Q@mail.gmail.com>
Subject: Driver framework: binding a driver to two devices?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Amiga Zorro expansion boards have only one BAR (unlike PCI, which has
multiple BARs), several Amiga graphics cards show up as two Zorro devices:
one for the graphics memory and one for the graphics controller's registers.

Traditionally, a driver for such a device used

    dev1 = zorro_find_device(id1, ...)
    dev2 = zorro_find_device(id2, ...)

to find the two devices and match them.

With the "new" driver framework, the matching with device id1 is now
done using a
struct zorro_driver with a table of IDs, while the matching with device id2 is
still done by calling zorro_find_device(id2, ...).

Recently (with cirrusfb) it turned out that the call to
zorro_find_device(id2, ...)
may fail to find the second device. I suspect this happens due to the second
device haven't been probed for at the time the zorro_driver for the
first device is
initialized.

I expect this can be fixed by delaying all calls to device_register() in
amiga_zorro_probe() until all devices have been detected and added to the array
used by zorro_find_device(). But I was wondering whether there's a more generic
way in the driver framework to bind a driver to two devices?

Are there any PCI devices that show similar behavior?
I know some PCI drivers look up data in DMI tables, but that's not
really the same.

Thanks in advance!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
