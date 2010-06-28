Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab0F1OhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 10:37:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab0F1Og7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 10:36:59 -0400
Date: Mon, 28 Jun 2010 16:37:15 +0200
From: Jakub Jelinek <jakub@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ulrich Drepper <drepper@redhat.com>, Darren Hart <dvhltc@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@redhat.com>, Danny Feng <dfeng@redhat.com>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: Q: sys_futex() && timespec_valid()
Message-ID: <20100628143715.GJ25077@tyan-ft48-01.lab.bos.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <4C2506C3.2000301@us.ibm.com>
 <2054433814.959851277495348646.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
 <20100628135825.GA17681@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100628135825.GA17681@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 03:58:25PM +0200, Oleg Nesterov wrote:
> Honestly, it looks a bit strange to me that you blame the correct code,

Whether that is correct or not is what is being disputed.

> and at the same time you ignore the test-case which hangs because the
> kernel returns -EFAULT saying that this is the caller's problem.

The userspace code reads the abstime->tv_nsec value, so if it wouldn't
be valid address, the code would already segfault.  And that's fine, POSIX
certainly allows that, reporting EFAULT isn't required.  Well, it doesn't
read abstime->tv_sec in the assembly version, so if you try hard, you can
avoid the segfault, yet get EFAULT from futex syscall by putting abstime
8 bytes before start of some page with previous page not mmapped.

	Jakub
