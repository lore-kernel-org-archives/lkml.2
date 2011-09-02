Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab1IBXPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 19:15:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43788 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab1IBXO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 19:14:59 -0400
Message-ID: <af88b0d6c81fbf480eee4cef120ff710.squirrel@www.firstfloor.org>
In-Reply-To: <4E614FBD.2030509@goop.org>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
    <38bb37e15f6e5056d5238adac945bc1837a996ec.1314922370.git.jeremy.fitzhardinge@citrix.com>
    <1314974826.1861.1.camel@twins> <4E612EA1.20007@goop.org>
    <1314996468.8255.0.camel@twins> <4E614FBD.2030509@goop.org>
Date: Sat, 3 Sep 2011 01:14:55 +0200
Subject: Re: [PATCH 08/13] xen/pvticketlock: disable interrupts while
 blocking
From: "Andi Kleen" <andi@firstfloor.org>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Peter Zijlstra" <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Ingo Molnar" <mingo@elte.hu>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Nick Piggin" <npiggin@kernel.dk>, "Avi Kivity" <avi@redhat.com>,
        "Marcelo Tosatti" <mtosatti@redhat.com>, "KVM" <kvm@vger.kernel.org>,
        "Andi Kleen" <andi@firstfloor.org>,
        "Xen Devel" <xen-devel@lists.xensource.com>,
        "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
        "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> But, erm, does that even make sense?  I'm assuming the NMI reason port
> tells the CPU why it got an NMI.  If multiple CPUs can get NMIs and
> there's only a single reason port, then doesn't that mean that either 1)
> they all got the NMI for the same reason, or 2) having a single port is
> inherently racy?  How does the locking actually work there?

All the code to determine NMI reasons is inherently racy,
and each new NMI user makes it worse.

-Andi

