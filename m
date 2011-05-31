Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab1EaTya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:54:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35859 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab1EaTy1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:54:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oJKMqcHRripmY3Tk2VKspqQrRyD0WuQclViixt0/FFvlrKsvNTnk6naYVt+OVc0oQ+
         sjLkk64bvFqBfPT7iWZedQx+RYO7d4GRWl+X+HTwCjuy3LYIQ1WruNCjXLGq33/2zwB2
         sDDFHii5Fkx0OGaGUjH8TiubRYubJqoa1r034=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
Date: Tue, 31 May 2011 21:54:26 +0200
X-Google-Sender-Auth: EG12IUkgE_2vJQ4_KUSvgFZALX4
Message-ID: <BANLkTinsMhQZSeO_ujtYEJuOcAa=FRh-6g@mail.gmail.com>
Subject: Re: m68k: Convert to genirq (WIP)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Sat, May 28, 2011 at 20:32, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Next on my list is Amiga, which will cover autovectored and chained interrupts.

Plain chained interrupts should be handled by calling irq_set_chained_handler()
to register an irq_flow_handler_t, and let the handler call
generic_handle_irq() for
each successive interrupt, right?

However, on Amiga we have interrupts (IRQ_AMIGA_PORTS and
IRQ_AMIGA_EXTER) that are a combination of chained (for the CIA interrupt
controllers) and shared level interrupts (for motherboard hardware and
Zorro expansion
boards).
But irq_set_chained_handler() sets IRQ_NOREQUEST, i.e. the interrupt cannot
be requested anymore via request_irq(), so this rules out using it with shared
level interrupts.

What's the preferred way to handle this? Is there are standard way, or should I
write my own specialized irq_flow_handler_t that handles both?

In the old scheme, we just registered the chain handlers with
request_irq(), so they
worked nicely together with the shared level interrupts (cfr.
arch/m68k/amiga/cia.c)

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
