Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab2BBVkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:40:09 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57531 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757143Ab2BBVkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:40:07 -0500
X-Sasl-enc: EEFMxhNliKiYmuPp7EiuQBTpo7EKTffVrlx7unpuIRpR 1328218804
Message-ID: <4F2B0293.1000709@ladisch.de>
Date: Thu, 02 Feb 2012 22:39:31 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Edward Donovan <edward.donovan@numble.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Palmer <chris.palmer@pobox.com>,
        Robert Hancock <hancockrwd@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        ghost3k@ghost3k.net, linux-kernel@vger.kernel.org, keve@irb.hu,
        bjorn.ottervik@gmail.com, kaneda@freemail.hu,
        jeroen.vandenkeybus@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: ASM1083 PCIx-PCI bridge interrupts - widespread problems
References: <4E68A6E8.9020700@pobox.com> <20110908165155.f661a738.akpm@linux-foundation.org> <4F26B162.4050000@pobox.com> <4F274E28.2010200@gmail.com> <4F27D9AD.1020806@pobox.com> <CADdbW+Eaab4ucATwX+ao-P+kcms-AJKQMGZr2E6g73gLACZSZg@mail.gmail.com> <CA+55aFytBRZiQUcnWtSYnxqXUJCfVuS4f5tq=QUNG2GfbF1mhA@mail.gmail.com> <CADdbW+EmBWiz=3UDvN+UtXZ-io7iJsDfia6xWPm+MrrH+xXA3w@mail.gmail.com>
In-Reply-To: <CADdbW+EmBWiz=3UDvN+UtXZ-io7iJsDfia6xWPm+MrrH+xXA3w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Edward Donovan wrote:
> * New logic in the generic IRQ code, in spurious.c, adding a "try
> polling, then re-enable for
>  a while" method, for everybody?

This is useful in the general case, if the interrupt line eventually
gets unstuck.  With the ASM1083, we know this happens when another
interrupt comes in, but we don't know when (the sound card mentioned in
the link above issues interrupts every few milliseconds; Jeroen's on-
board FireWire controller fires a timer every 64 s; his network card
might not get any action if there isn't any traffic).

> * A warning message about ASM1083, under arch/ or drivers/ ?  A better
> place for special checks, than the genirq code.  (Right?)

drivers/pci/quirks.c

> * Could there be more hardware-specifc code, to crank up the
> frequency,

... and lower the threshold for detecting a stuck interrupt, ...

> when you do have this chip?

This would be sensible, as this is not a catch-all debugging measure but
a workaround for a known problem.

> I don't think we have this facility at present: would we let the
> arch-or-drivers code set a variable, to be honored by irq/spurious.c?

Wouldn't be the first one that affects generic code.


Regards,
Clemens
