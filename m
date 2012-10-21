Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab2JUOjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 10:39:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42261 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2JUOjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 10:39:19 -0400
MIME-Version: 1.0
In-Reply-To: <20121021120901.GA22587@joi.lan>
References: <1724445.dN2yMEzN6d@localhost> <20121020212036.GA1698@fritha.org>
 <20121020221948.GE5826@joi.lan> <2155889.FOmdXlva7q@localhost> <20121021120901.GA22587@joi.lan>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 21 Oct 2012 07:38:58 -0700
X-Google-Sender-Auth: nMJ2jIM4GGvBjtkCRh-v6doYJMg
Message-ID: <CA+55aFzYDY0FLGhVevqv9Gk0bnJnM4r13=JzWDO9hdySi8zFoA@mail.gmail.com>
Subject: Re: Linux 3.7-rc1 (nouveau_bios_score oops).
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Heinz Diehl <htd@fritha.org>, Martin Peres <martin.peres@labri.fr>,
        Heinz Diehl <htd@fancy-poultry.org>, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-2?Q?Pawe=B3_Sikora?= <pawel.sikora@agmk.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2012 at 5:09 AM, Marcin Slusarz
<marcin.slusarz@gmail.com> wrote:
>
> This looks like ACPI bug...

I'm _shocked_ to hear that firmware would be fragile.

Anyway, here's the #1 thing to keep in mind about firmware:

 - firmware is *always* buggy.

It's that simple. Don't expect anything else. Firmware is written by
people who have lost the will to live (why? Because they do firmware
development for a living), and the only thing keeping them going is
the drugs. And they're not the "fun" kind of drugs. The end result is
predictable. In their drug-induced haze, they make a mess.

So saying "ACPI is buggy" is like saying "water is wet". Deal with it.

> Nouveau calls this method: [...]
>
> with Arg0 == 0, Arg1 == 3 and gets:
>
> ACPI Error: Field [ROMI] Base+Offset+Width 0+24+1 is beyond end of region [VROM] (length 24) (20120913/exfldio-210)
> ACPI Error: Method parse/execution failed [\_SB_.PCI0.PEGR.GFX0._ROM] (Node ffff88033e47fe88), AE_AML_REGION_LIMIT (20120913/psparse-536)
>
> We can workaround it by aligning Arg1 to 4096 (I'm wondering what is the minimal
> value), but do we really have to?

Yes, you really have to. You need to understand that ACPI has been
tested with one thing, and one thing only: Windows. Clearly windows
doesn't ask for some three-byte region. So it doesn't work. Big
surprise. Untested code written by monkeys on crack - what did you
expect?

So don't do "clever" things. When it comes to firmware, you need to
expect it to be buggy, and try to access it the way Windows accesses
it.

Now, whether Windows realy always does things with a 4kB-aligned
access, or whether you just need to make sure that you're (say)
4-byte-aligned, I don't know. Maybe doing things four (or eight, or
sixteen) bytes at a time will work. You can try. But if we know from
past experience that a 4kB block-size will work, I'd suggest just
saying

  "It's stupid, but stupid is good - we're working with firmware"

Think of firmware the way you think of hardware: it's buggy and needs
workarounds.

                Linus
