Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab2EBWEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 18:04:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38933 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab2EBWEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 18:04:20 -0400
Date: Wed, 2 May 2012 15:04:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sasikanth babu <sasikanth.v19@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debugfs: New debugfs interface for creation of files,
 directory and symlinks
Message-ID: <20120502220417.GA2667@kroah.com>
References: <1335963054-24750-1-git-send-email-sasikanth.v19@gmail.com>
 <20120502153100.GA2777@kroah.com>
 <CAOJFanXZEUfM4GQS62u4oR-KwywdLGOciOcgzmrM9zW+kOrXkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOJFanXZEUfM4GQS62u4oR-KwywdLGOciOcgzmrM9zW+kOrXkg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 03:28:17AM +0530, Sasikanth babu wrote:
> On Wed, May 2, 2012 at 9:01 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Wed, May 02, 2012 at 06:20:54PM +0530, Sasikantha babu wrote:
> >> As we know the current debugfs file or directory or symlink creation
> >> doesn't return proper error codes to the caller on failure. Because
> >> of this caller and user could not able to find the exact reason of
> >> the failure.
> >
> > And what is the problem with this?  Either the file is created or not,
> > you really shouldn't care anymore than that.  It's not like you are
> > going to retry the creation, or are you?
> >
> > Who really cares if the file is failed to be created?
> 
>  In most of cases I had observed caller of debufs_create_file or
>  debufs_create_dir always returns -ENOMEM on failure, which is not true.

Where does that happen?  And why would the creation of a debugfs file
fail?

>  I felt returning proper error code will help in figuring out the actual
>  reason of the failure (for eg: it can be -EEXISTS based on the error
>  caller can change the name of the file or dir)

Why would it ever conflict in the first place?

What files in the kernel have this problem today that they would create
conflicting files/dirs?

> >> As Andrew Morton suggested (http://www.spinics.net/lists/linux-mm/msg33617.html)
> >> introduced new debugfs interface to create debugfs entries. Newer APIs
> >> returns proper error codes(ERR_PTR) on failure.
> >
> > Again, why?  What root problem are you trying to solve here?
> 
>    The usage of debugfs throughout the kernel is not uniform especially the
>    error handling scenarios. Some place it is IS_ERR validations , other place
>    against NULL and some place ignoring the return value. Just tried to make it
>    uniform.

You can fixup the callers to make it uniform, the api is uniform in what
it returns today, right?

Again, I see no real benifit for returning the "true" error as no one
really cares about that, all that matters is if it worked or not, and
even then, no one should really care about that either, as remember,
this is debugfs, whose one rule is, "there is no rules."

thanks,

greg k-h
