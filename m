Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab2IXSGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 14:06:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59317 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495Ab2IXSF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 14:05:26 -0400
Date: Mon, 24 Sep 2012 11:05:16 -0700
From: Tejun Heo <tj@kernel.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memstick: add support for legacy memorysticks
Message-ID: <20120924180516.GF7694@google.com>
References: <1348060743-6295-1-git-send-email-maximlevitsky@gmail.com>
 <1348060743-6295-2-git-send-email-maximlevitsky@gmail.com>
 <20120919145228.80f72f59.akpm@linux-foundation.org>
 <1348113942.16096.18.camel@maxim-laptop>
 <20120920175340.GE28934@google.com>
 <1348498747.618.4.camel@maxim-laptop>
 <1348499363.618.6.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348499363.618.6.camel@maxim-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 24, 2012 at 05:09:23PM +0200, Maxim Levitsky wrote:
> > Now that my exams done....
> > Can you spare me from using a workqueue?

I'd much prefer if you convert to workqueue.

> > The point is that using current model I wake the worker thread as much
> > as I want to, and I know that it will be woken once an will do all the
> > work till request queue is empty.

You can do exactly the same thing by scheduling the same work item
multiple times.  "Waking up" just becomes "scheduling the work item".

> > With workqueues, it doesn't work this way. I have to pass the request as
> > a work item or something like that.
> > Any pointers?

No, there's no reason to change the structure of the code in any way.
Just use a work item as you would use a kthread.

> Also probably due to that reason MMC doesn't use a workqueue ether, but
> a raw kthread, in pretty much same way I do.

Mostly because I haven't gotten around to convert it yet.  The
problems with direct kthread usage are that they're much more
difficult to get completely correct with freeze and exit conditions -
the last time I checked it was easier to spot broken ones than correct
ones - and they create dedicated threads which usually are
underutilized.

Thanks.

-- 
tejun
