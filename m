Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab1IMT1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 15:27:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127Ab1IMT1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 15:27:40 -0400
Date: Tue, 13 Sep 2011 15:27:06 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Avi Kivity <avi@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Marcelo Tosatti <mtosatti@redhat.com>,
        KVM <kvm@vger.kernel.org>, Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH 08/13] xen/pvticketlock: disable interrupts while blocking
Message-ID: <20110913192706.GP5795@redhat.com>
References: <20110906182758.GR5795@redhat.com>
 <4E66EF86.9070200@redhat.com>
 <20110907134411.GV5795@redhat.com>
 <4E678992.5050709@redhat.com>
 <20110907155657.GX5795@redhat.com>
 <4E679AF4.50209@redhat.com>
 <20110907165203.GQ6838@redhat.com>
 <4E67A551.4000502@redhat.com>
 <20110913184044.GN5795@redhat.com>
 <20110913190320.GR7761@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110913190320.GR7761@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 09:03:20PM +0200, Andi Kleen wrote:
> > So I got around to implementing this and it seems to work great.  The back
> > to back NMIs are detected properly using the %rip and that info is passed to
> > the NMI notifier.  That info is used to determine if only the first
> > handler to report 'handled' is executed or _all_ the handlers are
> > executed.
> > 
> > I think all the 'unknown' NMIs I generated with various perf runs have
> > disappeared.  I'll post a new version of my nmi notifier rewrite soon.
> 
> This will fail when the system is idle.

Oh one other thing I forgot to mention is that an NMI handler has to
return a value greater than 1, meaning that it handle multiple NMI events
during this NMI to even enable the 'NMI swallowing' algorithm.

Cheers,
Don
