Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab2EBWUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 18:20:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab2EBWUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 18:20:05 -0400
Date: Wed, 2 May 2012 15:20:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasikanth babu <sasikanth.v19@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debugfs: New debugfs interface for creation of files,
 directory and symlinks
Message-Id: <20120502152003.d7b6aae9.akpm@linux-foundation.org>
In-Reply-To: <20120502220417.GA2667@kroah.com>
References: <1335963054-24750-1-git-send-email-sasikanth.v19@gmail.com>
	<20120502153100.GA2777@kroah.com>
	<CAOJFanXZEUfM4GQS62u4oR-KwywdLGOciOcgzmrM9zW+kOrXkg@mail.gmail.com>
	<20120502220417.GA2667@kroah.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2012 15:04:17 -0700
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Thu, May 03, 2012 at 03:28:17AM +0530, Sasikanth babu wrote:
> > On Wed, May 2, 2012 at 9:01 PM, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > On Wed, May 02, 2012 at 06:20:54PM +0530, Sasikantha babu wrote:
> > >> As we know the current debugfs file or directory or symlink creation
> > >> doesn't return proper error codes to the caller on failure. Because
> > >> of this caller and user could not able to find the exact reason of
> > >> the failure.
> > >
> > > And what is the problem with this? __Either the file is created or not,
> > > you really shouldn't care anymore than that. __It's not like you are
> > > going to retry the creation, or are you?
> > >
> > > Who really cares if the file is failed to be created?
> > 
> >  In most of cases I had observed caller of debufs_create_file or
> >  debufs_create_dir always returns -ENOMEM on failure, which is not true.
> 
> Where does that happen?  And why would the creation of a debugfs file
> fail?

How's he supposed to know, when the kernel cannot return the correct
diagnostic?

That's the whole reason we have errnos: to report on what went wrong,
so operators can understand *why* it failed and so that programmers can
diagnose and fix bugs.

There's nothing special about debugfs and there is no reason why it
should deviate from well-established practice.

If well-written code checks the return value (as it should) and then
propagates an error code back to its caller (as it should), the stupid
debugfs interface forces that caller to invent an errno from thin air.
And if that guessed errno is wrong, it is actively misleading!

> You can fixup the callers to make it uniform, the api is uniform in what
> it returns today, right?

The API is stupid and wrong, actually.  There is no *advantage* to
having done it this way - none at all.

> Again, I see no real benifit for returning the "true" error as no one
> really cares about that, all that matters is if it worked or not, and
> even then, no one should really care about that either, as remember,
> this is debugfs, whose one rule is, "there is no rules."

No.  If something has gone wrong then something needs to be fixed. 
Either the system needs reconfiguration or kernel programmers have
repairs to do.  Either way, information is needed to make those fixes. 
debugfs designers don't get to tell debugfs users what is and is not
important to those users.


All that being said, it is unobvious that fixing this mistake is worth
all the churn.
