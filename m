Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab1H0BNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 21:13:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46816 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471Ab1H0BNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 21:13:06 -0400
Message-ID: <4E584492.5090406@zytor.com>
Date: Fri, 26 Aug 2011 18:12:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com> <CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com> <4E582EAA.1040108@zytor.com> <CA+55aFxdRMxWLh1B_8v29qFafM425uH7kbYRfqoPe3TpVwOx-w@mail.gmail.com> <CA+55aFyVmA_26LYaJH8dnFhwo7LWM6Ck7qFxCQvnROEHSuV_aA@mail.gmail.com>
In-Reply-To: <CA+55aFyVmA_26LYaJH8dnFhwo7LWM6Ck7qFxCQvnROEHSuV_aA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For reference, this is the current list (again, unaudited!) of unshared
system calls.  Only the ones with *x32* in the the entry point name have
any new code in the kernel at all.

	-hpa

#
# x32 system calls start at 512 to avoid cache impact for native 32 bit
#
512     x32     open                    compat_sys_open
513     x32     stat                    compat_sys_newstat
514     x32     fstat                   compat_sys_newfstat
515     x32     lstat                   compat_sys_newlstat
516     x32     rt_sigaction            sys32_rt_sigaction
517     x32     rt_sigprocmask          sys32_rt_sigprocmask
518     x32     rt_sigreturn            stub_x32_rt_sigreturn
519     x32     ioctl                   compat_sys_ioctl
520     x32     readv                   compat_sys_readv
521     x32     writev                  compat_sys_writev
522     x32     select                  compat_sys_select
523     x32     shmat                   compat_sys_x32_shmat
524     x32     shmctl                  compat_sys_shmctl
525     x32     nanosleep               compat_sys_nanosleep
526     x32     getitimer               compat_sys_getitimer
527     x32     setitimer               compat_sys_setitimer
528     x32     recvfrom                compat_sys_recvfrom
529     x32     sendmsg                 compat_sys_sendmsg
530     x32     recvmsg                 compat_sys_recvmsg
531     x32     setsockopt              compat_sys_setsockopt
532     x32     getsockopt              compat_sys_getsockopt
533     x32     execve                  stub_x32_execve
534     x32     wait4                   compat_sys_wait4
535     x32     semctl                  compat_sys_x32_semctl
536     x32     msgsnd                  compat_sys_x32_msgsnd
537     x32     msgrcv                  compat_sys_x32_msgrcv
538     x32     msgctl                  compat_sys_msgctl
539     x32     fcntl                   compat_sys_fcntl64
540     x32     getdents                compat_sys_getdents
541     x32     gettimeofday            compat_sys_gettimeofday
542     x32     getrlimit               compat_sys_getrlimit
543     x32     getrusage               compat_sys_getrusage
544     x32     sysinfo                 compat_sys_sysinfo
545     x32     times                   compat_sys_times
546     x32     rt_sigpending           sys32_rt_sigpending
547     x32     rt_sigtimedwait         compat_sys_rt_sigtimedwait
548     x32     rt_sigqueueinfo         sys32_rt_sigqueueinfo
549     x32     sigaltstack             stub_x32_sigaltstack
550     x32     utime                   compat_sys_utime
551     x32     ustat                   compat_sys_ustat
552     x32     statfs                  compat_sys_statfs
553     x32     fstatfs                 compat_sys_fstatfs
554     x32     sched_rr_get_interval   sys32_sched_rr_get_interval
555     x32     _sysctl                 compat_sys_sysctl
556     x32     adjtimex                compat_sys_adjtimex
557     x32     setrlimit               compat_sys_setrlimit
558     x32     settimeofday            compat_sys_settimeofday
559     x32     quotactl                sys32_quotactl
560     x32     nfsservctl              compat_sys_nfsservctl
561     x32     time                    compat_sys_time
562     x32     futex                   compat_sys_futex
563     x32     sched_setaffinity       compat_sys_sched_setaffinity
564     x32     sched_getaffinity       compat_sys_sched_getaffinity
565     x32     io_setup                compat_sys_io_setup
566     x32     io_getevents            compat_sys_io_getevents
567     x32     io_submit               compat_sys_io_submit
568     x32     getdents64              compat_sys_getdents64
569     x32     semtimedop              compat_sys_semtimedop
570     x32     timer_create            compat_sys_timer_create
571     x32     timer_settime           compat_sys_timer_settime
572     x32     timer_gettime           compat_sys_timer_gettime
573     x32     clock_settime           compat_sys_clock_settime
574     x32     clock_gettime           compat_sys_clock_gettime
575     x32     clock_getres            compat_sys_clock_getres
576     x32     clock_nanosleep         compat_sys_clock_nanosleep
577     x32     utimes                  compat_sys_utimes
578     x32     mq_open                 compat_sys_mq_open
579     x32     mq_timedsend            compat_sys_mq_timedsend
580     x32     mq_timedreceive         compat_sys_mq_timedreceive
581     x32     mq_notify               compat_sys_mq_notify
582     x32     mq_getsetattr           compat_sys_mq_getsetattr
583     x32     kexec_load              compat_sys_kexec_load
584     x32     waitid                  compat_sys_waitid
585     x32     openat                  compat_sys_openat
586     x32     futimesat               compat_sys_futimesat
587     x32     fstatat64               sys32_fstatat
588     x32     pselect6                compat_sys_pselect6
589     x32     ppoll                   compat_sys_ppoll
590     x32     set_robust_list         compat_sys_set_robust_list
591     x32     get_robust_list         compat_sys_get_robust_list
592     x32     vmsplice                compat_sys_vmsplice
593     x32     move_pages              compat_sys_move_pages
594     x32     utimensat               compat_sys_utimensat
595     x32     signalfd                compat_sys_signalfd
596     x32     timerfd_settime         compat_sys_timerfd_settime
597     x32     timerfd_gettime         compat_sys_timerfd_gettime
598     x32     signalfd4               compat_sys_signalfd4
599     x32     rt_tgsigqueueinfo       compat_sys_rt_tgsigqueueinfo
600     x32     stat64                  sys32_stat64
601     x32     fstat64                 sys32_fstat64
602     x32     lstat64                 sys32_lstat64
603     x32     statfs64                compat_sys_statfs64
604     x32     fstatfs64               compat_sys_fstatfs64
605     x32     recvmmsg                compat_sys_recvmmsg
606     x32     open_by_handle_at       compat_sys_open_by_handle_at
607     x32     clock_adjtime           compat_sys_clock_adjtime
608     x32     sendmmsg                compat_sys_sendmmsg
