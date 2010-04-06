Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab0DFWKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 18:10:53 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63061 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab0DFWKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 18:10:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NFTgu39MSf29kCGyX+4Qyt6h82i4YCEsZ6+rj458YWqvk6mXkRAp2IYDxUfJbEz0PV
         c2bG9ghOSP3+ehuI2ejvpTjEsKpKTfRUSCg19KWc4zMm55UYo6ANi+tEM2L9lkJlFbne
         7YUQXPJaXszemHGXGi/AduLOg8v1XF+icJGSQ=
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>,
       netdev <netdev@vger.kernel.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, Tejun Heo <tj@kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, alex.shi@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1004061552500.19151@router.home>
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
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 00:10:41 +0200
Message-ID: <1270591841.2091.170.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 06 avril 2010 à 15:55 -0500, Christoph Lameter a écrit :
> We cannot reproduce the issue here. Our tests here (dual quad dell) show a
> performance increase in hackbench instead.
> 
> Linux 2.6.33.2 #2 SMP Mon Apr 5 11:30:56 CDT 2010 x86_64 GNU/Linux
> ./hackbench 100 process 200000
> Running with 100*40 (== 4000) tasks.
> Time: 3102.142
> ./hackbench 100 process 20000
> Running with 100*40 (== 4000) tasks.
> Time: 308.731
> ./hackbench 100 process 20000
> Running with 100*40 (== 4000) tasks.
> Time: 311.591
> ./hackbench 100 process 20000
> Running with 100*40 (== 4000) tasks.
> Time: 310.200
> ./hackbench 10 process 20000
> Running with 10*40 (== 400) tasks.
> Time: 38.048
> ./hackbench 10 process 20000
> Running with 10*40 (== 400) tasks.
> Time: 44.711
> ./hackbench 10 process 20000
> Running with 10*40 (== 400) tasks.
> Time: 39.407
> ./hackbench 1 process 20000
> Running with 1*40 (== 40) tasks.
> Time: 9.411
> ./hackbench 1 process 20000
> Running with 1*40 (== 40) tasks.
> Time: 8.765
> ./hackbench 1 process 20000
> Running with 1*40 (== 40) tasks.
> Time: 8.822
> 
> Linux 2.6.34-rc3 #1 SMP Tue Apr 6 13:30:34 CDT 2010 x86_64 GNU/Linux
> ./hackbench 100 process 200000
> Running with 100*40 (== 4000) tasks.
> Time: 3003.578
> ./hackbench 100 process 20000
> Running with 100*40 (== 4000) tasks.
> Time: 300.289
> ./hackbench 100 process 20000
> Running with 100*40 (== 4000) tasks.
> Time: 301.462
> ./hackbench 100 process 20000
> Running with 100*40 (== 4000) tasks.
> Time: 301.173
> ./hackbench 10 process 20000
> Running with 10*40 (== 400) tasks.
> Time: 41.191
> ./hackbench 10 process 20000
> Running with 10*40 (== 400) tasks.
> Time: 41.964
> ./hackbench 10 process 20000
> Running with 10*40 (== 400) tasks.
> Time: 41.470
> ./hackbench 1 process 20000
> Running with 1*40 (== 40) tasks.
> Time: 8.829
> ./hackbench 1 process 20000
> Running with 1*40 (== 40) tasks.
> Time: 9.166
> ./hackbench 1 process 20000
> Running with 1*40 (== 40) tasks.
> Time: 8.681
> 
> 


Well, your config might be very different... and hackbench results can
vary by 10% on same machine, same kernel.

This is not a reliable bench, because af_unix is not prepared to get
such a lazy workload.

We really should warn people about this.



# hackbench 25 process 3000
Running with 25*40 (== 1000) tasks.
Time: 12.922
# hackbench 25 process 3000
Running with 25*40 (== 1000) tasks.
Time: 12.696
# hackbench 25 process 3000
Running with 25*40 (== 1000) tasks.
Time: 13.060
# hackbench 25 process 3000
Running with 25*40 (== 1000) tasks.
Time: 14.108
# hackbench 25 process 3000
Running with 25*40 (== 1000) tasks.
Time: 13.165
# hackbench 25 process 3000
Running with 25*40 (== 1000) tasks.
Time: 13.310
# hackbench 25 process 3000 
Running with 25*40 (== 1000) tasks.
Time: 12.530


booting with slub_min_order=3 do change hackbench results for example ;)

All writers can compete on spinlock for a target UNIX socket, we spend _lot_ of time spinning.

If we _really_ want to speedup hackbench, we would have to change unix_state_lock()
to use a non spinning locking primitive (aka lock_sock()), and slowdown normal path.


# perf record -f hackbench 25 process 3000 
Running with 25*40 (== 1000) tasks.
Time: 13.330
[ perf record: Woken up 289 times to write data ]
[ perf record: Captured and wrote 54.312 MB perf.data (~2372928 samples) ]
# perf report
# Samples: 2370135
#
# Overhead    Command                 Shared Object  Symbol
# ........  .........  ............................  ......
#
     9.68%  hackbench  [kernel]                      [k] do_raw_spin_lock
     6.50%  hackbench  [kernel]                      [k] schedule
     4.38%  hackbench  [kernel]                      [k] __kmalloc_track_caller
     3.95%  hackbench  [kernel]                      [k] copy_to_user
     3.86%  hackbench  [kernel]                      [k] __alloc_skb
     3.77%  hackbench  [kernel]                      [k] unix_stream_recvmsg
     3.12%  hackbench  [kernel]                      [k] sock_alloc_send_pskb
     2.75%  hackbench  [vdso]                        [.] 0x000000ffffe425
     2.28%  hackbench  [kernel]                      [k] sysenter_past_esp
     2.03%  hackbench  [kernel]                      [k] __mutex_lock_common
     2.00%  hackbench  [kernel]                      [k] kfree
     2.00%  hackbench  [kernel]                      [k] delay_tsc
     1.75%  hackbench  [kernel]                      [k] update_curr
     1.70%  hackbench  [kernel]                      [k] kmem_cache_alloc
     1.69%  hackbench  [kernel]                      [k] do_raw_spin_unlock
     1.60%  hackbench  [kernel]                      [k] unix_stream_sendmsg
     1.54%  hackbench  [kernel]                      [k] sched_clock_local
     1.46%  hackbench  [kernel]                      [k] __slab_free
     1.37%  hackbench  [kernel]                      [k] do_raw_read_lock
     1.34%  hackbench  [kernel]                      [k] __switch_to
     1.24%  hackbench  [kernel]                      [k] select_task_rq_fair
     1.23%  hackbench  [kernel]                      [k] sock_wfree
     1.21%  hackbench  [kernel]                      [k] _raw_spin_unlock_irqrestore
     1.19%  hackbench  [kernel]                      [k] __mutex_unlock_slowpath
     1.05%  hackbench  [kernel]                      [k] trace_hardirqs_off
     0.99%  hackbench  [kernel]                      [k] __might_sleep
     0.93%  hackbench  [kernel]                      [k] do_raw_read_unlock
     0.93%  hackbench  [kernel]                      [k] _raw_spin_lock
     0.91%  hackbench  [kernel]                      [k] try_to_wake_up
     0.81%  hackbench  [kernel]                      [k] sched_clock
     0.80%  hackbench  [kernel]                      [k] trace_hardirqs_on


