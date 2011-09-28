Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab1I1I0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:26:14 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:33556 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab1I1I0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:26:10 -0400
Date: Wed, 28 Sep 2011 10:24:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: Could you reinstate ticketlock cleanups in tip.git
Message-ID: <20110928082430.GA29264@elte.hu>
References: <alpine.LFD.2.02.1109280209430.2711@ionos>
 <20110928063115.GA24510@elte.hu>
 <4E82C169.8060803@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E82C169.8060803@goop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -1.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.9 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.1 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> On 09/27/2011 11:31 PM, Ingo Molnar wrote:
> > * Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> >> Hi Thomas,
> >>
> >> Could you reinstate the ticketlock cleanup series in tip.git (I think it
> >> was in x86/spinlocks) from
> >>     git://github.com/jsgf/linux-xen.git upstream/ticketlock-cleanup
> >>
> >> This branch is the final result of all the discussions and revisions and
> >> is ready for the next merge window.  It's the one that's been in
> >> linux-next for a couple of weeks (at least), and won't cause any
> >> conflicts there.
> >>
> >> Or if you prefer I can submit it myself for next merge window.
> >>
> >> Thanks,
> >>     J
> > I'd prefer if this went via x86/spinlocks. Could you please send a 
> > proper pull request with diffstat, shortlog, etc?
> >
> 
> Sure, here you are:
> 
> The following changes since commit c6a389f123b9f68d605bb7e0f9b32ec1e3e14132:
> 
>   Linux 3.1-rc4 (2011-08-28 21:16:01 -0700)
> 
> are available in the git repository at:
>   git://github.com/jsgf/linux-xen upstream/ticketlock-cleanup
> (commit 4a7f340c6a75ec5fca23d9c80a59f3f28cc4a61e)
> 
> Jeremy Fitzhardinge (12):
>       x86, cmpxchg: <linux/alternative.h> has LOCK_PREFIX
>       x86, cmpxchg: Move 32-bit __cmpxchg_wrong_size to match 64 bit.
>       x86, cmpxchg: Move 64-bit set64_bit() to match 32-bit
>       x86, cmpxchg: Unify cmpxchg into cmpxchg.h
>       x86: Add xadd helper macro
>       x86: Use xadd helper more widely
>       x86, ticketlock: Clean up types and accessors
>       x86, ticketlock: Convert spin loop to C
>       x86, ticketlock: Convert __ticket_spin_lock to use xadd()
>       x86, ticketlock: Make __ticket_spin_trylock common
>       x86, cmpxchg: Use __compiletime_error() to make usage messages a bit nicer
>       x86, ticketlock: remove obsolete comment
> 
>  arch/x86/include/asm/atomic.h         |    8 +-
>  arch/x86/include/asm/atomic64_64.h    |    6 +-
>  arch/x86/include/asm/cmpxchg.h        |  205 +++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/cmpxchg_32.h     |  114 ------------------
>  arch/x86/include/asm/cmpxchg_64.h     |  131 ---------------------
>  arch/x86/include/asm/rwsem.h          |    8 +-
>  arch/x86/include/asm/spinlock.h       |  114 +++++--------------
>  arch/x86/include/asm/spinlock_types.h |   22 +++-
>  arch/x86/include/asm/uv/uv_bau.h      |    6 +-
>  9 files changed, 257 insertions(+), 357 deletions(-)

Pulled, thanks Jeremy!

	Ingo
