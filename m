Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab0HYKXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 06:23:04 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:14336
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753283Ab0HYKWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 06:22:44 -0400
X-SpamScore: 0
X-BigFish: VPS0(z3cfcs329eqzbb2cK1432N98dN179dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L7PE1P-02-5OR-02
X-M-MSG: 
Date: Wed, 25 Aug 2010 12:20:13 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100825102013.GE3198@erda.amd.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
 <20100823085339.GA26713@elte.hu>
 <20100824171504.GI26154@erda.amd.com>
 <20100824172806.GF5723@lenovo>
 <20100824184658.GB4879@redhat.com>
 <20100824185458.GG5723@lenovo>
 <20100824195240.GA5281@lenovo>
 <20100824202718.GC4879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100824202718.GC4879@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.08.10 16:27:18, Don Zickus wrote:
> On Tue, Aug 24, 2010 at 11:52:40PM +0400, Cyrill Gorcunov wrote:
> > > I use 2.6.34 atm. Letme try 2.6.36 (which might require some time to recompile).
> > > 
> > > 	-- Cyrill
> > 
> > Don, for me it fails with somehow unrelated page handling fault - in
> > reiserfs_evict_inode O_o Fails in __get_cpu_var I suspect might means
> > a problem either in per-cpu allocator itself or we screw pointer somehow.
> > Weird.
> 
> I just found out (with the help of the crash utility and Dave A.) that
> Robert's percpu struct nmi clashes with the exception entry point .nmi.
> I only see this problem in 2.6.36, so I am not sure what changed with
> regards to compiler flags to confuse variables with text segments.

I was testing the patches also with CONFIG_LOCKUP_DETECTOR=y without
crashes.

> 
> But renaming the percpu struct nmi to nmidon fixed the problem for me (I
> am open to other suggestions :-) ).

Also I was looking at the differences between .35 and tip/perf/urgent
and could not find a namespace collision.

Hmm...

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

