Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab1GWHXt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 03:23:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:52577 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab1GWHXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 03:23:41 -0400
Date: Sat, 23 Jul 2011 09:23:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, dchinner@redhat.com, npiggin@kernel.dk,
        hch@lst.de, arnd@arndb.de
Subject: Re: [PATCH 3.0-rt1] ipc/mqueue: add a critical section to avoid a
 deadlock
In-Reply-To: <4E2A38A0.1090601@toshiba.co.jp>
Message-ID: <alpine.LFD.2.02.1107230923020.2702@ionos>
References: <4E2A38A0.1090601@toshiba.co.jp>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jul 2011, KOBAYASHI Yoshitake wrote:

> (Repost for v3.0-rt1 and changed the distination addreses)
> I have tested the following patch on v3.0-rt1 with PREEMPT_RT_FULL.
> In POSIX message queue, if a sender process uses SCHED_FIFO and
> has a higher priority than a receiver process, the sender will
> be stuck at ipc/mqueue.c:452
> 
>   452                 while (ewp->state == STATE_PENDING)
>   453                         cpu_relax();
> 
> Description of the problem
>  (receiver process)
>    1. receiver changes sender's state to STATE_PENDING (mqueue.c:846)
>    2. wake up sender process and "switch to sender" (mqueue.c:847)
>       Note: This context switch only happens in PREEMPT_RT_FULL kernel.
>  (sender process)
>    3. sender check the own state in above loop (mqueue.c:452-453)
>    *. receiver will never wake up and cannot change sender's state to
>       STATE_READY because sender has higher priority

Good catch! Queued for -rt2.

Thanks,

	tglx
