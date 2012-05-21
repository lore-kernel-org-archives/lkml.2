Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab2EUXoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:44:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52722 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab2EUXoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:44:19 -0400
MIME-Version: 1.0
In-Reply-To: <m2mx518611.fsf@firstfloor.org>
References: <4fb531069693a1b42@agluck-desktop.sc.intel.com>
 <CA+55aFxB6YSz-KEwVKtOesS7yrdvYw6sP3mfpuWBOheJVL6e+w@mail.gmail.com>
 <CA+8MBbK_xeN5HWnSvbDYwzZ+E0pSpbDte30RH2deo0r1OzYBGA@mail.gmail.com>
 <CA+55aFxvjBQ+nn2JEnrMeHrRq9O7-aost1ZYrQbOFySkU_piWg@mail.gmail.com>
 <CA+8MBbLw9ySj5VDjJJ04fW383=8AUhDfyvqdrPnAR7+-etGFqQ@mail.gmail.com>
 <CA+55aFygZYVpM7Agy+Vi+Majaa=7GLzeS8Mp9v3jiq-t+_=hLQ@mail.gmail.com> <m2mx518611.fsf@firstfloor.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 May 2012 16:43:57 -0700
X-Google-Sender-Auth: oy4Kdz9dA4nkuBDs91bVNfdb7gM
Message-ID: <CA+55aFxj8iVX0o-_G8JoAoPN2FPvttKPWCtdi4Rk8ZhV5zUsaw@mail.gmail.com>
Subject: Re: [git pull] machine check recovery fix
To: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 4:32 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> No it matters which instruction caused the error, because it's the
> one which saw data corruption. If that was not in kernel you
> can safely just return because the kernel is completely fine
> and the instruction can be restarted. It's just like a interrupt.

Wrong.

The MCE interface doesn't even *give* that information, so you're just
full of it.

There's no way to know whether the EIP that you read from the MSR
happened in real mode, in kernel mode, or whatever. You need to check
eflags and the code segment, neither of which - as far as I know, and
certainly not as far as the current code knows - even exists.

So you *have* to check the return information, not the "MCE" information.

Checking the MCE data is stupid and wrong. Stop doing it, and stop
making idiotic excuses for it.

The only thing that actually has the relevant information is the
return stack. Seriously. As such, only the RIPV bit can *possibly* be
the one that you can use. Any time you use "mce->ip" for anything at
all that isn't just reporting, you are just doing moronic things.

Stop doing stupid things.

                  Linus
