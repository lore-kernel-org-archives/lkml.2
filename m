Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab1INR2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 13:28:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50594 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098Ab1INR2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 13:28:40 -0400
Date: Wed, 14 Sep 2011 19:28:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>,
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
Message-ID: <20110914172838.GV7761@one.firstfloor.org>
References: <20110907155657.GX5795@redhat.com> <4E679AF4.50209@redhat.com> <20110907165203.GQ6838@redhat.com> <4E67A551.4000502@redhat.com> <20110913184044.GN5795@redhat.com> <20110913190320.GR7761@one.firstfloor.org> <20110913192152.GO5795@redhat.com> <4E7050F7.3000208@redhat.com> <20110914144926.GU7761@one.firstfloor.org> <4E70C1BE.7060209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E70C1BE.7060209@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If an NMI hits in an interrupt handler, or in the "after hlt" section 
> before the write-to-last-nmi-rip, then we'll see that %rip has changed.  
> If it hits after the write-to-last-nmi-rip instruction (or in the hlt 
> itself), then we'll also see that %rip has changed, due to the effect of 
> that instruction.

It won't handle multiple NMIs in halt. I assume that's reasonable common.

-Andi
