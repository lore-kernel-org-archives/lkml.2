Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339Ab2BAWrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:47:36 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45190 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933271Ab2BAWrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:47:33 -0500
X-Sasl-enc: qHlx37DZwnd83H4bAaVRvsY/PkHNaQwsa7yGsi9A1vCe 1328136452
Date: Wed, 1 Feb 2012 14:47:08 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        Christopher Lais <chris+android@zenthought.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] Staging: android: binder: Add some error checks
Message-ID: <20120201224708.GA2643@kroah.com>
References: <1327118181-3542-1-git-send-email-arve@android.com>
 <1327118181-3542-2-git-send-email-arve@android.com>
 <20120121082208.GL3294@mwanda>
 <20120131185228.GA21481@kroah.com>
 <CAMP5XgedsSDtYa-bZCW--+Hj41sN94tDXQ8_d7c4=fT5bJ7mTQ@mail.gmail.com>
 <20120201065322.GA24652@mwanda>
 <CAMP5XgeV7R4JfRG+9qqkUN_BC0MvADKOngVXqK9mvmXcxisqYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP5XgeV7R4JfRG+9qqkUN_BC0MvADKOngVXqK9mvmXcxisqYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 02:29:36PM -0800, Arve Hjønnevåg wrote:
> 2012/1/31 Dan Carpenter <dan.carpenter@oracle.com>:
> > On Tue, Jan 31, 2012 at 03:20:30PM -0800, Arve Hjønnevåg wrote:
> >> 2012/1/31 Greg KH <greg@kroah.com>:
> >> > On Sat, Jan 21, 2012 at 11:22:08AM +0300, Dan Carpenter wrote:
> >> >> On Fri, Jan 20, 2012 at 07:56:20PM -0800, Arve Hjønnevåg wrote:
> >> >> > - Add a mutex to protect against two processes mmapping the
> >> >> >   same binder_proc.
> >> >> > - After locking mmap_sem, check that the vma we want to access
> >> >> >   (still) points to the same mm_struct.
> >> >> > - Use proc->tsk instead of current to get the files struct since
> >> >> >   this is where we get the rlimit from.
> >> >>
> >> >> This doesn't seem related to the locking change at all.  Probably
> >> >> this patch should be split into three patches, one bugfix per
> >> >> patch, unless they are very closely related.
> >> >
> >> > I agree.  Arve, is this all fixing one problem, or multiple ones?  If
> >> > multiple ones, we need this split up into multiple patches.
> >> >
> >>
> >> That depend on your point of view. It fixes crashes if you use the
> >> same binder file pointer from multiple processes. It seemed excessive
> >> to have three patches for this.
> >
> > It would have helped you to write a better changelog.  The subject
> > says "[patch] android: grab bag of random fixes" and the the
> > description matches that.  You have no idea how annoyed I get at
> > grab bag patches.
> >
> 
> Would the following be a better change description (or do you still
> want three patches):
> 
> Staging: android: binder: Fix crashes when sharing a binder file
> between processes
> 
> Opening the binder driver and sharing the file returned with
> other processes (e.g. by calling fork) can crash the kernel.
> Prevent these crashes with the following changes:
> - Add a mutex to protect against two processes mmapping the
>   same binder_proc.
> - After locking mmap_sem, check that the vma we want to access
>   (still) points to the same mm_struct.
> - Use proc->tsk instead of current to get the files struct since
>   this is where we get the rlimit from.

That looks good to me, as one patch, Dan?

greg k-h
