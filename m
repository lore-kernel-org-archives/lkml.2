Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0DGCci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 22:32:38 -0400
Received: from mga10.intel.com ([192.55.52.92]:5977 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751309Ab0DGCcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 22:32:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,376,1267430400"; 
   d="scan'208";a="555622693"
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       netdev <netdev@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, alex.shi@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1270591841.2091.170.camel@edumazet-laptop>
References: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>
	 <alpine.DEB.2.00.1003250942080.2670@router.home>
	 <1269570902.9614.92.camel@alexs-hp.sh.intel.com>
	 <1270114166.2078.107.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004011050340.16531@router.home>
	 <1270195589.2078.116.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004050853300.23149@router.home>
	 <i2z84144f021004051030k7ff5190cyc083aa12c552dfac@mail.gmail.com>
	 <4BBA8DF9.8010409@kernel.org>
	 <1270542497.2078.123.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004061033330.18750@router.home>
	 <alpine.DEB.2.00.1004061552500.19151@router.home>
	 <1270591841.2091.170.camel@edumazet-laptop>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 07 Apr 2010 10:34:28 +0800
Message-Id: <1270607668.2078.259.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-07 at 00:10 +0200, Eric Dumazet wrote:
> Le mardi 06 avril 2010 à 15:55 -0500, Christoph Lameter a écrit :
> > We cannot reproduce the issue here. Our tests here (dual quad dell) show a
> > performance increase in hackbench instead.
> > 
> > Linux 2.6.33.2 #2 SMP Mon Apr 5 11:30:56 CDT 2010 x86_64 GNU/Linux
> > ./hackbench 100 process 200000
> > Running with 100*40 (== 4000) tasks.
> > Time: 3102.142
> > ./hackbench 100 process 20000
> > Running with 100*40 (== 4000) tasks.
> > Time: 308.731
> > ./hackbench 100 process 20000
> > Running with 100*40 (== 4000) tasks.
> > Time: 311.591
> > ./hackbench 100 process 20000
> > Running with 100*40 (== 4000) tasks.
> > Time: 310.200
> > ./hackbench 10 process 20000
> > Running with 10*40 (== 400) tasks.
> > Time: 38.048
> > ./hackbench 10 process 20000
> > Running with 10*40 (== 400) tasks.
> > Time: 44.711
> > ./hackbench 10 process 20000
> > Running with 10*40 (== 400) tasks.
> > Time: 39.407
> > ./hackbench 1 process 20000
> > Running with 1*40 (== 40) tasks.
> > Time: 9.411
> > ./hackbench 1 process 20000
> > Running with 1*40 (== 40) tasks.
> > Time: 8.765
> > ./hackbench 1 process 20000
> > Running with 1*40 (== 40) tasks.
> > Time: 8.822
> > 
> > Linux 2.6.34-rc3 #1 SMP Tue Apr 6 13:30:34 CDT 2010 x86_64 GNU/Linux
> > ./hackbench 100 process 200000
> > Running with 100*40 (== 4000) tasks.
> > Time: 3003.578
> > ./hackbench 100 process 20000
> > Running with 100*40 (== 4000) tasks.
> > Time: 300.289
> > ./hackbench 100 process 20000
> > Running with 100*40 (== 4000) tasks.
> > Time: 301.462
> > ./hackbench 100 process 20000
> > Running with 100*40 (== 4000) tasks.
> > Time: 301.173
> > ./hackbench 10 process 20000
> > Running with 10*40 (== 400) tasks.
> > Time: 41.191
> > ./hackbench 10 process 20000
> > Running with 10*40 (== 400) tasks.
> > Time: 41.964
> > ./hackbench 10 process 20000
> > Running with 10*40 (== 400) tasks.
> > Time: 41.470
> > ./hackbench 1 process 20000
> > Running with 1*40 (== 40) tasks.
> > Time: 8.829
> > ./hackbench 1 process 20000
> > Running with 1*40 (== 40) tasks.
> > Time: 9.166
> > ./hackbench 1 process 20000
> > Running with 1*40 (== 40) tasks.
> > Time: 8.681
> > 
> > 
> 
> 
> Well, your config might be very different... and hackbench results can
> vary by 10% on same machine, same kernel.
> 
> This is not a reliable bench, because af_unix is not prepared to get
> such a lazy workload.
Thanks. I also found that. Normally, my script runs hackbench for 3 times and
gets an average value. To decrease the variation, I use 
'./hackbench 100 process 200000' to get a more stable result.


> 
> We really should warn people about this.
> 
> 
> 
> # hackbench 25 process 3000
> Running with 25*40 (== 1000) tasks.
> Time: 12.922
> # hackbench 25 process 3000
> Running with 25*40 (== 1000) tasks.
> Time: 12.696
> # hackbench 25 process 3000
> Running with 25*40 (== 1000) tasks.
> Time: 13.060
> # hackbench 25 process 3000
> Running with 25*40 (== 1000) tasks.
> Time: 14.108
> # hackbench 25 process 3000
> Running with 25*40 (== 1000) tasks.
> Time: 13.165
> # hackbench 25 process 3000
> Running with 25*40 (== 1000) tasks.
> Time: 13.310
> # hackbench 25 process 3000 
> Running with 25*40 (== 1000) tasks.
> Time: 12.530
> 
> 
> booting with slub_min_order=3 do change hackbench results for example ;)
By default, slub_min_order=3 on my Nehalem machines. I also tried different
larger slub_min_order and didn't find help.


