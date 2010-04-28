Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab0D1Q1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 12:27:12 -0400
Received: from mail.openrapids.net ([64.15.138.104]:40275 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753913Ab0D1Q1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 12:27:10 -0400
Date: Wed, 28 Apr 2010 12:27:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Peter Fritzsche <peter.fritzsche@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Keith M Wesolowski <wesolows@foobazco.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 2/2] asm-generic: Don't warn that atomic_t is only 24
	bit
Message-ID: <20100428162708.GB2846@Krystal>
References: <1272451837-17961-1-git-send-email-peter.fritzsche@gmx.de> <1272453036-18670-1-git-send-email-peter.fritzsche@gmx.de> <201004281533.29327.arnd@arndb.de> <20100428135434.GA4662@Krystal> <20100428152815.GB25569@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428152815.GB25569@shareable.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:22:45 up 95 days, 18:59,  7 users,  load average: 0.01, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jamie Lokier (jamie@shareable.org) wrote:
> Mathieu Desnoyers wrote:
> > * Arnd Bergmann (arnd@arndb.de) wrote:
> > > On Wednesday 28 April 2010, Peter Fritzsche wrote:
> > > > 32-bit Sparc used to only allow usage of 24-bit of it's atomic_t type.
> > > > This was corrected with linux 2.6.3 when Keith M Wesolowski changed the
> > > > implementation to use the parisc approach of having an array of
> > > > spinlocks to protect the atomic_t.
> > > > 
> > > > These warnings were also removed from the sparc implementation when the
> > > > new implementation was merged in BKrev:402e4949VThdc6D3iaosSFUgabMfvw,
> > > > but the warning still remained in some other places without any
> > > > 24-bit-only atomic_t implementation inside the kernel.
> > > > 
> > > > We should remove these warnings to allow users to rely on the full
> > > > 32-bit range of atomic_t.
> > > > 
> > > > Signed-off-by: Peter Fritzsche <peter.fritzsche@gmx.de>
> > > 
> > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > 
> > AFAIK that was the last architecture imposing limitations below 32 bits
> > on atomic_t.
> > 
> > Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> 
> If the comment's getting removed, it should probably go from here too:
> 
> linux-2.6$ git grep '24' arch/*/include/*/atomic*
> arch/mn10300/include/asm/atomic.h: * useful range of an atomic_t is only 24 bits
> arch/mn10300/include/asm/atomic.h: * useful range of an atomic_t is only 24 bits
> arch/mn10300/include/asm/atomic.h: * Note that the guaranteed useful range of an
> arch/mn10300/include/asm/atomic.h: * Note that the guaranteed useful range of an


How about simply replacing arch/mn10300/include/asm/atomic.h by:

arch/mn10300/include/asm/atomic.h:
#include <asm-generic/atomic.h>

?

This should have been done a while ago. They are almost the same, except for
added cmpxchg*_local() in the asm-generic version (which would benefit to
mn10300).

Thanks,

Mathieu

> 
> -- Jamie

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
