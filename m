Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1FSNhB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 09:37:01 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64511 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab1FSNg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 09:36:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gVMofGovkxk/2kgjt8YjGaZa0+W/pn1GFD/RuYl8LQh7+2bdCmuuGgXkIVAw9LUAad
         d3QoYk5oC5K0eG6yLoDO/kfd1dg6Q3PMRdhvh8Sx+f2YIxD1Gj6EsptweXFqwzkYUNUb
         BqO9UIAEnPVVlvA7UJVxKLNd/7IWDyaKAlZpQ=
MIME-Version: 1.0
In-Reply-To: <m2mxhejcgm.fsf@igel.home>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
	<BANLkTinDvLqHChPUpG9v1AXp0E=iRLteDg@mail.gmail.com>
	<m2sjr8gyp0.fsf@igel.home>
	<BANLkTikxzQSXLfr81q+b1rScW8YCcoJZRQ@mail.gmail.com>
	<m2mxhejcgm.fsf@igel.home>
Date: Sun, 19 Jun 2011 15:36:58 +0200
X-Google-Sender-Auth: JVMQvxsApZrKQiKffBDzSyL3W8Y
Message-ID: <BANLkTimWnDmKx2bh7T+V_x-pPj47faLJfw@mail.gmail.com>
Subject: Re: m68k: Convert to genirq (WIP)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Michael Schmitz <schmitzmic@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 13:19, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>
>> BUG_ON(!irqs_disabled()) triggers as flags is 0x2619 there.
>
> Which is correct, since arch_local_irq_disable would set it to 2719.
> You need to find out why arch_local_irq_disable wasn't called.

I don't think we ever explicitly disable interrupts in interrupt handlers.
The CPU disables all interupts of the same or lower level anyway.
As all Atari interrupts (except for hblank and vblank) run at level 6,
this is why flags & 0x700 == 0x600 above.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
