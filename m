Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab1HJVyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 17:54:25 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:54827 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab1HJVyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 17:54:24 -0400
Date: Wed, 10 Aug 2011 23:44:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] make vfork killable/restartable/traceable
Message-ID: <20110810214444.GD9320@atrey.karlin.mff.cuni.cz>
References: <20110727163159.GA23785@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727163159.GA23785@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> CLONE_VFORK sleeps in TASK_INTERRUPTIBLE until the child exits/execs.
> This is obviously not good, it is sooo simple to create the task which
> doesn't react to SIGKILL/SIGSTOP.
> 
> Questions:
> 
> 	- do we really need this?
> 
> 	  I think we do. This really "looks like a bug" in any case,
> 	  even if nobody ever complained afaik.
> 
> 	- may be 1-3 is enough?
> 
> 	  may be... but personally I think SIGSTOP/ptrace should work
> 	  too.
> 
> 	- is it safe to exit/stop on !x86 machine???
> 
> 	  I do not know. May be this needs some #ifdef's around
> 	  wait_for_completion_interruptible(). I am not sure that,
> 	  say, arch_ptrace_stop() can't abuse the ->mm shared with
> 	  the child.
> 
> 	  OTOH. This can happen anyway, do_fork() does ptrace_event()
> 	  before wait_for_completion().
> 
> 	- and of course, while I think this is bugfix, this is user
> 	  visible change.
> 
> Please comment.

I believe we should fix it. I was always claiming "if it does not
react to SIGKILL, it is a kernel bug" and well, this just proved me
wrong...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
