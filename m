Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab2DTTnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 15:43:12 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:40082 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab2DTTnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 15:43:10 -0400
Date: Fri, 20 Apr 2012 21:43:09 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Weirdness in __alloc_bootmem_node_high
Message-ID: <20120420194309.GA3689@merkur.ravnborg.org>
References: <20120417155502.GE22687@tiehlicka.suse.cz> <20120420182907.GG32324@google.com> <20120420191418.GA3569@merkur.ravnborg.org> <CAE9FiQU-M0yW_rwysq56zrZzift=PxgwioMmx8bMcJ5o20m2TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQU-M0yW_rwysq56zrZzift=PxgwioMmx8bMcJ5o20m2TQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 12:30:54PM -0700, Yinghai Lu wrote:
> On Fri, Apr 20, 2012 at 12:14 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> >
> > I took a quick look at this.
> > __alloc_bootmem_node_high() is used in mm/sparse.c - but only
> > if SPARSEMEM_VMEMMAP is enabled.
> >
> > mips has this:
> >
> > config ARCH_SPARSEMEM_ENABLE
> >        bool
> >        select SPARSEMEM_STATIC
> >
> > So SPARSEMEM_VMEMMAP is not enabled.
> >
> > __alloc_bootmem_node_high() is used in mm/sparse-vmemmap.c which
> > also depends on CONFIG_SPARSEMEM_VMEMMAP.
> >
> >
> > So I really do not see the logic in __alloc_bootmem_node_high()
> > being used anymore and it can be replaced by __alloc_bootmem_node()
> 
> Yes, you are right. __alloc_bootmem_node_high could be removed.
> 
> BTW, x86 is still the only one that use NO_BOOTMEM.
> 
> Are you working on making sparc to use NO_BOOTMEM?

For now I am trying to convert sparc32 to
use memblock and NO_BOOTMEM in one step.

I have it almost finished - except that it does not work :-(
We have limitations in what area we can allocate very early,
and here I had to use the alloc_bootmem_low() variant.
I had preferred a variant that allowed me to allocate
bottom-up in this case.

For now I assume something is fishy in my code where I
hand over memory to the buddyallocator.
But before posting anything I need time to go through
my code and divide it up in smaller patches.

There is so far no changes to nobootmem / memblock code.

I will most likely convert sparc64 to NO_BOOTMEM next,
if it looks reasonable simple that is.
But first step is to get sparc32 working.

	Sam
