Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab0I3GgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 02:36:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754376Ab0I3GgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 02:36:04 -0400
Date: Wed, 29 Sep 2010 23:37:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/17] fs: icache atomic inodes_stat
Message-Id: <20100929233705.dc959855.akpm@linux-foundation.org>
In-Reply-To: <20100930062057.GA5665@dastard>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-8-git-send-email-david@fromorbit.com>
	<20100929215253.6fd944a2.akpm@linux-foundation.org>
	<20100930062057.GA5665@dastard>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010 16:20:57 +1000 Dave Chinner <david@fromorbit.com> wrote:

> > > --- a/fs/fs-writeback.c
> > > +++ b/fs/fs-writeback.c
> > > @@ -764,7 +764,8 @@ static long wb_check_old_data_flush(struct bdi_writeback *wb)
> > >  	wb->last_old_flush = jiffies;
> > >  	nr_pages = global_page_state(NR_FILE_DIRTY) +
> > >  			global_page_state(NR_UNSTABLE_NFS) +
> > > -			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
> > > +			(atomic_read(&inodes_stat.nr_inodes) -
> > > +			atomic_read(&inodes_stat.nr_unused));
> > 
> > race bug.
> 
> What new race?  The code has gone from using subtraction of unlocked
> counters to using subtraction of unlocked atomic counters. I can't
> see any new race condition in that transformation....

Oh.  I assumed that all the above used to happen under inode_lock.

Coz that's wot the changelog told me :)
