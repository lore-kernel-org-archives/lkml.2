Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab1H0Kth (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 06:49:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41908 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab1H0Ktd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 06:49:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 06/16] freezer: make exiting tasks properly unfreezable
Date: Sat, 27 Aug 2011 12:51:22 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Oleg Nesterov <oleg@redhat.com>, menage@google.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <201108262309.38652.rjw@sisk.pl> <20110827103534.GK2632@htj.dyndns.org>
In-Reply-To: <20110827103534.GK2632@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108271251.22719.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Saturday, August 27, 2011, Tejun Heo wrote:
> Hello, Rafael.
> 
> On Fri, Aug 26, 2011 at 11:09:38PM +0200, Rafael J. Wysocki wrote:
> > > One thing I'm curious about is how many drivers do we have left which
> > > depend on freezer as opposed to implementing proper quiescing
> > > mechanism using PM hooks?  Are there still a lot left?
> > 
> > There is a number of drivers that use freezable workqueues and that's
> > prefectly valid in my view.  Beyond that, may suspend/resume routines
> > depend on the freezer to some extent, because they assume that user
> > space won't talk to the driver while they are being run.
> > 
> > Do you mean any other kind of dependence?
> 
> I still feel a bit unsure about depending on freezer as escaping them
> unintentionally seems a bit too easy (e.g. schedule_work() for delayed
> processing) and as drivers need to implement responses to PM events
> anyway, I think implementing the support explicitly has lesser chance
> of causing obscure bugs which are difficult to reproduce.  Anyways,
> something to discuss some other day, I guess.

It seems that you are confusing two things - the interactions between the
drivers and kernel subsystems that can happen at any time, even during suspend
and resume, which can be taken care of with the help of various synchronization
mechanisms _inside_ of the kernel, and the interactions between the drivers
and user space resulting from user space using sysfs, ioctls, mmap,
proc, debugfs, sysv IPC, open/close, read/write and so on and so on.
The freezer's job is to take the second type of interactions out of the
picture for suspend/resume.

_Some_ drivers may want to use the freezer for their own purposes (e.g.
by using a freezable workqueue to avoid their own work items from being
executed in parallel with suspend/resume routines), but obviously they
have to know what they are doing.

Thanks,
Rafael
