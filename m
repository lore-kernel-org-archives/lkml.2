Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868Ab1FQJqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 05:46:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57630 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758453Ab1FQJqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 05:46:20 -0400
Date: Fri, 17 Jun 2011 10:41:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Petr Tesarik <ptesarik@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of
	arbitrary physical addresses
Message-ID: <20110617094125.GE32629@n2100.arm.linux.org.uk>
References: <201106171038.25988.ptesarik@suse.cz> <20110617093032.GA19235@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110617093032.GA19235@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 11:30:32AM +0200, Ingo Molnar wrote:
> I'm aware of these current /dev/mem uses:
> 
>  - Xorg maps below 4G non-RAM addresses and the video BIOS
> 
>  - It used to have some debugging role but these days kexec and kgdb 
>    has largely taken over that role - partly due to the 4G limit.
> 
>  - there's some really horrible out-of-tree drivers that do mmap()s
>    via /dev/mem, those should be fixed if they want to move beyond 
>    4G: their char device should be mmap()able.
> 
>  - all distro kernel's i'm aware of use CONFIG_STRICT_DEVMEM=y, which
>    restricts /dev/mem to non-RAM pages of physical memory.
>    [ With the sad inclusion of the first 1MB, which Xorg needs. ]

There's another use case for /dev/mem:

 - debugging via devmem2 on embedded platforms, where you want to be able
   to boot a kernel, and then peek and poke at MMIO registers either to
   verify register values or test things out.
