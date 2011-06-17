Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab1FQJaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 05:30:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50771 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758833Ab1FQJaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 05:30:52 -0400
Date: Fri, 17 Jun 2011 11:30:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20110617093032.GA19235@elte.hu>
References: <201106171038.25988.ptesarik@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106171038.25988.ptesarik@suse.cz>
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


* Petr Tesarik <ptesarik@suse.cz> wrote:

> This patch series enhances /dev/mem, so that read and write is 
> possible at any address. The patchset includes actual 
> implementation for x86.

This series lacks a description of why this is desired.

My strong opinion is that it's not desired at all: /dev/mem never 
worked beyond 4G addresses so by today it has become largely obsolete 
and is on the way out really.

I'm aware of these current /dev/mem uses:

 - Xorg maps below 4G non-RAM addresses and the video BIOS

 - It used to have some debugging role but these days kexec and kgdb 
   has largely taken over that role - partly due to the 4G limit.

 - there's some really horrible out-of-tree drivers that do mmap()s
   via /dev/mem, those should be fixed if they want to move beyond 
   4G: their char device should be mmap()able.

 - all distro kernel's i'm aware of use CONFIG_STRICT_DEVMEM=y, which
   restricts /dev/mem to non-RAM pages of physical memory.
   [ With the sad inclusion of the first 1MB, which Xorg needs. ]

Are you aware of any legitimate usecases?

Frankly, i dont think we ever *want* to 'fix' /dev/mem to support 
addresses beyond 4G and grow messy userspace (and kernelspace) that 
somehow relies on that. Thank goodness that we never supported it ...

Thanks,

	Ingo
