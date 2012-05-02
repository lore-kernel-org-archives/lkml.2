Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab2EBWgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 18:36:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64898 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab2EBWgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 18:36:08 -0400
Date: Wed, 2 May 2012 15:36:03 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasikanth babu <sasikanth.v19@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debugfs: New debugfs interface for creation of files,
 directory and symlinks
Message-ID: <20120502223603.GA3103@kroah.com>
References: <1335963054-24750-1-git-send-email-sasikanth.v19@gmail.com>
 <20120502153100.GA2777@kroah.com>
 <CAOJFanXZEUfM4GQS62u4oR-KwywdLGOciOcgzmrM9zW+kOrXkg@mail.gmail.com>
 <20120502220417.GA2667@kroah.com>
 <20120502152003.d7b6aae9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502152003.d7b6aae9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 03:20:03PM -0700, Andrew Morton wrote:
> On Wed, 2 May 2012 15:04:17 -0700
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > On Thu, May 03, 2012 at 03:28:17AM +0530, Sasikanth babu wrote:
> > > On Wed, May 2, 2012 at 9:01 PM, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > > On Wed, May 02, 2012 at 06:20:54PM +0530, Sasikantha babu wrote:
> > > >> As we know the current debugfs file or directory or symlink creation
> > > >> doesn't return proper error codes to the caller on failure. Because
> > > >> of this caller and user could not able to find the exact reason of
> > > >> the failure.
> > > >
> > > > And what is the problem with this? __Either the file is created or not,
> > > > you really shouldn't care anymore than that. __It's not like you are
> > > > going to retry the creation, or are you?
> > > >
> > > > Who really cares if the file is failed to be created?
> > > 
> > >  In most of cases I had observed caller of debufs_create_file or
> > >  debufs_create_dir always returns -ENOMEM on failure, which is not true.
> > 
> > Where does that happen?  And why would the creation of a debugfs file
> > fail?
> 
> How's he supposed to know, when the kernel cannot return the correct
> diagnostic?
> 
> That's the whole reason we have errnos: to report on what went wrong,
> so operators can understand *why* it failed and so that programmers can
> diagnose and fix bugs.
> 
> There's nothing special about debugfs and there is no reason why it
> should deviate from well-established practice.
> 
> If well-written code checks the return value (as it should) and then
> propagates an error code back to its caller (as it should), the stupid
> debugfs interface forces that caller to invent an errno from thin air.
> And if that guessed errno is wrong, it is actively misleading!
> 
> > You can fixup the callers to make it uniform, the api is uniform in what
> > it returns today, right?
> 
> The API is stupid and wrong, actually.  There is no *advantage* to
> having done it this way - none at all.

Yes there is, it makes the caller logic trivial, which was the main goal
here in getting people to use it over creating new proc files all the
time for no good reason.

No one cares about the return value when you create a proc file, either
it succeeds or not, and you handle things from there, you never change
the name to try it again.

Same thing with debugfs, you only care if it works or not, and really,
you don't even care if it works, as the api lets you continue on if it
didn't just fine.

These are debugging files, with no set rules on what they contain.  Yes,
people have grown to get used to them over the years, but the namespace
in which they work has worked out for itself, and I have yet to ever
hear of any two people wanting to create the same file/directory
anywhere, and have anything fail.

Or am I missing some subsystem that is having problems like this with
debugfs?

thanks,

greg k-h
