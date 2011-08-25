Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab1HYVyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 17:54:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63109 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab1HYVyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 17:54:49 -0400
Date: Thu, 25 Aug 2011 23:54:44 +0200
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@redhat.com>, menage@google.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 06/16] freezer: make exiting tasks properly unfreezable
Message-ID: <20110825215444.GT2803@mtj.dyndns.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
 <20110825155957.GJ2803@mtj.dyndns.org>
 <20110825165650.GA8006@redhat.com>
 <201108252301.41778.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108252301.41778.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 25, 2011 at 11:01:41PM +0200, Rafael J. Wysocki wrote:
> > But still I can't understand why it is better to consider the exiting
> > task as "frozen" from the very beginning, right after PTRACE_EVENT_EXIT.
> > do_exit() does a lot of misc things, and this patch simply makes it
> > "invisible" to the freezer. This looks "unsafe" even if this is fine
> > for suspend/etc.
> 
> Suspend needs the freezer to ensure that processes (user space mostly)
> won't interact with drivers in any way while devices are being suspended,
> so if a process is in a state in which it won't talk to any driver
> and make changes to filesystems any more, it's irrelevant from the
> suspend's point of view.

Hmm... but freezer can't really achieve that.  There are other sources
of activities.  But anyways, yeah, I think Oleg is right here and we
should be setting NOFREEZE on transition to EXIT_DEAD.

> > > Rafael, can you please enlighten us on the subject?
> > 
> > Please ;)
> 
> Is the above sufficient?

One thing I'm curious about is how many drivers do we have left which
depend on freezer as opposed to implementing proper quiescing
mechanism using PM hooks?  Are there still a lot left?

Thanks.

-- 
tejun
