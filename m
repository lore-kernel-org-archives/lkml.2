Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab1FSKRh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 06:17:37 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:53323 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab1FSKRf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 06:17:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZEadBRogz/lzF8zU6bMm16C4JG/nxKvnLRzy9zH0CKUgsX5vRE9wN6mcsaZiz63H1O
         rGBLJ2Ej/SZ3MUuuUJX9xH+oqBYBXGQu8KRNQf/gfn68cFbuDqa9R7dgB61/teWIsmCX
         NeDKZpaNMHOb1R9A8Aa2oW79r92yKdVZNu+ZA=
MIME-Version: 1.0
In-Reply-To: <m2sjr8gyp0.fsf@igel.home>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
	<BANLkTinDvLqHChPUpG9v1AXp0E=iRLteDg@mail.gmail.com>
	<m2sjr8gyp0.fsf@igel.home>
Date: Sun, 19 Jun 2011 12:17:34 +0200
X-Google-Sender-Auth: Hw9jePo-FPtCRp9qOnmVF33eOMU
Message-ID: <BANLkTikxzQSXLfr81q+b1rScW8YCcoJZRQ@mail.gmail.com>
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

On Fri, Jun 17, 2011 at 19:22, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>
>> This is the WARN_ONCE(!irqs_disabled()) check.
>>
>> static inline bool arch_irqs_disabled_flags(unsigned long flags)
>> {
>>         return (flags & ~ALLOWINT) != 0;
>
> That should be
>
>          return (flags & 0x700) == 0x700;
>
> It doesn't make sense to use ALLOWINT here, since arch_local_irq_disable
> doesn't use it either.

Unfortunately this makes it worse:

| Calibrating delay loop... kernel BUG at kernel/posix-cpu-timers.c:1314!

BUG_ON(!irqs_disabled()) triggers as flags is 0x2619 there.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
