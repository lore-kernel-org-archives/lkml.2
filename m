Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab1IGWTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 18:19:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758Ab1IGWTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 18:19:44 -0400
Date: Wed, 7 Sep 2011 15:19:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jens Axboe <jaxboe@fusionio.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm: Add comment explaining task state setting in
 bdi_forker_thread()
Message-Id: <20110907151936.1d67c706.akpm@linux-foundation.org>
In-Reply-To: <20110905155347.GA17354@quack.suse.cz>
References: <1315004059-9844-1-git-send-email-jack@suse.cz>
	<1315004059-9844-3-git-send-email-jack@suse.cz>
	<20110904030551.GB16361@localhost>
	<20110905100141.GA5466@quack.suse.cz>
	<20110905124411.GA794@localhost>
	<20110905155347.GA17354@quack.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Sep 2011 17:53:47 +0200
Jan Kara <jack@suse.cz> wrote:

> On Mon 05-09-11 20:44:11, Wu Fengguang wrote:
> > On Mon, Sep 05, 2011 at 06:01:41PM +0800, Jan Kara wrote:
> > > On Sun 04-09-11 11:05:51, Wu Fengguang wrote:
> > > > > @@ -401,6 +401,13 @@ static int bdi_forker_thread(void *ptr)
> > > > >  		}
> > > > >  
> > > > >  		spin_lock_bh(&bdi_lock);
> > > > > +		/*
> > > > > +		 * In the following loop we are going to check whether we have
> > > > > +		 * some work to do without any synchronization with tasks
> > > > > +		 * waking us up to do work for them. So we have to set task
> > > > > +		 * state already here so that we don't miss wakeups coming
> > > > 
> > > > s/already/early/ ?
> > >   Thanks for review. We'd have to substitute 'already here' with 'early'
> > > for the sentence to make make sense. But frankly I don't see why one would
> > > be better than the other one...
> > 
> > You are the native English speaker?  OK, I have no more problems... ;)
>   No, I'm not a native English speaker. Maybe that's why I don't see that
> much difference :-))

grammar can often be fixed/improved by deleting stuff ;)

--- a/mm/backing-dev.c~mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix
+++ a/mm/backing-dev.c
@@ -404,9 +404,8 @@ static int bdi_forker_thread(void *ptr)
 		/*
 		 * In the following loop we are going to check whether we have
 		 * some work to do without any synchronization with tasks
-		 * waking us up to do work for them. So we have to set task
-		 * state already here so that we don't miss wakeups coming
-		 * after we verify some condition.
+		 * waking us up to do work for them. Set the task state here
+		 * so that we don't miss wakeups after verifying conditions.
 		 */
 		set_current_state(TASK_INTERRUPTIBLE);
 
_

