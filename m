Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab2BHQ4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 11:56:17 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50233 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab2BHQ4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 11:56:16 -0500
Date: Wed, 8 Feb 2012 08:56:11 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shaohua Li <shaohua.li@intel.com>, Jens Axboe <axboe@kernel.dk>,
        Vivek Goyal <vgoyal@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: Re: [PATCH] block: strip out locking optimization in
 put_io_context()
Message-ID: <20120208165611.GC19392@google.com>
References: <4F30C96F.1000905@kernel.dk>
 <20120207162253.GG21292@google.com>
 <4F315113.5010804@kernel.dk>
 <CA+55aFxcjE4FsUVoarc+8OTi4OkqtgBmHq500=qaCeTqqWnqoA@mail.gmail.com>
 <20120207164735.GH21292@google.com>
 <CANejiEXUZpPzyrTmD-P-MWD-XDmvDoB9UAjDbnrzTEiAw6nsgQ@mail.gmail.com>
 <CANejiEXqLxJ=mhDYA04g4ZHo3CiXctCUVnHu1--yp0GYgPxOKQ@mail.gmail.com>
 <20120208162925.GA19392@google.com>
 <CA+55aFy8ym1KSFv753wGrYn8qG5eK6YOy_nOCpYiqPjoLJwysg@mail.gmail.com>
 <20120208164920.GB19392@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120208164920.GB19392@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 08:49:20AM -0800, Tejun Heo wrote:
> I'm still a bit lost on where the regression is coming from and
> *suspecting* that queue_lock contention is making the reverse locking
> behave much worse than expected, so I mostly wanted to take that out
> and see what happens.

IOW, we can achieve about the same thing by adding another lock in
request_queue.  The goal is using an inner lock for ioc clearing so
that queue_lock doesn't have to be grabbed inside ioc lock.

Thanks.

-- 
tejun
