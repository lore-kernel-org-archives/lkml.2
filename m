Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab1GCUBN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 16:01:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37724 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab1GCUBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 16:01:12 -0400
Date: Mon, 4 Jul 2011 00:01:06 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, rientjes@google.com, wilsons@start.ca,
        security@kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] proc: fix a race in do_io_accounting()
Message-ID: <20110703200106.GB9714@albatros>
References: <20110703103925.GA2283@albatros>
 <CA+55aFwfr-oAa-2L9O_rd9iZDyVr0b+gFQS=_R5PUxmhh3JEsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwfr-oAa-2L9O_rd9iZDyVr0b+gFQS=_R5PUxmhh3JEsg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 03, 2011 at 12:24 -0700, Linus Torvalds wrote:
> On Sun, Jul 3, 2011 at 3:39 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> >
> > The order of locking is similar to the one inside of
> > ptrace_attach(): first goes cred_guard_mutex, then lock_task_sighand().
> 
> Hmm. mm_for_maps() uses mutex_lock_killable(), as does lock_trace.

Killable/interruptable here makes sense.


> And neither proc_pid_wchan() nor the fd following ones
> (proc_pid_follow_link etc) use anything at all.
> 
> So I'm not sure. And do we really even care about the theoretical
> race? Even if we do hit the race window and happen to get it just as a
> process turns setuid, it would seem to be totally harmless (we're not
> going to see any of the sensitive IO anyway).

I consider this as a theoretical race too unless there is a crazy bug in
scheduler/timer.  But IMO it's better to just fully remove the risk
(even purely theoretical) given the lock is simple and it doesn't cost
much.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
