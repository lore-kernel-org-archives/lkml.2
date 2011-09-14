Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab1INMuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 08:50:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406Ab1INMt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 08:49:59 -0400
Date: Wed, 14 Sep 2011 08:49:17 -0400
From: Don Zickus <dzickus@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
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
Message-ID: <20110914124917.GS5795@redhat.com>
References: <20110907134411.GV5795@redhat.com>
 <4E678992.5050709@redhat.com>
 <20110907155657.GX5795@redhat.com>
 <4E679AF4.50209@redhat.com>
 <20110907165203.GQ6838@redhat.com>
 <4E67A551.4000502@redhat.com>
 <20110913184044.GN5795@redhat.com>
 <20110913190320.GR7761@one.firstfloor.org>
 <20110913192152.GO5795@redhat.com>
 <4E7050F7.3000208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7050F7.3000208@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 10:00:07AM +0300, Avi Kivity wrote:
> On 09/13/2011 10:21 PM, Don Zickus wrote:
> >Or are you saying an NMI in an idle system will have the same %rip thus
> >falsely detecting a back-to-back NMI?
> >
> >
> 
> That's easy to avoid - insert an instruction zeroing the last
> nmi_rip somewhere before or after hlt.  It's always okay to execute
> such an instruction (outside the nmi handler itself), since nmi_rip
> is meant to detect a "no instructions executed" condition.

Ah. Like a touch_nmi_watchdog() type of thing.  Interesting.  I'll poke
around the idle code.  Need to instrument a reproducer first.

Thanks,
Don
