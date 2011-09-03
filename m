Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751098Ab1ICECO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 00:02:14 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:52274 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab1ICECL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 00:02:11 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyBtp-iyexHy4ccTy-qW7KqCccFfSD5HzMD_9BaXT-wjg@mail.gmail.com>
References: <4E582577.2060805@zytor.com>
	<201108301409.27527.arnd@arndb.de>
	<4E5D1153.5030908@zytor.com>
	<201108311814.54906.arnd@arndb.de>
	<CA+55aFxfmwfB7jbbrXxa=K7VBYPfAvmu3XOkGrLbB1UFjX1+Ew@mail.gmail.com>
	<CAMe9rOpGxNWD=gdvyVpi7V7BrwwWrpLTWdkmTjPqJ1+SUvhA0A@mail.gmail.com>
	<CAMe9rOrPhCC97KV+7AO-z66XJ9R0gidTmRSLZdAOCYjGkJEdFQ@mail.gmail.com>
	<CA+55aFyBtp-iyexHy4ccTy-qW7KqCccFfSD5HzMD_9BaXT-wjg@mail.gmail.com>
Date: Fri, 2 Sep 2011 21:02:10 -0700
Message-ID: <CAMe9rOq_iXX0zcdVcCJvb=he3p4QmYKKOBB_Vf7WAz+ARz3KiA@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 2, 2011 at 8:04 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Sep 2, 2011 at 7:56 PM, H.J. Lu <hjl.tools@gmail.com> wrote:
>>
>> We need to make decision on some system calls which take a pointer
>> to structure with long.  For example, msg calls take a pointer to
>>
>>          struct msgbuf {
>>               long mtype;       /* message type, must be > 0 */
>>               char mtext[1];    /* message data */
>>           };
>>
>> We have 3 choices:
>>
>> 1. Use long long for x32 and use 64bit msg system calls.
>
> I think this sounds like the best option. As many plain 64-bit system
> calls as humanly possible.
>

I defined __SNATIVE_LONG_TYPE and  __UNATIVE_LONG_TYPE
in x32 header, which are native signed and unsigned long types. I
used them in

