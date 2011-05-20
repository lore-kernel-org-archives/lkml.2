Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865Ab1ETNaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:30:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:49335 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933693Ab1ETNaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:30:20 -0400
Date: Fri, 20 May 2011 06:30:44 -0700
From: Greg KH <gregkh@suse.de>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        Eugene Teo <eugeneteo@gmail.com>
Subject: Re: [RFC] add mount options to sysfs
Message-ID: <20110520133044.GC10225@suse.de>
References: <20110518163142.GA3367@albatros>
 <20110518163951.GA24143@suse.de>
 <20110518170545.GA4435@albatros>
 <20110518191727.GA26741@suse.de>
 <20110519062622.GA4418@albatros>
 <20110519171227.GB22019@suse.de>
 <20110520095920.GA4489@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520095920.GA4489@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 01:59:20PM +0400, Vasiliy Kulikov wrote:
> On Thu, May 19, 2011 at 10:12 -0700, Greg KH wrote:
> > On Thu, May 19, 2011 at 10:26:23AM +0400, Vasiliy Kulikov wrote:
> > > On Wed, May 18, 2011 at 12:17 -0700, Greg KH wrote:
> > > > Maybe, but fixing the file would be the obvious solution.
> > > 
> > > I mean for a sysadmin, not for a developer.
> > 
> > And I mean for the developer.
> > 
> > We have checks in place now to prevent this type of thing from happening
> > again in the future.  If it does, and it might, we will fix it, it's
> > that simple.
> 
> Simple indeed.  But not as fast as simple:
> 
> https://lkml.org/lkml/2011/2/4/74
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=49d50fb1c28738ef6bad0c2b87d5355a1653fed5
> 
> More than 40 days from the report to the actual commit.  Sometimes it
> needs some workaround.

That's sad, but it is for a very rare device, right?

You can always pester us to get those changes in sooner as well.

> > > What do you mean by "breaking system"?  Root is able to chmod
> > > and chown sysfs files already, he may do "chmod -R" or similar.
> > > I suggest sane, race free way to globally restrict permissions *IF* root
> > > wants it.
> > 
> > If root wants it, they can do this today with a simple 1 line bash
> > command, so I don't see the issue.
> 
> The issue is a race condition between the file creation and chmod'ing.
> 
> > > Here https://lkml.org/lkml/2011/2/25/300 you, not aware of usefull
> > > applications of world-writable debugfs file, agreeded to statically
> > > restrict permissions of all files.  I suggest more flexible and
> > > configurable in runtime solution.  It doesn't break anything - default
> > > behaviour doesn't differ from current one.  What has changed in your
> > > mind since 2/25?
> > 
> > That's debugfs, not sysfs, which we are talking about here, right?
> 
> Correct.  So, if I understood you, you are OK with adding mount options
> for debugfs, but not sysfs, right?  What is the difference between them
> in sense of permissions?

debugfs is "there are no rules", so changing the permissions on it
shouldn't break anything as no userspace tools "should" rely on it.  Now
that really isn't true (see the perf stuff), but overall it is, so I
don't worry about changing things there as much as sysfs, which has
hundreds of tools relying on it.

thanks,

greg k-h
