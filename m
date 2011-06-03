Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab1FCPbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:31:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028Ab1FCPbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:31:13 -0400
Date: Fri, 3 Jun 2011 17:29:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        indan@nul.nu, bdonlan@gmail.com, linux-kernel@vger.kernel.org,
        jan.kratochvil@redhat.com, akpm@linux-foundation.org
Subject: Re: thread leader death under strace (was Re: [PATCH 03/10]
	ptrace: implement PTRACE_SEIZE)
Message-ID: <20110603152937.GB23757@redhat.com>
References: <BANLkTin1q-r=b3ZVbT3vdJ59OEddrRWfsQ@mail.gmail.com> <20110602163654.GA17754@redhat.com> <20110602163909.GA18025@redhat.com> <201106030026.18523.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106030026.18523.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03, Denys Vlasenko wrote:
>
> On Thursday 02 June 2011 18:39, Oleg Nesterov wrote:
> > > > 	raise(SIGUSR1);
> > >
> > > This doesn't send a signal. This does tgkill(tgid, 0, SIGUSR1) which
> > > fails correctly with -EINVAL.
>
> Yes. After I fixed this, it works as expected. See attached.
> The output is:

Great.

> > > > thread_leader(void *unused)
> > > > {
> > > > 	/* malloc gives sufficiently aligned buffer.
> > > > 	 * long buf[] does not! (on ia64).
> > > > 	 */
> > > > 	clone2(thread1, malloc(16 * 1024), 16 * 1024, 0
> > >
> > > Probably because of this clone2.
>
> This seems to be not a problem (it is defined to clone()).

Doesn't matter.

Unlike pthread_create() which uses CLONE_SETTLS, this doesn't setup
the tls area, and I assume you used -lpthread. In this case it is clear
why raise() doesn't work, pt-raise.c thinks that THREAD_GETMEM(tid)
should always work.

Oleg.

