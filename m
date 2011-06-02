Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab1FBQlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 12:41:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab1FBQlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 12:41:10 -0400
Date: Thu, 2 Jun 2011 18:39:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        indan@nul.nu, bdonlan@gmail.com, linux-kernel@vger.kernel.org,
        jan.kratochvil@redhat.com, akpm@linux-foundation.org
Subject: Re: thread leader death under strace (was Re: [PATCH 03/10]
	ptrace: implement PTRACE_SEIZE)
Message-ID: <20110602163909.GA18025@redhat.com>
References: <BANLkTin1q-r=b3ZVbT3vdJ59OEddrRWfsQ@mail.gmail.com> <20110602163654.GA17754@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602163654.GA17754@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02, Oleg Nesterov wrote:
>
> On 06/02, Denys Vlasenko wrote:
> >
> > The problem is that right now it seems that if tracer doesn't catch
> > EVENT_EXIT and detach tracee when it sees it, really weird things
> > happen.
>
> The test-case is wrong afaics...
>
> Perhaps this should be considered as a bug in glibc, I dunno.
>
> > thread1(void *unused)
> > {
> > //	usleep(100*1000);
> > //	VERBOSE("WINCH\n");
> > //	raise(SIGWINCH);
> >
> > 	usleep(100*1000);
> > 	VERBOSE("DYING\n");
> > 	raise(SIGUSR1);
>
> This doesn't send a signal. This does tgkill(tgid, 0, SIGUSR1) which
> fails correctly with -EINVAL.
>
> > static int
> > thread_leader(void *unused)
> > {
> > 	/* malloc gives sufficiently aligned buffer.
> > 	 * long buf[] does not! (on ia64).
> > 	 */
> > 	clone2(thread1, malloc(16 * 1024), 16 * 1024, 0
>
> Probably because of this clone2.
>
> Could you test with pthread_create? Or s/raise/tkill/ ?

Btw, did you use -lpthread?

Oleg.

