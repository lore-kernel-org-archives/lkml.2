Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab1HEPYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 11:24:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756815Ab1HEPYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 11:24:31 -0400
Date: Fri, 5 Aug 2011 11:24:12 -0400
From: Jason Baron <jbaron@redhat.com>
To: Richard Henderson <rth@redhat.com>, a.p.zijlstra@chello.nl
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFT][patch 17/18] sched: use jump labels to reduce overhead
 when bandwidth control is inactive
Message-ID: <20110805152411.GC2522@redhat.com>
References: <20110722003211.GA2807@redhat.com>
 <CAPM31R+UWijCCna5zYfn875h+KPmS4H0Lk8jW6+8JP-oDb72DA@mail.gmail.com>
 <20110722011747.GB2807@redhat.com>
 <CAPM31RKW+do-U8G8uL-y53BVWvr4oQbSf456A9u-SUV06tSfeg@mail.gmail.com>
 <20110727215816.GA2515@redhat.com>
 <1312533036.10852.34.camel@twins>
 <4E3C0813.5050303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3C0813.5050303@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 08:11:15AM -0700, Richard Henderson wrote:
> On 08/05/2011 01:30 AM, Peter Zijlstra wrote:
> > OK, so _WHY_ does that make a difference and will a next version of
> > gnu-binutils not mess that up?
> 
> The Why is micro-architectual, and I can't answer that.

In tracking this down, I eventually found that just having the
jump_label.o file compiled into the kernel, but not actually using the
static_branch(), or 'asm goto' anywhere, led to a performance hit.
Thus, the compiler or the 'asm goto' itself wasn't actually causing any
degradation. 

Since the jump_label.o file is only slow-path code, it can be moved away
from core or heavily called kernel routines. I suspect this is probably
an icache issue, but I can't say for sure.

Thanks,

-Jason

> 
> But ld will never re-order the files as given on the command-line.
> There are too many functions and tables that are constructed 
> piece-wise from input sections; re-ordering them would change
> the semantics of the program.
> 
> 
> r~
