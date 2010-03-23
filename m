Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab0CWOUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:20:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59349 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab0CWOUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:20:13 -0400
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from host side
From: Andi Kleen <andi@firstfloor.org>
References: <1268717232.2813.36.camel@localhost>
	<1268969929.2813.184.camel@localhost> <20100319082122.GE12576@elte.hu>
	<20100319172903.GI13108@8bytes.org> <20100321184300.GB25922@elte.hu>
	<20100322101451.GK13108@8bytes.org> <20100322105927.GB3483@elte.hu>
	<20100322114744.GC1940@8bytes.org>
	<ye88w9j2n2y.fsf@camel23.daimi.au.dk>
	<878w9jdu7m.fsf@basil.nowhere.org>
	<ye84ok72kxi.fsf@camel23.daimi.au.dk>
Date: Tue, 23 Mar 2010 15:20:11 +0100
In-Reply-To: <ye84ok72kxi.fsf@camel23.daimi.au.dk> (Soeren Sandmann's message of "23 Mar 2010 15:04:57 +0100")
Message-ID: <87vdcnce78.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren Sandmann <sandmann@daimi.au.dk> writes:
>
> Examples:
>
>         - What is going on inside QEMU? 

That's something the JIT interface could answer.

>         - Which client is the X server servicing?
>
>         - What parts of a python/shell/scheme/javascript program is
>           taking the most CPU time?

I suspect for those you rather need event based tracers of some sort,
similar to kernel trace points. Otherwise you would need own
separate stacks and other complications.

systemtap has some effort to use the dtrace instrumentation
that crops up in more and more user programs for this.  It wouldn't
surprise me if that was already in python and other programs
you're interested in.

I presume right now it only works if you apply the utrace monstrosity
though, but perhaps the new uprobes patches floating around 
will come to rescue.

There also was some effort to have a pure user space
daemon based approach for LTT, but I believe that currently
needs own trace points.

Again I fully expect someone to reinvent the wheel here
and afterwards complain about "community inefficiences" :-)

> I don't think the oprofile JIT interface solves any of these
> problems. (In fact, I don't see why the JIT problem is even hard. The
> JIT compiler can just generate a little ELF file with symbols in it,
> and the profiler can pick it up through the mmap events that you get
> through the perf interface).

That would require keeping those temporary ELF files for
potentially unlimited time around (profilers today look at the ELF
files at the final analysis phase, which might be weeks away)

Also that would be a lot of overhead for the JIT and most likely
be a larger scale rewrite for a given JIT code base.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
