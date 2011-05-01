Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761257Ab1EARB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 13:01:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761232Ab1EARBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 13:01:55 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTik_aeVn9Jf_cWnoY0fNUm+tjMnixA@mail.gmail.com>
References: <Xp4OiTz83N.A.O0D.JVGvNB@chimera> <G9uL1cldhmL.A.sNF.dWGvNB@chimera>
 <BANLkTinZRdGROHZqjLFtr=buEUNwyYhVpQ@mail.gmail.com> <BANLkTik_aeVn9Jf_cWnoY0fNUm+tjMnixA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 1 May 2011 10:01:05 -0700
Message-ID: <BANLkTimbLpMNzfKpyigH6n3arNUywEGk1w@mail.gmail.com>
Subject: Re: [Bug #32982] Kernel locks up a few minutes after boot
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 1, 2011 at 2:55 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>
> There is something else and completely unrelated that is puzzling me though:
> on two almost identical systems one always recognizes all internal PCIe
> cards but the other system not. This is something that seldom happened with
> 2.6.34 but happens frequently with 2.6.38 and 2.6.39-rcx. What I see is that
> during boot either both InfiniBand PCIe cards are recognized or that one
> specific card is not recognized and even doesn't show up in the lspci
> output. A BIOS upgrade didn't help. Any idea where I should start looking to
> find the cause of this issue ?

So it has happened sporadically before, but happens much more commonly
now? That very much implies some timing issue in PCI probing.

It could be, for example, that the card has a very slow reset
sequence, and doesn't respond to PCI config cycles until it has
internally booted fully. If so, a faster boot by the kernel might just
cause the Linux PCI enumeration to be done before the card is ready.

(That's a really unlikely scenario - I'm not seriously suggesting that
the card would be quite <i>that</i> stupid and slow. But there might
be similar issues at a much lower level, ie if the Linux pcie port
driver might be resetting the port and then trying to read the card
too quickly afterwards, and you'd want some added delay there).

Have you tried it "pcie_ports=compat" (or "native") makes any difference?

But you should probably contact Jesse Barnes and the linux-pci mailing
list and see if anybody has any smarter ideas.

                       Linus