bits/ipc.h:    __UNATIVE_LONG_TYPE __unused1;
bits/ipc.h:    __UNATIVE_LONG_TYPE __unused2;
bits/mqueue.h:  __SNATIVE_LONG_TYPE mq_flags;		/* Message queue flags.  */
bits/mqueue.h:  __SNATIVE_LONG_TYPE mq_maxmsg;	/* Maximum number of
messages.  */
bits/mqueue.h:  __SNATIVE_LONG_TYPE mq_msgsize;	/* Maximum message size.  */
bits/mqueue.h:  __SNATIVE_LONG_TYPE mq_curmsgs;	/* Number of messages
currently queued.  */
bits/mqueue.h:  __SNATIVE_LONG_TYPE __pad[4];
bits/msq.h:typedef __UNATIVE_LONG_TYPE msgqnum_t;
bits/msq.h:typedef __UNATIVE_LONG_TYPE msglen_t;
bits/msq.h:  __UNATIVE_LONG_TYPE __msg_cbytes; /* current number of
bytes on queue */
bits/msq.h:  __UNATIVE_LONG_TYPE __unused4;
bits/msq.h:  __UNATIVE_LONG_TYPE __unused5;
bits/sem.h:  __UNATIVE_LONG_TYPE sem_nsems;	/* number of semaphores in set */
bits/sem.h:  __UNATIVE_LONG_TYPE __unused3;
bits/sem.h:  __UNATIVE_LONG_TYPE __unused4;
bits/shm.h:typedef __UNATIVE_LONG_TYPE shmatt_t;
bits/shm.h:    __UNATIVE_LONG_TYPE __unused4;
bits/shm.h:    __UNATIVE_LONG_TYPE __unused5;
bits/shm.h:    __UNATIVE_LONG_TYPE shmmax;
bits/shm.h:    __UNATIVE_LONG_TYPE shmmin;
bits/shm.h:    __UNATIVE_LONG_TYPE shmmni;
bits/shm.h:    __UNATIVE_LONG_TYPE shmseg;
bits/shm.h:    __UNATIVE_LONG_TYPE shmall;
bits/shm.h:    __UNATIVE_LONG_TYPE __unused1;
bits/shm.h:    __UNATIVE_LONG_TYPE __unused2;
bits/shm.h:    __UNATIVE_LONG_TYPE __unused3;
bits/shm.h:    __UNATIVE_LONG_TYPE __unused4;
bits/shm.h:    __UNATIVE_LONG_TYPE shm_tot;	/* total allocated shm */
bits/shm.h:    __UNATIVE_LONG_TYPE shm_rss;	/* total resident shm */
bits/shm.h:    __UNATIVE_LONG_TYPE shm_swp;	/* total swapped shm */
bits/shm.h:    __UNATIVE_LONG_TYPE swap_attempts;
bits/shm.h:    __UNATIVE_LONG_TYPE swap_successes;
bits/statfs.h:    __SNATIVE_LONG_TYPE f_type;
bits/statfs.h:    __SNATIVE_LONG_TYPE f_bsize;
bits/statfs.h:    __SNATIVE_LONG_TYPE f_namelen;
bits/statfs.h:    __SNATIVE_LONG_TYPE f_frsize;
bits/statfs.h:    __SNATIVE_LONG_TYPE f_flags;
bits/statfs.h:    __SNATIVE_LONG_TYPE f_spare[4];
bits/statfs.h:    __SNATIVE_LONG_TYPE f_type;
bits/statfs.h:    __SNATIVE_LONG_TYPE f_bsize;
bits/statfs.h:    __SNATIVE_LONG_TYPE f_namelen;
bits/statfs.h:    __SNATIVE_LONG_TYPE f_frsize;
bits/statfs.h:    __SNATIVE_LONG_TYPE f_flags;
bits/statfs.h:    __SNATIVE_LONG_TYPE f_spare[4];
bits/stat.h:    __UNATIVE_LONG_TYPE st_atimensec;	/* Nscecs of last access.  */
bits/stat.h:    __UNATIVE_LONG_TYPE st_mtimensec;	/* Nsecs of last
modification.  */
bits/stat.h:    __UNATIVE_LONG_TYPE st_ctimensec;	/* Nsecs of last
status change.  */
bits/stat.h:    __UNATIVE_LONG_TYPE st_atimensec;	/* Nscecs of last access.  */
bits/stat.h:    __UNATIVE_LONG_TYPE st_mtimensec;	/* Nsecs of last
modification.  */
bits/stat.h:    __UNATIVE_LONG_TYPE st_ctimensec;	/* Nsecs of last
status change.  */
bits/timex.h:  __SNATIVE_LONG_TYPE offset;/* time offset (usec) */
bits/timex.h:  __SNATIVE_LONG_TYPE freq;/* frequency offset (scaled ppm) */
bits/timex.h:  __SNATIVE_LONG_TYPE maxerror;/* maximum error (usec) */
bits/timex.h:  __SNATIVE_LONG_TYPE esterror;/* estimated error (usec) */
bits/timex.h:  __SNATIVE_LONG_TYPE constant;/* pll time constant */
bits/timex.h:  __SNATIVE_LONG_TYPE precision;/* clock precision (usec)
(read only) */
bits/timex.h:  __SNATIVE_LONG_TYPE tolerance;/* clock frequency
tolerance (ppm) (read only) */
bits/timex.h:  __SNATIVE_LONG_TYPE tick;/* (modified) usecs between
clock ticks */
bits/timex.h:  __SNATIVE_LONG_TYPE ppsfreq;/* pps frequency (scaled ppm) (ro) */
bits/timex.h:  __SNATIVE_LONG_TYPE jitter;/* pps jitter (us) (ro) */
bits/timex.h:  __SNATIVE_LONG_TYPE stabil;/* pps stability (scaled ppm) (ro) */
bits/timex.h:  __SNATIVE_LONG_TYPE jitcnt;/* jitter limit exceeded (ro) */
bits/timex.h:  __SNATIVE_LONG_TYPE calcnt;/* calibration intervals (ro) */
bits/timex.h:  __SNATIVE_LONG_TYPE errcnt;/* calibration errors (ro) */
bits/timex.h:  __SNATIVE_LONG_TYPE stbcnt;/* stability limit exceeded (ro) */
sys/msg.h:    __SNATIVE_LONG_TYPE mtype;	/* type of received/sent message */

and

/* POSIX.1b structure for a time value.  This is like a `struct timeval' but
   has nanoseconds instead of microseconds.  */
struct timespec
  {
    __time_t tv_sec;            /* Seconds.  */
    __SNATIVE_LONG_TYPE tv_nsec;/* Nanoseconds.  */
  };

so that I can use 64bit system calls directly.


-- 
H.J.
