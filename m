Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048Ab0I0Sy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 14:54:57 -0400
Received: from www.tglx.de ([62.245.132.106]:33211 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757189Ab0I0Syz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 14:54:55 -0400
Date: Mon, 27 Sep 2010 20:49:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Luck, Tony" <tony.luck@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-cris-kernel@axis.com" <linux-cris-kernel@axis.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Greg Ungerer <gerg@uclinux.org>, Jeff Dike <jdike@addtoit.com>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: RE: [RFC trollpatch 1/1] genirq: Remove the fits all and nothing
 __do_IRQ() code
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301604712B4@orsmsx505.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.1009272048100.2416@localhost6.localdomain6>
References: <20100908152036.643594727@linutronix.de> <AANLkTikVHO9DmyTX==CwViDK1rP0masBwjMakHZ0U=kZ@mail.gmail.com> <alpine.LFD.2.00.1009271953390.2416@localhost6.localdomain6> <987664A83D2D224EAE907B061CE93D5301604712B4@orsmsx505.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Sep 2010, Luck, Tony wrote:

> > No, it's deliberate. The solution is to use the correct flow handler
> > for your device. We have currently several flow handlers implemented:
> 
> Yes, I found the different "handle_*_irq()" functions. The _percpu_
> variant works fine for the ia64 per-cpu interrupt paths.
> 
> But *NONE* of them call desc->chip->end() (even though the code flow
> in Documentation/DcoBook/genericirq.tmpl says that three of them do
> call it].  So it appears that this was thought to be necessary when
> the docs were written, but was not put into the code.

Yeah, sorry.
 
> The ia64 chip->end function for edge triggered interrupts is a nop(),
> so handle_edge_irq() ought to work just fine for it [can't confirm
> from my initial tests because the HP box I'm using only has level
> triggered ones].
> 
> handle_level_irq() works for my level triggered interrupts if I add
> a "desc->chip->end(irq)" call to it.

Hmm, why isn't chip->unmask() sufficient ?
 
> git grep "chip->end" appears to show that the only use of chip->end
> is in the "Recovery handler for misrouted interrupts": try_one_irq()

Right, that's just due to the old __do_IRQ() compability.
 
> At minimum we seem to have some documentation inconsistencies with
> the code.

Will fix.

Thanks,

	tglx
