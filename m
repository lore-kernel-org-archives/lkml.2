Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab1LAT3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 14:29:44 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49613 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab1LAT3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 14:29:43 -0500
Date: Thu, 1 Dec 2011 11:29:35 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH UPDATED 03/10] threadgroup: extend threadgroup_lock()
 to cover exit and exec
Message-ID: <20111201192935.GE13173@google.com>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-4-git-send-email-tj@kernel.org>
 <20111124225054.GA14828@google.com>
 <CA+55aFxq1wztMzYhKaY5RHazLBDz4pSXUgiGzTj2wA6EJcDbAw@mail.gmail.com>
 <20111127192155.GB4266@google.com>
 <20111127212558.GE4266@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111127212558.GE4266@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again, Linus.

On Sun, Nov 27, 2011 at 01:25:58PM -0800, Tejun Heo wrote:
> The problem is that cred_guard_mutex uses _interruptible/_killable
> operations and rwsem doesn't have them, so cred_guard_mutex can't be
> easily replaced with write-locking group_rwsem.
> 
> If the two locks can't be merged, under the proposed scheme, while not
> exactly pretty, both fork/exit and exec paths go through single
> locking and only the ones which want stable threadgroup need to grab
> both locks, so IMHO it is at least reasonable.
> 
> Any better ideas?

I agree that the proposed solution is rather ugly but stable
thread-group is a valid mechanism to have and cgroup can benefit a lot
from it.  I'd be happy to revamp the implementation if anyone can come
up with a better way and can add big fat comment stating that.  Until
something better comes up, would it be okay to stick with this
implementation?

Thanks.

-- 
tejun
