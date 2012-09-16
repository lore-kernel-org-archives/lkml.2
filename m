Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab2IPTH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 15:07:57 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33501 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab2IPTHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 15:07:55 -0400
MIME-Version: 1.0
Date: Sun, 16 Sep 2012 21:07:54 +0200
X-Google-Sender-Auth: Aj6zp9UmlG3oGTr3zKslVj9xnz0
Message-ID: <CAMuHMdXqsPgfToNyjbxJ-WM=-kEEvAweE03wb3vtkwVO+-RR3A@mail.gmail.com>
Subject: [-next]: s390 *_irq() link errors
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-s390@vger.kernel.org
Cc: Linux-Next <linux-next@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After applying http://www.spinics.net/lists/linux-next/msg21973.html,
the s390 allmodconfig build in linux-next fails in the linking stage with:

ERROR: "free_irq" [drivers/power/smb347-charger.ko] undefined!
ERROR: "free_irq" [drivers/power/sbs-battery.ko] undefined!
ERROR: "enable_irq" [drivers/power/max17042_battery.ko] undefined!
ERROR: "request_irq" [drivers/power/max17042_battery.ko] undefined!
ERROR: "free_irq" [drivers/power/max17042_battery.ko] undefined!
ERROR: "disable_irq" [drivers/power/max17042_battery.ko] undefined!
ERROR: "request_irq" [drivers/power/lp8727_charger.ko] undefined!
ERROR: "free_irq" [drivers/power/lp8727_charger.ko] undefined!
ERROR: "request_irq" [drivers/nfc/pn544_hci.ko] undefined!
ERROR: "free_irq" [drivers/nfc/pn544_hci.ko] undefined!
ERROR: "request_irq" [drivers/nfc/pn544.ko] undefined!
ERROR: "free_irq" [drivers/nfc/pn544.ko] undefined!
ERROR: "request_irq" [drivers/misc/fsa9480.ko] undefined!
ERROR: "free_irq" [drivers/misc/fsa9480.ko] undefined!
ERROR: "request_irq" [drivers/misc/bh1770glc.ko] undefined!
ERROR: "free_irq" [drivers/misc/bh1770glc.ko] undefined!
ERROR: "request_irq" [drivers/misc/apds990x.ko] undefined!
ERROR: "free_irq" [drivers/misc/apds990x.ko] undefined!

What should these drivers depend on? GENERIC_HARDIRQS?

S390 is the only non-GENERIC_HARDIRQS architecture left, but all
other former non-GENERIC_HARDIRQS architectures did provide e.g. request_irq()
and free_irq().

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
