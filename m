Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab2J1Uir (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 16:38:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:59454 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346Ab2J1Uio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 16:38:44 -0400
Message-ID: <1351456697.12271.113.camel@pasglop>
Subject: Re: [RESEND PATCH 2/4] asm-generic: io: don't perform swab during
 {in,out} string functions
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>
Date: Mon, 29 Oct 2012 07:38:17 +1100
In-Reply-To: <CAMuHMdXJaUD6u+m1ax1_QYVXDrdm-W7VDUq0VN6a_v9QAgP4og@mail.gmail.com>
References: <1350488704-3711-1-git-send-email-will.deacon@arm.com>
	 <1350488704-3711-3-git-send-email-will.deacon@arm.com>
	 <CAMuHMdXcQjDyen+o5aH=1zUOkNX-cfT3aXBOgCpyop=V67jk7w@mail.gmail.com>
	 <1350518655.4678.120.camel@pasglop>
	 <CAMuHMdWH3GXJ_dW-FCAX=LAkBuQmQtwRUtNpcqg_afm-UFK_2g@mail.gmail.com>
	 <1350955556.2728.18.camel@pasglop>
	 <CAMuHMdXJaUD6u+m1ax1_QYVXDrdm-W7VDUq0VN6a_v9QAgP4og@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-10-28 at 10:28 +0100, Geert Uytterhoeven wrote:

> > This is due to how the PCI bus is wired to the CPU bus, which is called
> > "byte address invariant". When doing a read of your byte 0, the CPU will
> > effectively read 0 with byte enables picking 48. Since the CPU wants
> > the first byte in the MSB, the bus must be wired up to the CPU such that
> > the MSB is the first byte in address order.
> 
> According to
> https://developer.apple.com/library/mac/#documentation/DeviceDrivers/Conceptual/WritingPCIDrivers/endianness/endianness.html
> 
> "Byte-invariant addressing is a property of the bus bridge itself."

Right.

> and
> 
> "From the software designer’s perspective, this means that the
> hardware does not byte swap the data. However, from the hardware
> designer’s perspective, the hardware must byte swap all data."
> 
> So this depends on a correct hardware implementation in the PCI
> host bridge?

Correct. It is also how AMBA works on BE for example, it's generally
accepted that this is the "right" way to wire a bridge.

> > Then something is horribly wrong in those m68k setups :-) Either in the
> > way the busses are wired or in your implementation of either inw or
> > insw.
> 
> On (classic) m68k all of this is not about PCI (Atari Hades PCI is no
> more), but about ISA and PCMCIA. I.e. no PCI host bridge with a modern
> understanding of how it should be wired correctly on a big endian platform.

There's nothing modern about byte address invariance. The same rule
applies to ISA and PCMCIA just the same. It's possible that your
specific m68k platforms were designed by monkeys on crack, which seems
to be a common breed among HW designers, but that doesn't make it
right :-)

Cheers,
Ben.


