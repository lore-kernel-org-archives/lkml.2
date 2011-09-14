Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab1INOtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 10:49:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41576 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab1INOta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 10:49:30 -0400
Date: Wed, 14 Sep 2011 16:49:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
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
Message-ID: <20110914144926.GU7761@one.firstfloor.org>
References: <20110907134411.GV5795@redhat.com> <4E678992.5050709@redhat.com> <20110907155657.GX5795@redhat.com> <4E679AF4.50209@redhat.com> <20110907165203.GQ6838@redhat.com> <4E67A551.4000502@redhat.com> <20110913184044.GN5795@redhat.com> <20110913190320.GR7761@one.firstfloor.org> <20110913192152.GO5795@redhat.com> <4E7050F7.3000208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7050F7.3000208@redhat.com>
User-Agent: Mutt/1.4.2.2i
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
> That's easy to avoid - insert an instruction zeroing the last nmi_rip 
> somewhere before or after hlt.  It's always okay to execute such an 
> instruction (outside the nmi handler itself), since nmi_rip is meant to 
> detect a "no instructions executed" condition.

At least for classic hlt there is no simple "after hlt" because it's all
interrupt handlers and exceptions and everything else that can interrupt
combined.

It may work with newer MWAIT.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
