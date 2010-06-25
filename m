Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab0FYOhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 10:37:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36970 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752557Ab0FYOhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 10:37:05 -0400
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
In-Reply-To: <1277464589.32034.276.camel@twins>
References: <20100624142804.431553874@chello.nl>
	 <1277464288.26786.3.camel@e102144-lin.cambridge.arm.com>
	 <1277464589.32034.276.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Jun 2010 15:36:44 +0100
Message-ID: <1277476604.24751.8.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2010 14:36:47.0855 (UTC) FILETIME=[D771DFF0:01CB1473]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, 2010-06-25 at 12:16 +0100, Peter Zijlstra wrote:
> I seem to have lost a refresh before sending the emails, please check:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-perf.git perf-pmu
> 
> I pushed out updated patches there.

Ok, I rebuilt my Kernel and perf tools from that tree and tested it on a
quad-core ARMv7 board. Per-task counters appear to work (software and
hardware) but pinned hardware counters always return 0:


root@will-lucid-nfs:~# perf stat -a -e cs -e cycles -e instructions -- ls
linux-2.6  tmp

 Performance counter stats for 'ls':

                 33  context-switches        
                  0  cycles                  
                  0  instructions             #      0.000 IPC  

        0.028572009  seconds time elapsed


It's odd if only ARM is affected in this way. Do pinned events still work
for other people?

Will

