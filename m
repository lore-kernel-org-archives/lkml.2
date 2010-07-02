Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab0GBM5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 08:57:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43756 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758356Ab0GBM5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 08:57:14 -0400
Subject: Re: [RFC][PATCH 00/11] perf pmu interface -v2
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <1277994970.1917.184.camel@laptop>
References: <20100624142804.431553874@chello.nl>
	 <1277464288.26786.3.camel@e102144-lin.cambridge.arm.com>
	 <1277464589.32034.276.camel@twins>
	 <1277476604.24751.8.camel@e102144-lin.cambridge.arm.com>
	 <1277477401.32034.670.camel@twins>  <1277994970.1917.184.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Jul 2010 13:55:38 +0100
Message-ID: <1278075338.3154.10.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jul 2010 12:55:42.0216 (UTC) FILETIME=[E0EF1080:01CB19E5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Thu, 2010-07-01 at 15:36 +0100, Peter Zijlstra wrote:
> On Fri, 2010-06-25 at 16:50 +0200, Peter Zijlstra wrote:
> 
> > Not exactly sure how I could have messed up the ARM architecture code to
> > make this happen though... will have a peek.
> 
> I did find a bug in there, not sure it could have been responsible for
> this but who knows...
> 
> Pushed out a new git tree with the below delta folded in.
> 
I had a look at this yesterday and discovered a bug in the ARM
backend code, which I've posted a patch for to ALKML:

http://lists.infradead.org/pipermail/linux-arm-kernel/2010-July/019461.html

Unfortunately, with this applied and your latest changes I still
get 0 from pinned hardware counters:

# perf stat -r 5 -e cycles -e instructions -e cs -e faults -e branches -a -- git status

Performance counter stats for 'git status' (5 runs):

                  0  cycles                     ( +-     nan% )
                  0  instructions             #      0.000 IPC     ( +-     nan% )
              88447  context-switches           ( +-  12.624% )
              13647  page-faults                ( +-   0.015% )
                  0  branches                   ( +-     nan% )

The changes you've made to arch/arm/kernel/perf_event.c
look sane. If I get some time I'll try and dig deeper.

Will

