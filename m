Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab2BHRXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:23:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39206 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab2BHRXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:23:18 -0500
Date: Wed, 8 Feb 2012 09:23:13 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shaohua Li <shaohua.li@intel.com>, Jens Axboe <axboe@kernel.dk>,
        Vivek Goyal <vgoyal@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: Re: [PATCH] block: strip out locking optimization in
 put_io_context()
Message-ID: <20120208172313.GD19392@google.com>
References: <20120207162253.GG21292@google.com>
 <4F315113.5010804@kernel.dk>
 <CA+55aFxcjE4FsUVoarc+8OTi4OkqtgBmHq500=qaCeTqqWnqoA@mail.gmail.com>
 <20120207164735.GH21292@google.com>
 <CANejiEXUZpPzyrTmD-P-MWD-XDmvDoB9UAjDbnrzTEiAw6nsgQ@mail.gmail.com>
 <CANejiEXqLxJ=mhDYA04g4ZHo3CiXctCUVnHu1--yp0GYgPxOKQ@mail.gmail.com>
 <20120208162925.GA19392@google.com>
 <CA+55aFy8ym1KSFv753wGrYn8qG5eK6YOy_nOCpYiqPjoLJwysg@mail.gmail.com>
 <20120208164920.GB19392@google.com>
 <20120208165611.GC19392@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120208165611.GC19392@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 08:56:11AM -0800, Tejun Heo wrote:
> On Wed, Feb 08, 2012 at 08:49:20AM -0800, Tejun Heo wrote:
> > I'm still a bit lost on where the regression is coming from and
> > *suspecting* that queue_lock contention is making the reverse locking
> > behave much worse than expected, so I mostly wanted to take that out
> > and see what happens.
> 
> IOW, we can achieve about the same thing by adding another lock in
> request_queue.  The goal is using an inner lock for ioc clearing so
> that queue_lock doesn't have to be grabbed inside ioc lock.

Urgh....... forget about the above message.  My head is still booting.
We can't do this w/ per-queue lock as we don't have a way to traverse
the associated queues w/o holding the lock and we need read locking on
ioc exit path as we may recurse through elevator icq exit (it's not
about concurrency).  /me goes to brew coffee.

-- 
tejun
