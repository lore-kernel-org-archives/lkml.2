Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab1IMUxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 16:53:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932446Ab1IMUxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 16:53:47 -0400
Date: Tue, 13 Sep 2011 16:53:18 -0400
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
Message-ID: <20110913205318.GQ5795@redhat.com>
References: <20110907134411.GV5795@redhat.com>
 <4E678992.5050709@redhat.com>
 <20110907155657.GX5795@redhat.com>
 <4E679AF4.50209@redhat.com>
 <20110907165203.GQ6838@redhat.com>
 <4E67A551.4000502@redhat.com>
 <20110913184044.GN5795@redhat.com>
 <20110913190320.GR7761@one.firstfloor.org>
 <20110913192152.GO5795@redhat.com>
 <20110913195838.GS7761@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110913195838.GS7761@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 09:58:38PM +0200, Andi Kleen wrote:
> > Or are you saying an NMI in an idle system will have the same %rip thus
> > falsely detecting a back-to-back NMI?
> 
> Yup.

Hmm.  That sucks.  Is there another register that can be used in
conjunction to seperate it, like sp or something?  Or we can we assume
than an idle cpu isn't doing much for local NMI IPIs and that the only
NMIs that would interrupt it would be external ones?

> 
> Another problem is very long running instructions, like WBINVD and some others.
> If there's a high frequency NMI it may well hit multiple times in a single
>  instance.

I thought NMIs happen on instruction boundaries, maybe not.

Honestly, our current implementation would probably be tripped up with
those examples too, so I don't think I am making things worse (assuming
the only high frequency NMI is coming from perf).

Cheers,
Don
