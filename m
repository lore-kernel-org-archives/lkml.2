Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab1CILI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 06:08:27 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34620 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab1CILIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 06:08:25 -0500
Message-ID: <4D775FA4.50706@monstr.eu>
Date: Wed, 09 Mar 2011 12:08:20 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] futex: cmpxchg_futex_value_locked API change
References: <20110307021127.GB31188@google.com>
In-Reply-To: <20110307021127.GB31188@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse wrote:
> Aplogies for the long CC list - as this proposal involves asm changes
> in many architectures, and I have only been able to test on x86,
> I have tried to include one maintainer from every arch so they can
> hopefully double check me. I do think I got all architectures right,
> but you can never be 100% sure...
> 
> ------------------------------------8<---------------------------------
> 
> The cmpxchg_futex_value_locked API was funny in that it returned either
> the original, user-exposed futex value OR an error code such as -EFAULT.
> This was confusing at best, and could be a source of livelocks in places
> that retry the cmpxchg_futex_value_locked after trying to fix the issue
> by running fault_in_user_writeable().
> 
> This change makes the cmpxchg_futex_value_locked API more similar to the
> get_futex_value_locked one, returning an error code and updating the
> original value through a reference argument.
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>
> ---
>  arch/alpha/include/asm/futex.h      |   22 +++++++++-------
>  arch/arm/include/asm/futex.h        |   23 +++++++++--------
>  arch/frv/include/asm/futex.h        |    3 +-
>  arch/ia64/include/asm/futex.h       |    9 ++++--
>  arch/microblaze/include/asm/futex.h |   24 ++++++++++--------

For microblaze:
Tested-by: Michal Simek <monstr@monstr.eu>

M

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
