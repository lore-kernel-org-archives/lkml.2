Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab2HHQ47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 12:56:59 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46303 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758508Ab2HHQ46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:56:58 -0400
Date: Wed, 8 Aug 2012 12:56:54 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Cyril Chemparathy <cyril@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 01/22] ARM: add mechanism for late code patching
In-Reply-To: <20120808160517.GO18957@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.02.1208081248340.5231@xanadu.home>
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-2-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1208040045360.5231@xanadu.home> <50219C45.7030601@ti.com> <alpine.LFD.2.02.1208080106500.5231@xanadu.home> <5022673A.7060407@ti.com>
 <alpine.LFD.2.02.1208080948210.5231@xanadu.home> <20120808160517.GO18957@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2012, Russell King - ARM Linux wrote:

> On Wed, Aug 08, 2012 at 09:55:12AM -0400, Nicolas Pitre wrote:
> > On Wed, 8 Aug 2012, Cyril Chemparathy wrote:
> > > Neat macro magic.  Are you thinking that we build this in as a self test in
> > > the code?
> > 
> > For such things, this is never a bad idea to have some test alongside 
> > with the main code, especially if this is extended to more cases in the 
> > future.  It is too easy to break it in subtle ways.
> > 
> > See arch/arm/kernel/kprobes-test*.c for a precedent.
> 
> Done correctly, it shouldn't be a problem, but I wouldn't say that
> arch/arm/kernel/kprobes-test*.c is done correctly.  It's seen quite
> a number of patching attempts since it was introduced for various
> problems, and I've seen quite a number of builds fail for various
> reasons in this file (none which I could be bothered to investigate.)
> 
> When the test code ends up causing more problems than the code it's
> testing, something is definitely wrong.

I think we shouldn't compare the complexity of test code for kprobes and 
test code for runtime patching code.  The former, while more difficult 
to keep compiling, has found loads of issues in the former kprobes code.  
So it certainly paid back many times its cost in maintenance.

My mention of it wasn't about the actual test code implementation, but 
rather about the fact that we do have test code in the tree which can be 
enabled with a config option.

As for build failures with that test code, I'd suggest you simply drop a 
note to Tixy who is normally very responsive.  I randomly enable it 
myself and didn't run into any issues yet.


Nicolas
