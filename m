Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab0FYOue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 10:50:34 -0400
Received: from [18.85.46.34] ([18.85.46.34]:57110 "EHLO bombadil.infradead.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755183Ab0FYOuc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 10:50:32 -0400
Subject: Re: [RFC][PATCH 00/11] perf pmu interface -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <1277476604.24751.8.camel@e102144-lin.cambridge.arm.com>
References: <20100624142804.431553874@chello.nl>
	 <1277464288.26786.3.camel@e102144-lin.cambridge.arm.com>
	 <1277464589.32034.276.camel@twins>
	 <1277476604.24751.8.camel@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 25 Jun 2010 16:50:01 +0200
Message-ID: <1277477401.32034.670.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-25 at 15:36 +0100, Will Deacon wrote:
> Hello,
> 
> On Fri, 2010-06-25 at 12:16 +0100, Peter Zijlstra wrote:
> > I seem to have lost a refresh before sending the emails, please check:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-perf.git perf-pmu
> > 
> > I pushed out updated patches there.
> 
> Ok, I rebuilt my Kernel and perf tools from that tree and tested it on a
> quad-core ARMv7 board. 

Ooh, neat toy ;-)

> Per-task counters appear to work (software and
> hardware) but pinned hardware counters always return 0:
> 
> 
> root@will-lucid-nfs:~# perf stat -a -e cs -e cycles -e instructions -- ls
> linux-2.6  tmp
> 
>  Performance counter stats for 'ls':
> 
>                  33  context-switches        
>                   0  cycles                  
>                   0  instructions             #      0.000 IPC  
> 
>         0.028572009  seconds time elapsed
> 
> 
> It's odd if only ARM is affected in this way. Do pinned events still work
> for other people?

/me goes build that exact tree on his x86_64.. and gets:

# perf stat -a -e cs -e cycles -e instructions -- ls > /dev/null

 Performance counter stats for 'ls':

             51  context-switches        
       24963513  cycles                  
        9225808  instructions             #      0.370 IPC  

    0.002389051  seconds time elapsed


Not exactly sure how I could have messed up the ARM architecture code to
make this happen though... will have a peek.
