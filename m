Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650Ab2EIRva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:51:30 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38465 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758335Ab2EIRv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:51:28 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1205082259350.16707@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1205042250130.18896@file.rdu.redhat.com>
 <20120505115851.1fecbe50@pyramind.ukuu.org.uk> <Pine.LNX.4.64.1205051448400.2623@file.rdu.redhat.com>
 <CA+55aFy2O8KcLC-yGCG2ZRpCpAdZ_T7z-sSme4fMrXG=YNAAhA@mail.gmail.com> <Pine.LNX.4.64.1205082259350.16707@file.rdu.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 9 May 2012 10:51:06 -0700
X-Google-Sender-Auth: 8QPIICG2HEhdT4mGMIQ3VFA7x7k
Message-ID: <CA+55aFwiLp1z+2mzkrFsid1WZQ0TQkcn8F2E6NL_AVR+m1fZ2w@mail.gmail.com>
Subject: Re: [PATCH] Fix compile failure on PA-RISC
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 8:20 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>>
>> Switching it to zero and testing that things still work would be appreciated.
>
> It works, but there is plenty of interrupt controllers on PC-RISC and I
> can only test it on C8000 with IO-SAPIC. I don't know if irq 0 is used on
> some PA-RISC interrupt controller. It would be best if James Bottomley
> tests it on his set of machines.

Heh. It sounds like we have more PA-RISC machines than we have actual users.

> And what about x86? --- irq 0 is used for timer and there is
> void __init setup_default_timer_irq(void)
> {
>        setup_irq(0, &irq0);
> }
> in arch/x86/kernel/time.c.

That's fine. There's no "irq" variable associated with it that people
can test. No driver will ever see an irq number of zero, no dynamic
irq code will ever see the zero.

So x86 rules have always been that the way drivers etc test for irq
existence has always been "irq 0 means no irq". Despite the fact that
it internally uses irq0 for its own nefarious uses.

                    Linus
