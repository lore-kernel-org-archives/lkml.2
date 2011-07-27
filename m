Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab1G0PiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 11:38:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:41061 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248Ab1G0PiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 11:38:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,276,1309762800"; 
   d="scan'208";a="32108985"
Date: Wed, 27 Jul 2011 08:38:08 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Bob Zhang <zhanglinbao@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hayfeng Lee <omycle@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Bob Zhang <2004.zhang@gmail.com>
Subject: Re: x86_64 virtual memory map
Message-ID: <20110727153808.GA16180@tassilo.jf.intel.com>
References: <5f6c52c61003241920i6b3eaaf7k946f67d1a6f9e384@mail.gmail.com>
 <m1r5n7ln0l.fsf@fess.ebiederm.org>
 <CAKdQVUZMC0eaeqev=tAbS2myHJOA1KJt4r8TVMz6=yQeDpUpZQ@mail.gmail.com>
 <20110726194956.GA4117@tassilo.jf.intel.com>
 <CAKdQVUZgSJi4z1BnwnKiOjX7L2dhOyMxA018sS-MtqOQixSKeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKdQVUZgSJi4z1BnwnKiOjX7L2dhOyMxA018sS-MtqOQixSKeg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 03:13:19PM +0800, Bob Zhang wrote:
> 2011/7/27 Andi Kleen <ak@linux.intel.com>:
> >> and in the end of mm.txt , it says :
> >> >>Current X86-64 implementations only support 40 bits of address space,
> >>  >> 27but we support up to 46 bits. This expands into MBZ space in the
> >> >>page tables.
> >> so this 40bit(1TB) is responding to virtual memory map(1TB) ?
> >
> > The 1TB limit was dropped a long time ago.
> > Your googling found an old file.
> 
> I am not googling this , I get this file from lxr . I get that file
> from kernel v3.0 again .
> http://lxr.linux.no/linux+v3.0/Documentation/x86/x86_64/mm.txt
> it still said 1TB limit, if this number is really obsolete , it seems
> that related people should update it to correct number.thanks.

Ah that virtual memory map just revers to a specific kernel data structure,
it's not a limit you need to be concerned about.

The max user mapping is 128TB, the direct mapping (physical limit)
64TB at the moment.


> 
> >
> >> 3,  if I installed 64TB physical memory (RAM) , but linux kernel only
> >
> > What system is that out of curiosity? Are you sure it's not
> > a cluster?
> This system is HP's latest Proliant machine , DL980G7 .
> I have verified with firmware guys , they have tested sles11sp1 on
> DL980G7 ,2TB ,4TB ,they tested successfully. not BIOS problem. it
> seems that customer's configuration may has some issues. we don't
> think this is linux kernel issue again. thanks for help.

I don't think 64TB are really supported by this machine.

Xeon E7-7xxx has a limit of 16TB physical address space.

The HP web site says it's capable of 4TB.

> 
> >
> >> support 1TB address space , what should I do next ?
> > There's no known 1TB limit currently.
> so as you said below ,it should be 64TB, but no one test with 64TB really.
> 
> > However at least for Intel Xeons there is no CPU which supports
> > more than 16TB physical address space.
> This information is very important, I will check System spec for details.
> which spec can get this information ? x86_64 ,which spec ?

It's probably somewhere in the datasheet, or when you boot the system
grep "address sizes" /proc/cpuinfo 
reports the limits reported by the CPU.


> 
> 
> 
> >
> > Are you sure you have your units correct?
> >
> hoho , I am not richer , I don't have 64TB installed, I just supposed that.
> in fact, my DL980G7 just have 2 TB installed , but linux kernel
> recognized only  992GB. as I said above , firmware guys said they have
> tested 4TB on DL980G7 with sles11sp1 , so we are investigating why our
> environment will happen this issue . wait for future reply.


As someone earlier suggested check the beginning of the kernel log
for the e820 map.  This tells how much memory the BIOS reported
to the OS.


> so I basicly understand what you mean , you mean intel Xeon just
> support 16TB , linux kernel should have no issue to support this 16TB
> ?

I don't know if especially 16TB has been tested. At least there's 
no theoretical limit that should prevent it.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
