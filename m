Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1HZVHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 17:07:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41238 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab1HZVHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 17:07:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 06/16] freezer: make exiting tasks properly unfreezable
Date: Fri, 26 Aug 2011 23:09:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Oleg Nesterov <oleg@redhat.com>, menage@google.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <201108252301.41778.rjw@sisk.pl> <20110825215444.GT2803@mtj.dyndns.org>
In-Reply-To: <20110825215444.GT2803@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108262309.38652.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 25, 2011, Tejun Heo wrote:
> Hello,
> 
> On Thu, Aug 25, 2011 at 11:01:41PM +0200, Rafael J. Wysocki wrote:
> > > But still I can't understand why it is better to consider the exiting
> > > task as "frozen" from the very beginning, right after PTRACE_EVENT_EXIT.
> > > do_exit() does a lot of misc things, and this patch simply makes it
> > > "invisible" to the freezer. This looks "unsafe" even if this is fine
> > > for suspend/etc.
> > 
> > Suspend needs the freezer to ensure that processes (user space mostly)
> > won't interact with drivers in any way while devices are being suspended,
> > so if a process is in a state in which it won't talk to any driver
> > and make changes to filesystems any more, it's irrelevant from the
> > suspend's point of view.
> 
> Hmm... but freezer can't really achieve that.  There are other sources
> of activities.

Which have to be taken care of directly rather than by freezing.

> But anyways, yeah, I think Oleg is right here and we
> should be setting NOFREEZE on transition to EXIT_DEAD.
> 
> > > > Rafael, can you please enlighten us on the subject?
> > > 
> > > Please ;)
> > 
> > Is the above sufficient?
> 
> One thing I'm curious about is how many drivers do we have left which
> depend on freezer as opposed to implementing proper quiescing
> mechanism using PM hooks?  Are there still a lot left?

There is a number of drivers that use freezable workqueues and that's
prefectly valid in my view.  Beyond that, may suspend/resume routines
depend on the freezer to some extent, because they assume that user
space won't talk to the driver while they are being run.

Do you mean any other kind of dependence?

Thanks,
Rafael
