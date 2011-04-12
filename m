Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab1DLS2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:28:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932364Ab1DLS2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:28:42 -0400
Date: Tue, 12 Apr 2011 20:28:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>,
        linux-kernel@vger.kernel.org
Subject: Re: Processes hang in an unkillable state
Message-ID: <20110412182809.GA1218@redhat.com>
References: <BANLkTin3gtiBk8nvsWEiJetKHq2+9HTi4w@mail.gmail.com> <BANLkTimJLcfsYAhV+3=-F14YZvX12-yXgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <BANLkTimJLcfsYAhV+3=-F14YZvX12-yXgA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12, Américo Wang wrote:
>
> 2011/4/12 Robert Święcki <robert@swiecki.net>:
> > Hi, while fuzzing Linux system calls (32bit fuzzer, 64bi linux
> > kernel), it happens after some time (10-20mins) that some processes
> > enter a state which makes them un-killable. They are either in R or D
> > state.
> >
> > # strace ps wwuax
> > ...
> > ...
> > open("/proc/450/cmdline", O_RDONLY)     = 6
> > read(6,  -             hangs....
> >
> > # kill -9 450
> > # kill -9 450 (no ESRCH)
> >
> > More data in the attachment - I'll keep it in the kdb session for
> > further examination.
>
> http://marc.info/?t0260440100004
>
> Hmm, it must be stuck at
>
> lib/rwsem.c
>
>         /* wait to be given the lock */
>         for (;;) {
>                 if (!waiter.task)
>                         break;
>                 schedule();
>                 set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>         }
>
> don't know why it still can't acquire the ->mmap_sem...
>
> Cc'ing Oleg...

I seem to understand...

Please wait a bit, I need to recheck.

Oleg.

