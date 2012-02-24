Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab2BXOUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 09:20:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab2BXOUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 09:20:41 -0500
Date: Fri, 24 Feb 2012 09:20:33 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120224142033.GA5095@redhat.com>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
 <20120223144336.58742e1b.akpm@linux-foundation.org>
 <20120223230123.GL22536@google.com>
 <20120223231204.GM22536@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223231204.GM22536@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 03:12:04PM -0800, Tejun Heo wrote:
> On Thu, Feb 23, 2012 at 03:01:23PM -0800, Tejun Heo wrote:
> > Hmmm... going through the thread again, ah, okay, I forgot about that
> > completely.  Yeah, that is an actual problem.  Both __GFP_WAIT which
> > isn't GFP_KERNEL and GFP_KERNEL are valid use cases.  I guess we'll be
> > building async percpu pool in blkcg then.  Great.  :(
> 
> Vivek, you win. :) Can you please refresh the async alloc patch on top
> of blkcg-stacking branch?  I'll rool that into this series and drop
> the mempool stuff.
> 

Ok. I will write a patch. Things have changed a lot since last time.
I think there is only one tricky part and that is waiting for any
scheduled work to finish during blkg destruction.  Because group destruction
happens under both queue and blkcg spin locks, I think I will have to take
the group off list, drop locks, wait for worker thread to finish and then
take locks again and walk through list again to kill remaining groups.

/me goes to try it.

Thanks
Vivek
