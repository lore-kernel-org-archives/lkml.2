Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab1IBUsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 16:48:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:35772 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab1IBUsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 16:48:37 -0400
Subject: Re: [PATCH 08/13] xen/pvticketlock: disable interrupts while
 blocking
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Fri, 02 Sep 2011 22:47:48 +0200
In-Reply-To: <4E612EA1.20007@goop.org>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
	  <38bb37e15f6e5056d5238adac945bc1837a996ec.1314922370.git.jeremy.fitzhardinge@citrix.com>
	 <1314974826.1861.1.camel@twins> <4E612EA1.20007@goop.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314996468.8255.0.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-02 at 12:29 -0700, Jeremy Fitzhardinge wrote:
> 
> > I know that its generally considered bad form, but there's at least one
> > spinlock that's only taken from NMI context and thus hasn't got any
> > deadlock potential.
> 
> Which one? 

arch/x86/kernel/traps.c:nmi_reason_lock

It serializes NMI access to the NMI reason port across CPUs.
