Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab1C3ToH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 15:44:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56801 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792Ab1C3ToF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 15:44:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V5 3/4] ARM: Xilinx: base header files and assembly macros
Date: Wed, 30 Mar 2011 21:43:51 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>, glikely@secretlab.ca,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        jamie@jamieiles.com, John Linn <John.Linn@xilinx.com>
References: <1301444651-18008-1-git-send-email-john.linn@xilinx.com> <201103301529.03648.arnd@arndb.de> <20110330191506.GD2939@n2100.arm.linux.org.uk>
In-Reply-To: <20110330191506.GD2939@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103302143.51409.arnd@arndb.de>
X-Provags-ID: V02:K0:xENXqxUOcUhvAaSyYrpUXNYOTcx98adCkr5Abg28b6Q
 3HgdD4YhkaYstpU0kKSXzUjmANp8iUDIqtCvv9EXdMunGaT3L3
 Io6BWOxr3qRQqNu/mEg6blU+iTgFmHPQ67VUmLYoqnTo31nTAL
 DPZJ3WZb2uoxHrb/EPoAwMD2du5dCPKxyHz3HzquPQhiBLxMpB
 RdHHIIfmSsPCTAQ7WdMRA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 March 2011 21:15:06 Russell King - ARM Linux wrote:
> And how do you deal with PCMCIA implementations where each socket has
> its own separate IO space, each maybe several MB large and may be spread
> across several MB of memory with the PCMCIA attribute and PCMCIA memory
> spaces interspersed.  Remember that PCMCIA drivers assume PCI/ISA IO
> support.

I would assume that the majority of implementations uses regular (64KB)
I/O spaces per bus, so within 1 MB, that could fit 16 of them.

> What about platforms which have a real ISA IO space in addition to the
> PCMCIA IO spaces?

I'd do the same as on powerpc: One of them gets registered as the "primary"
bus, which gets the first 64KB. This one is typically the only
one that can support legacy ISA devices with hardcoded I/O port numbers.

Any other bus (PCI, PCMCIA, secondary ISA if needed) can go into one
of the other 15 64KB slots.

> Things aren't as simple as you'd like them to be, and sometimes changing
> this stuff changes userland too (think PCMCIA needing the IO regions
> declared to it from userspace during boot.)

Can you give an example what hardware or driver needs this?

Anyway, the idea is more to have a standard implementation that can be
used by most platforms without causing pain, getting us one step
closer to a multiplatform kernel. If one of the more obscure platforms
doesn't fit, it can still use its own variant and not be part of the
multiplatform configuration. There are a lot of other things needed
before we get there anyway.

	Arnd
