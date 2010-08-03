Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0HCJo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:44:56 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:7065 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754079Ab0HCJoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:44:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAL+BV0x5LcpI/2dsb2JhbACgCXLBX4U5BA
Date: Tue, 3 Aug 2010 19:44:51 +1000
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH RFC 10/12] x86/pvticketlock: keep count of blocked cpus
Message-ID: <20100803094451.GA5556@amd>
References: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com>
 <9d5625e61c7f35e72156e8cb881e55910b4fa5dc.1279328276.git.jeremy.fitzhardinge@citrix.com>
 <1280824360.1923.421.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280824360.1923.421.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 10:32:40AM +0200, Peter Zijlstra wrote:
> On Fri, 2010-07-16 at 18:03 -0700, Jeremy Fitzhardinge wrote:
> > @@ -26,6 +26,9 @@ typedef struct arch_spinlock {
> >                         __ticket_t head, tail;
> >                 } tickets;
> >         };
> > +#ifdef CONFIG_PARAVIRT_SPINLOCKS
> > +       __ticket_t waiting;
> > +#endif
> >  } arch_spinlock_t; 
> 
> This bloats spinlock_t from u32 to u64 on most distro configs I think,
> since they'll have NR_CPUS=4096 or something large like that and
> probably also want to have this PARAVIRT_SPINLOCKS thing.

Which sucks for carefully packed data structures like dentry.
They'll tend to grow by 8 bytes per spinlock.
