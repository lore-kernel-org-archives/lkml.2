Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab1CYIao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 04:30:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:47278 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497Ab1CYIal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 04:30:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,242,1299484800"; 
   d="scan'208";a="671477286"
Subject: Re: [PATCH v2 -tip] perf probe: Add fastpath to do lookup by
 function name
From: Lin Ming <ming.m.lin@intel.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1301034825.2512.5.camel@hp6530s>
References: <1300981134-7333-1-git-send-email-ming.m.lin@intel.com>
	 <4D8B0A13.8000008@hitachi.com> <1300974448.2283.17.camel@localhost>
	 <1300975753.2283.20.camel@localhost> <4D8BEC71.1040404@hitachi.com>
	 <20110325025752.GB11195@ghostprotocols.net>
	 <1301034825.2512.5.camel@hp6530s>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 16:30:21 +0800
Message-ID: <1301041821.14111.53.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 14:33 +0800, Lin Ming wrote:
> 在 2011-03-25五的 10:57 +0800，Arnaldo Carvalho de Melo写道：
> > Em Fri, Mar 25, 2011 at 10:14:25AM +0900, Masami Hiramatsu escreveu:
> > > (2011/03/24 23:09), Lin Ming wrote:
> > > > v2 -> v1:
> > > > - Don't compare file names with cu_find_realpath(...), instead, compare them
> > > >   with the name returned by dwarf_decl_file(sp_die) 
> > > > 
> > > > The vmlinux file may have thousands of CUs.
> > > > We can lookup function name from .debug_pubnames section
> > > > to avoid the slow loop on CUs.
> > > > 
> > > > ./perf stat -r 10 -- ./perf probe -k /home/mlin/vmlinux \
> > > >         -s /home/mlin/linux-2.6 \
> > > > 	--line csum_partial_copy_to_user > tmp.log
> > > > 
> > > > before patch applied
> > > > =====================
> > > >         364.535892 task-clock-msecs         #      0.997 CPUs
> > > >                  0 context-switches         #      0.000 M/sec
> > > >                  0 CPU-migrations           #      0.000 M/sec
> > > >             29,993 page-faults              #      0.082 M/sec
> > > >        865,862,109 cycles                   #   2375.245 M/sec
> > > >      1,255,259,630 instructions             #      1.450 IPC
> > > >        252,400,884 branches                 #    692.390 M/sec
> > > >          3,429,376 branch-misses            #      1.359 %
> > > >          1,386,990 cache-references         #      3.805 M/sec
> > > >            687,188 cache-misses             #      1.885 M/sec
> > > > 
> > > >         0.365792170  seconds time elapsed
> > > > 
> > > > after patch applied
> > > > =====================
> > > >          89.896405 task-clock-msecs         #      0.991 CPUs
> > > >                  1 context-switches         #      0.000 M/sec
> > > >                  0 CPU-migrations           #      0.000 M/sec
> > > >             10,145 page-faults              #      0.113 M/sec
> > > >        214,553,875 cycles                   #   2386.679 M/sec
> > > >        226,915,559 instructions             #      1.058 IPC
> > > >         44,536,614 branches                 #    495.422 M/sec
> > > >            613,074 branch-misses            #      1.377 %
> > > >            860,787 cache-references         #      9.575 M/sec
> > > >            442,380 cache-misses             #      4.921 M/sec
> > > > 
> > > >         0.090716032  seconds time elapsed
> > > 
> > > Thanks! Looks very good :)
> > > 
> > > Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > 
> > Indeed, I'll try and process this one tomorrow,
> 
> Except find_line_range, I just realized that the same optimization maybe
> added for find_probes.

I have send out a v3 patch to add fastpath for find_probes.

Thanks,
Lin Ming

> 
> Thanks,
> Lin Ming
> 
> > 
> > Thanks a lot!
> > 
> > - Arnaldo
> 


