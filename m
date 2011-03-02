Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab1CBEfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 23:35:38 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50510 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab1CBEfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 23:35:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kouhP1J/xZdKzja3uPx9DYrrWxyRXL+zpXk7I+NoV3seUe7+9wHzx37Nti09Wl77ad
         7L6/zuyBDzpufaVZraETsOD7y/yFwp+hIYepeofgTB6GRFFBvfRtmUoAAsUDrcxo1kh4
         zj6aXilJuWE+kfIAJENh/XKpu3uAiPy9UPQ4E=
Subject: Re: [BUG] perf failed on multi-cpus system with multi-events
 specified
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Han Pingtian <phan@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110302035821.GA5186@hpt.nay.redhat.com>
References: <20110302035821.GA5186@hpt.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 05:35:30 +0100
Message-ID: <1299040530.2930.74.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 02 mars 2011 à 11:58 +0800, Han Pingtian a écrit :
> Hi,
> 
> On a Nehalem-EX system, which has 24 CPUs, perf commands with
> multi-events specified fail:
> 
> [root@intel-s3e36-01 perf]# ./perf record -e
> syscalls:sys_enter_sched_get_priority_min  -e kmem:mm_kernel_pagefault
> -e workqueue:workqueue_execution  -e writeback:writeback_pages_written
> -e kmem:mm_kernel_pagefault  -e writeback:writeback_bdi_unregister  -e
> syscalls:sys_exit_capset  -e syscalls:sys_enter_sched_get_priority_min
> -e writeback:writeback_exec  -e syscalls:sys_enter_vmsplice  -e
> syscalls:sys_exit_mprotect  -e block:block_rq_complete  -e
> syscalls:sys_enter_readlinkat  -e signal:signal_overflow_fail  -e
> syscalls:sys_exit_sendfile64  -e block:block_bio_backmerge  -e
> syscalls:sys_exit_unlink  -e syscalls:sys_exit_keyctl  -e
> jbd2:jbd2_submit_inode_data  -e syscalls:sys_enter_tgkill  -e
> syscalls:sys_exit_lremovexattr  -e syscalls:sys_exit_munmap  -e
> syscalls:sys_enter_mmap  -e syscalls:sys_exit_sched_getparam  -e
> syscalls:sys_exit_getpgid  -e syscalls:sys_exit_clock_getres  -e
> block:block_split  -e ext4:ext4_mballoc_discard  -e task-clock  -e
> syscalls:sys_enter_sendfile64  -e syscalls:sys_enter_ptrace  -e
> syscalls:sys_enter_nanosleep  -e syscalls:sys_exit_setdomainname  -e
> writeback:writeback_nowork  -e syscalls:sys_exit_mbind  -e
> ext4:ext4_da_write_begin  -e syscalls:sys_enter_recvfrom  -e
> syscalls:sys_enter_write  -e syscalls:sys_exit_getresgid  -e
> syscalls:sys_exit_fsync  -e syscalls:sys_enter_rt_sigprocmask  -e
> syscalls:sys_enter_getdents  -e syscalls:sys_exit_semtimedop -f ls
> 
>   Error: sys_perf_event_open() syscall returned with -1 (Too many open
> files).  /bin/dmesg may provide additional information.
> 
>   Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
> 
> trace-cmd: Too many open files
>   No memory to alloc tracepoints list
> [root@intel-s3e36-01 perf]# ./perf --version
> perf version 2.6.38.rc6.166.g493f33
> [root@intel-s3e36-01 perf]#
> 
> On another latop which has only two CPUs, there is no this problem.

perf needs nr_cpus * nr_events file descriptors

Try before :

ulimit -n 1000000



