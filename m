Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702Ab0KQBDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:03:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:60945 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932835Ab0KQBDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:03:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,208,1288594800"; 
   d="scan'208";a="858362449"
Subject: Re: [PATCH -v4 0/2] Lockless memory allocator and list
From: Huang Ying <ying.huang@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <AANLkTime3Sh2TbgCGKir=t_TBNsd5fHipEqQwa4bVJuY@mail.gmail.com>
References: <1289868791-16658-1-git-send-email-ying.huang@intel.com>
	 <1289908158.2109.568.camel@laptop>
	 <AANLkTime3Sh2TbgCGKir=t_TBNsd5fHipEqQwa4bVJuY@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 09:03:05 +0800
Message-ID: <1289955785.8719.1154.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 00:38 +0800, Linus Torvalds wrote:
> On Tue, Nov 16, 2010 at 3:49 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2010-11-16 at 08:53 +0800, Huang Ying wrote:
> >> Hi, Len,
> >>
> >> This patchset is needed by APEI support. Which involves some lockless
> >> operations. And I think they can be used by some other part of kernel
> >> too.
> >
> > The whole notion of allocating memory from NMI context seems incredibly
> > offensive.
> >
> > And then there's the whole point of not merging stuff without a user.
> 
> So I do agree that people should look very hard at trying to use
> existing infrastructure.
> 
> I kind of like the lock-less list implementation (it could easily be
> useful for random things, and it's very simple). And I don't think the
> notion of a lockless memory allocator is wrong either, although it
> looks a lot more specialized than the list thing (the solution to
> lockless allocations is generally simply to do them ahead of time).

Yes. The general solution is that. But lockless memory allocator has
some advantages too for some situations. For example, the memory pool
backing lockless memory allocator can be enlarged or shrunken (not
implemented yet) when needed. That is hard for pre-allocation.

> So the part I'm really not all that comfy with is the whole APEI side
> of things. I'm not at all convinced that we want yet another random
> hw-specific interface, and I really have yet to hear why it's so
> magical.

Yes. Random hardware-specific interface is not good. In fact we have a
generic hardware error reporting infrastructure that can be used by
Machine Check, EDAC, PCIe AER, APEI, etc in the original patchset as
follow:

http://lkml.org/lkml/2010/10/27/23
http://lkml.org/lkml/2010/10/27/18

But it seem that nobody want to take a look at it. I will re-post the
generic hardware error reporting infrastructure patchset with better
description separately. Hope somebody will take a look at it this time.

Best Regards,
Huang Ying


