Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab0HQPZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:25:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860Ab0HQPZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:25:13 -0400
Subject: Re: [GIT PULL] notification tree - try 37!
From: Eric Paris <eparis@redhat.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>
In-Reply-To: <201008171038.50456.agruen@suse.de>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com>
	 <201008162232.36873.agruen@suse.de>
	 <1282016387.21419.113.camel@acb20005.ipt.aol.com>
	 <201008171038.50456.agruen@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 11:24:28 -0400
Message-ID: <1282058668.21419.131.camel@acb20005.ipt.aol.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 10:38 +0200, Andreas Gruenbacher wrote:
> On Tuesday 17 August 2010 05:39:47 Eric Paris wrote:
> > On Mon, 2010-08-16 at 22:32 +0200, Andreas Gruenbacher wrote:
> > > On Saturday 07 August 2010 21:15:14 Eric Paris wrote:
> > > > On Fri, 2010-08-06 at 20:06 -0400, Christoph Hellwig wrote:
> > > > > I'm also totally missing on any re-post of these patches or
> > > > > discussion of the changes during the last development window.
> > > > 
> > > > I just searched lkml an fsdevel where I usually send everything don't
> > > > see then.  I totally failed.
> > > 
> > > Oh yes.
> > > 
> > > This introduces two new syscalls which will be impossible to fix up after
> > > the fact, and those system calls are poorly documented: commits 2a3edf86
> > > and 52c923dd document the initial versions (in the commit message!), but
> > > subsequent commits then extend that interface.  The interface for
> > > replying to events is not documented at all beyond the example code [1].
> > >  There is no documentation in Documentation/filesystems/, either.
> > > 
> > > 	[1] http://people.redhat.com/~eparis/fanotify/
> 
> Oh ... this example doesn't actually build; both syscall prototypes are wrong.  
> What have you been testing this with?

I updated that code, I didn't realize just how out of date it got.

> > I'll work on documentation.  Although it should be pointed out that the
> > interface was sent to list many times with lots of discussion and
> > feedback.
> 
> One of the wonky remaining bits is the way how files are reopened with 
> dentry_open() with the f_flags passed to fanotify_init().  The open can fail, 
> in which case the user is left with an error condition but with no indication 
> as to which object the error happened for.  What the heck?

What else can be done?  When notification is based on an open fd and you
can't give them an open fd, there's nothing left....

