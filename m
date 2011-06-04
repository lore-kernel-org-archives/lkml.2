Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab1FDR47 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 13:56:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51468 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab1FDR46 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 13:56:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eanixO4ttkPAzGexB8mYrHezZcmTcPmjAnDfyXQd1pTWiKofpEGHRxJi6H1udpiwNu
         iYwA6HpdssE/SVBL+hfRAaQHYXJMKUaFf+3BE+wWVz4LAM5wsmT42WvDQpzMjylGH+ma
         OX+tYUvhPq6HQBLdSm51QmbaQL+kXU5jvFLLg=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
Date: Sat, 4 Jun 2011 19:56:56 +0200
X-Google-Sender-Auth: dngxEgUbMIipOMOM_NxWBjpyn8Q
Message-ID: <BANLkTimebx56-Wb5JPWxYVnND9gG8OVdsQ@mail.gmail.com>
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
> Now sparc32 has beaten me, I pushed out my work in progress of converting m68k
> to use the generic hardirq framework:
>
> git://git.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git m68k-genirq
> http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git;a=shortlog;h=refs/heads/m68k-genirq

> Next on my list is Amiga, which will cover autovectored and chained interrupts.

I rebased to 3.0-rc1 and added (not in that order):
  [10] m68k/irq: Add m68k_setup_irq_controller()
  [11] m68k/irq: Adding missing "irq" offset in m68k_setup_irq_controller()
  [12] m68k/irq: Fix auto and user chips and handlers
  [13] m68k/amiga: Refactor amiints.c
  [14] m68k/amiga: Convert Amiga to genirq
  [15] m68k/amiga: Optimize interrupts using chain handlers

It works on Amiga now, too. It can still use some optimizations in the
irq_{enable,disable,ack,mask,mask_ack,unmask} area, as my BogoMIPS
rating dropped by ca 2.5% and is now under 16, for a 25 MHz 68040.

BTW, the second warning on Atari is still there.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
