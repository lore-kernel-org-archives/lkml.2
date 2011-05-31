Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300Ab1EaIfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:35:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50979 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab1EaIfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FajFGi66+iF2cbWK3If9akKfU7Vp36CzHfWjnWNmOnKCulESh2gNH4wxVz06KURgqz
         C683qBhAySi+x1sTZ/1xhtjR3YvYUwM9hAm4eSm5sUTWlPkI69tagxuqwWnhPNO+cWT1
         Z7I4I9haKsdhYzAQwCL7B5KT87GCSevGqFo1c=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
Date: Tue, 31 May 2011 10:35:06 +0200
X-Google-Sender-Auth: rDhV1ZFlJB1Y2zAngNdCSsMa-Ow
Message-ID: <BANLkTikxb_tJvXoHma7U41TrZKmZr=4u0g@mail.gmail.com>
Subject: Re: m68k: Convert to genirq (WIP)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Linux/m68k" <linux-m68k@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 20:32, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> | NR_IRQS:72
> | ------------[ cut here ]------------
> | WARNING: at linux/kernel/irq/chip.c:559 0x2a191a()
> | Modules linked in:
> | Call Trace: [<0002767e>] warn_slowpath_common+0x4c/0x64
> |  [<0004e81c>] irq_set_chip+0x0/0x66
> |  [<000276aa>] warn_slowpath_null+0x14/0x1a
> |  [<0004e728>] __irq_set_handler+0x11c/0x13c
> |  [<0004ec7e>] handle_level_irq+0x0/0x9c
> |  [<00003ef4>] m68k_setup_irq_controller+0x3c/0x50
> |  [<0004ec7e>] handle_level_irq+0x0/0x9c
> |  [<0004e81c>] irq_set_chip+0x0/0x66
> |  [<00027dc8>] printk+0x0/0x1a
> |  [<00322022>] __alloc_bootmem+0x0/0x1a
> |  [<0031dea4>] atari_init_IRQ+0x2a/0xe8
> |  [<0004ec7e>] handle_level_irq+0x0/0x9c
> |  [<0031c450>] init_IRQ+0x28/0x2e
> |  [<00027dc8>] printk+0x0/0x1a
> |  [<0031a012>] start_kernel+0x196/0x3b0
> |  [<0031931e>] _sinittext+0x31e/0x9c0
> |
> | ---[ end trace 139ce121c98e96c9 ]---

whitespace-challenged diff --git a/arch/m68k/kernel/ints.c
b/arch/m68k/kernel/ints.c
index f4804f3..8d8a1e9 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -285,7 +285,7 @@ void m68k_setup_irq_controller(struct irq_chip *chip,
        for (i = 0; i < cnt; i++) {
                irq_set_chip(irq + i, chip);
                if (handle)
-                       irq_set_handler(i, handle);
+                       irq_set_handler(irq + i, handle);
        }
 }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