> 
> All writers can compete on spinlock for a target UNIX socket, we spend _lot_ of time spinning.
> 
> If we _really_ want to speedup hackbench, we would have to change unix_state_lock()
> to use a non spinning locking primitive (aka lock_sock()), and slowdown normal path.
> 
> 
> # perf record -f hackbench 25 process 3000 
> Running with 25*40 (== 1000) tasks.
> Time: 13.330
> [ perf record: Woken up 289 times to write data ]
> [ perf record: Captured and wrote 54.312 MB perf.data (~2372928 samples) ]
> # perf report
> # Samples: 2370135
> #
> # Overhead    Command                 Shared Object  Symbol
> # ........  .........  ............................  ......
> #
>      9.68%  hackbench  [kernel]                      [k] do_raw_spin_lock
>      6.50%  hackbench  [kernel]                      [k] schedule
>      4.38%  hackbench  [kernel]                      [k] __kmalloc_track_caller
>      3.95%  hackbench  [kernel]                      [k] copy_to_user
>      3.86%  hackbench  [kernel]                      [k] __alloc_skb
>      3.77%  hackbench  [kernel]                      [k] unix_stream_recvmsg
>      3.12%  hackbench  [kernel]                      [k] sock_alloc_send_pskb
>      2.75%  hackbench  [vdso]                        [.] 0x000000ffffe425
>      2.28%  hackbench  [kernel]                      [k] sysenter_past_esp
>      2.03%  hackbench  [kernel]                      [k] __mutex_lock_common
>      2.00%  hackbench  [kernel]                      [k] kfree
>      2.00%  hackbench  [kernel]                      [k] delay_tsc
>      1.75%  hackbench  [kernel]                      [k] update_curr
>      1.70%  hackbench  [kernel]                      [k] kmem_cache_alloc
>      1.69%  hackbench  [kernel]                      [k] do_raw_spin_unlock
>      1.60%  hackbench  [kernel]                      [k] unix_stream_sendmsg
>      1.54%  hackbench  [kernel]                      [k] sched_clock_local
>      1.46%  hackbench  [kernel]                      [k] __slab_free
>      1.37%  hackbench  [kernel]                      [k] do_raw_read_lock
>      1.34%  hackbench  [kernel]                      [k] __switch_to
>      1.24%  hackbench  [kernel]                      [k] select_task_rq_fair
>      1.23%  hackbench  [kernel]                      [k] sock_wfree
>      1.21%  hackbench  [kernel]                      [k] _raw_spin_unlock_irqrestore
>      1.19%  hackbench  [kernel]                      [k] __mutex_unlock_slowpath
>      1.05%  hackbench  [kernel]                      [k] trace_hardirqs_off
>      0.99%  hackbench  [kernel]                      [k] __might_sleep
>      0.93%  hackbench  [kernel]                      [k] do_raw_read_unlock
>      0.93%  hackbench  [kernel]                      [k] _raw_spin_lock
>      0.91%  hackbench  [kernel]                      [k] try_to_wake_up
>      0.81%  hackbench  [kernel]                      [k] sched_clock
>      0.80%  hackbench  [kernel]                      [k] trace_hardirqs_on

I collected retired instruction, dtlb miss and LLC miss.
Below is data of LLC miss.

Kernel 2.6.33:
# Samples: 11639436896 LLC-load-misses
#
# Overhead          Command                                           Shared Object  Symbol
# ........  ...............  ......................................................  ......
#
    20.94%        hackbench  [kernel.kallsyms]                                       [k] copy_user_generic_string
    14.56%        hackbench  [kernel.kallsyms]                                       [k] unix_stream_recvmsg
    12.88%        hackbench  [kernel.kallsyms]                                       [k] kfree
     7.37%        hackbench  [kernel.kallsyms]                                       [k] kmem_cache_free
     7.18%        hackbench  [kernel.kallsyms]                                       [k] kmem_cache_alloc_node
     6.78%        hackbench  [kernel.kallsyms]                                       [k] kfree_skb
     6.27%        hackbench  [kernel.kallsyms]                                       [k] __kmalloc_node_track_caller
     2.73%        hackbench  [kernel.kallsyms]                                       [k] __slab_free
     2.21%        hackbench  [kernel.kallsyms]                                       [k] get_partial_node
     2.01%        hackbench  [kernel.kallsyms]                                       [k] _raw_spin_lock
     1.59%        hackbench  [kernel.kallsyms]                                       [k] schedule
     1.27%        hackbench  hackbench                                               [.] receiver
     0.99%        hackbench  libpthread-2.9.so                                       [.] __read
     0.87%        hackbench  [kernel.kallsyms]                                       [k] unix_stream_sendmsg




Kernel 2.6.34-rc3:
# Samples: 13079611308 LLC-load-misses
#
# Overhead          Command                                                         Shared Object  Symbol
# ........  ...............  ....................................................................  ......
#
    18.55%        hackbench  [kernel.kallsyms]                                                     [k] copy_user_generic_str
ing
    13.19%        hackbench  [kernel.kallsyms]                                                     [k] unix_stream_recvmsg
    11.62%        hackbench  [kernel.kallsyms]                                                     [k] kfree
     8.54%        hackbench  [kernel.kallsyms]                                                     [k] kmem_cache_free
     7.88%        hackbench  [kernel.kallsyms]                                                     [k] __kmalloc_node_track_
caller
     6.54%        hackbench  [kernel.kallsyms]                                                     [k] kmem_cache_alloc_node
     5.94%        hackbench  [kernel.kallsyms]                                                     [k] kfree_skb
     3.48%        hackbench  [kernel.kallsyms]                                                     [k] __slab_free
     2.15%        hackbench  [kernel.kallsyms]                                                     [k] _raw_spin_lock
     1.83%        hackbench  [kernel.kallsyms]                                                     [k] schedule
     1.82%        hackbench  [kernel.kallsyms]                                                     [k] get_partial_node
     1.59%        hackbench  hackbench                                                             [.] receiver
     1.37%        hackbench  libpthread-2.9.so                                                     [.] __read


