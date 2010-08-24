Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab0HXU1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 16:27:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328Ab0HXU1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 16:27:39 -0400
Date: Tue, 24 Aug 2010 16:27:18 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100824202718.GC4879@redhat.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
 <20100823085339.GA26713@elte.hu>
 <20100824171504.GI26154@erda.amd.com>
 <20100824172806.GF5723@lenovo>
 <20100824184658.GB4879@redhat.com>
 <20100824185458.GG5723@lenovo>
 <20100824195240.GA5281@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100824195240.GA5281@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 11:52:40PM +0400, Cyrill Gorcunov wrote:
> > I use 2.6.34 atm. Letme try 2.6.36 (which might require some time to recompile).
> > 
> > 	-- Cyrill
> 
> Don, for me it fails with somehow unrelated page handling fault - in
> reiserfs_evict_inode O_o Fails in __get_cpu_var I suspect might means
> a problem either in per-cpu allocator itself or we screw pointer somehow.
> Weird.

I just found out (with the help of the crash utility and Dave A.) that
Robert's percpu struct nmi clashes with the exception entry point .nmi.
I only see this problem in 2.6.36, so I am not sure what changed with
regards to compiler flags to confuse variables with text segments.

But renaming the percpu struct nmi to nmidon fixed the problem for me (I
am open to other suggestions :-) ).

Regarding your reiserfs, what was the variable's name?

Cheers,
Don
