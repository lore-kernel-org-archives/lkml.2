Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab1CBG2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 01:28:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab1CBG2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 01:28:10 -0500
Date: Wed, 2 Mar 2011 14:32:18 +0800
From: Han Pingtian <phan@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG] perf failed on multi-cpus system with multi-events
 specified
Message-ID: <20110302063218.GC5186@hpt.nay.redhat.com>
Mail-Followup-To: Eric Dumazet <eric.dumazet@gmail.com>,
	linux-kernel@vger.kernel.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>
References: <20110302035821.GA5186@hpt.nay.redhat.com>
 <1299040530.2930.74.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1299040530.2930.74.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 05:35:30AM +0100, Eric Dumazet wrote:
> Le mercredi 02 mars 2011 à 11:58 +0800, Han Pingtian a écrit :
> > Hi,
> > 
> > On a Nehalem-EX system, which has 24 CPUs, perf commands with
> > multi-events specified fail:
> > 
> > [root@intel-s3e36-01 perf]# ./perf record -e
> > syscalls:sys_enter_sched_get_priority_min  -e kmem:mm_kernel_pagefault
> > -e workqueue:workqueue_execution  -e writeback:writeback_pages_written
> > -e kmem:mm_kernel_pagefault  -e writeback:writeback_bdi_unregister  -e
> > syscalls:sys_exit_capset  -e syscalls:sys_enter_sched_get_priority_min
> > -e writeback:writeback_exec  -e syscalls:sys_enter_vmsplice  -e
> > syscalls:sys_exit_mprotect  -e block:block_rq_complete  -e
> > syscalls:sys_enter_readlinkat  -e signal:signal_overflow_fail  -e
> > syscalls:sys_exit_sendfile64  -e block:block_bio_backmerge  -e
> > syscalls:sys_exit_unlink  -e syscalls:sys_exit_keyctl  -e
> > jbd2:jbd2_submit_inode_data  -e syscalls:sys_enter_tgkill  -e
> > syscalls:sys_exit_lremovexattr  -e syscalls:sys_exit_munmap  -e
> > syscalls:sys_enter_mmap  -e syscalls:sys_exit_sched_getparam  -e
> > syscalls:sys_exit_getpgid  -e syscalls:sys_exit_clock_getres  -e
> > block:block_split  -e ext4:ext4_mballoc_discard  -e task-clock  -e
> > syscalls:sys_enter_sendfile64  -e syscalls:sys_enter_ptrace  -e
> > syscalls:sys_enter_nanosleep  -e syscalls:sys_exit_setdomainname  -e
> > writeback:writeback_nowork  -e syscalls:sys_exit_mbind  -e
> > ext4:ext4_da_write_begin  -e syscalls:sys_enter_recvfrom  -e
> > syscalls:sys_enter_write  -e syscalls:sys_exit_getresgid  -e
> > syscalls:sys_exit_fsync  -e syscalls:sys_enter_rt_sigprocmask  -e
> > syscalls:sys_enter_getdents  -e syscalls:sys_exit_semtimedop -f ls
> > 
> >   Error: sys_perf_event_open() syscall returned with -1 (Too many open
> > files).  /bin/dmesg may provide additional information.
> > 
> >   Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
> > 
> > trace-cmd: Too many open files
> >   No memory to alloc tracepoints list
> > [root@intel-s3e36-01 perf]# ./perf --version
> > perf version 2.6.38.rc6.166.g493f33
> > [root@intel-s3e36-01 perf]#
> > 
> > On another latop which has only two CPUs, there is no this problem.
> 
> perf needs nr_cpus * nr_events file descriptors
> 
> Try before :
> 
> ulimit -n 1000000
It works. Thanks!
> 
> 

-- 
Han Pingtian
Quality Engineer
hpt @ #kernel-qe
Red Hat, Inc
Freedom ... courage ... Commitment ... ACCOUNTABILITY
