Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933754Ab1ERT14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:27:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933607Ab1ERT1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:27:54 -0400
Date: Wed, 18 May 2011 12:17:27 -0700
From: Greg KH <gregkh@suse.de>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        Eugene Teo <eugeneteo@gmail.com>
Subject: Re: [RFC] add mount options to sysfs
Message-ID: <20110518191727.GA26741@suse.de>
References: <20110518163142.GA3367@albatros>
 <20110518163951.GA24143@suse.de>
 <20110518170545.GA4435@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518170545.GA4435@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 09:05:45PM +0400, Vasiliy Kulikov wrote:
> On Wed, May 18, 2011 at 09:39 -0700, Greg KH wrote:
> > On Wed, May 18, 2011 at 08:31:44PM +0400, Vasiliy Kulikov wrote:
> > > Currently there is no good way to effectively globally restrict an
> > > access to sysfs files.  It's possible only to chmod the sysfs'
> > > root/directories to fully deny access to sysfs (sub-)tree to some users
> > > or chmod files after they are created.  The latter approach is racy,
> > > however.
> > 
> > Why do you want to do this?  What is in sysfs files that is not
> > gloabally ok to access?  That should be fixed first, if at all, instead
> > of wanting to modify the whole sysfs tree, right?
> 
> I don't hide the goal (I didn't find any other weird permissions, if
> you mean this).  It is primary about additional global controlable
> layer of defining permission:
> 
> 1) *IF* another sensitive file with weird permissions is found, mount
> option is IMO the best temporary workaround.

Maybe, but fixing the file would be the obvious solution.

> 2) Somebody might be worried about information leaks via world readable
> files - not strict bugs, but leaks in sense of local policy.  See numerous
> discussions about hiding kernel addresses - there is no unified opinion
> about it.  Some admins would be happy with denying access to almost all
> system information except some white list.

What file in sysfs "leaks" information like this?  Please let us know
and we will be glad to fix that.

> > > The patch introduces sysfs mount options parsing and adds 4 new options:
> > > uid, gid, mode and umask.  uid, gid, and umask are classical options,
> > > mode is a global restricting mode mask that defined the most relaxed
> > > possible file mode.  E.g. if mode=0750 then "chmod 0664" changes file's
> > > permissions to 0640.
> > 
> > What is going to break if you do this?  Have you tested it?  I'd be very
> > worried about this.
> 
> I've tested it on my laptop (I'm writing booted with this kernel).  By
> default nothing has changed (umask=0000, mode=0777).  Mounting sysfs
> with mode=0770 leads to the predictable state - no sysfs information is
> available to nonroot, e.g.  no ACPI battery state.  umask is tested with
> pluging a USB flash.

A usb storage device is hardly a huge consumer of sysfs files, sorry.
This would need a whole lot more testing before I would ever feel
confortable with it, even if I agreed that something like this should be
added (hint, I still don't.)

> mode has one advantage over umask.  It is temporary - "mount -o
> remount,mode=0777" restores the initial state.
> 
> I'd want to implement similar options for debugfs.

I wouldn't.

Again, lets fix the root problems here, if any, instead of adding
complexity and probably breaking systems by changing permissions without
anyone knowing about it.

thanks,

greg k-h
