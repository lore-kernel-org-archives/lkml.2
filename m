Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab1FTHcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 03:32:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36505 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab1FTHb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 03:31:59 -0400
Date: Mon, 20 Jun 2011 09:31:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Petr Tesarik <ptesarik@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary
 physical addresses
Message-ID: <20110620073122.GA24716@elte.hu>
References: <201106171038.25988.ptesarik@suse.cz>
 <20110617093032.GA19235@elte.hu>
 <4DFE7FF9.9070406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFE7FF9.9070406@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ryan Mallon <rmallon@gmail.com> wrote:

> On 17/06/11 19:30, Ingo Molnar wrote:
> >* Petr Tesarik<ptesarik@suse.cz>  wrote:
> >
> >>This patch series enhances /dev/mem, so that read and write is
> >>possible at any address. The patchset includes actual
> >>implementation for x86.
> >This series lacks a description of why this is desired.
> >
> >My strong opinion is that it's not desired at all: /dev/mem never
> >worked beyond 4G addresses so by today it has become largely obsolete
> >and is on the way out really.
> >
> >I'm aware of these current /dev/mem uses:
> >
> >  - Xorg maps below 4G non-RAM addresses and the video BIOS
> >
> >  - It used to have some debugging role but these days kexec and kgdb
> >    has largely taken over that role - partly due to the 4G limit.
> >
> >  - there's some really horrible out-of-tree drivers that do mmap()s
> >    via /dev/mem, those should be fixed if they want to move beyond
> >    4G: their char device should be mmap()able.
> 
> There are drivers where this makes sense. For example an FPGA 
> device with a proprietary register layout on the memory bus can be 
> done this way. [...]

So you want us to help vendors screw users with insane, proprietary, 
user-space drivers with sekrit binary blobs?

Wow.

Thanks,

	Ingo
