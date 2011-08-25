Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab1HYVAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 17:00:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38754 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509Ab1HYU77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 16:59:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 06/16] freezer: make exiting tasks properly unfreezable
Date: Thu, 25 Aug 2011 23:01:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <20110825155957.GJ2803@mtj.dyndns.org> <20110825165650.GA8006@redhat.com>
In-Reply-To: <20110825165650.GA8006@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108252301.41778.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 25, 2011, Oleg Nesterov wrote:
> On 08/25, Tejun Heo wrote:
> >
> > Yeah, what 'freeze' should do is a bit vague on the edges, I think.
> > The freezer can't really halt the whole system operation including
> > IOs.  Tasks aren't the only source which can kick those off.  There
> > are other asynchronous sources,
> 
> Of course.
> 
> But still I can't understand why it is better to consider the exiting
> task as "frozen" from the very beginning, right after PTRACE_EVENT_EXIT.
> do_exit() does a lot of misc things, and this patch simply makes it
> "invisible" to the freezer. This looks "unsafe" even if this is fine
> for suspend/etc.

Suspend needs the freezer to ensure that processes (user space mostly)
won't interact with drivers in any way while devices are being suspended,
so if a process is in a state in which it won't talk to any driver
and make changes to filesystems any more, it's irrelevant from the
suspend's point of view.

> To me, try_to_freeze_tasks() should succed when all threads either
> sleep in refrigerator(), or ->state = TASK_DEAD (the final schedule()
> was called). Until then try_to_freeze_tasks() should retry.
> 
> But since we can't see the threads after exit_notify (in general),
> the current ->exit_state check looks reasonable.
> 
> But again, again, I won't argue.
> 
> > Rafael, can you please enlighten us on the subject?
> 
> Please ;)

Is the above sufficient?

Rafael
