Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab1LMBdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 20:33:42 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60263 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab1LMBdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 20:33:41 -0500
Date: Mon, 12 Dec 2011 17:33:34 -0800
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, paul@paulmenage.org,
        rjw@sisk.pl, lizf@cn.fujitsu.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        matthltc@us.ibm.com, akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com
Subject: Re: [PATCH UPDATED AGAIN 03/10] threadgroup: extend
 threadgroup_lock() to cover exit and exec
Message-ID: <20111213013334.GC25802@google.com>
References: <1320191193-8110-4-git-send-email-tj@kernel.org>
 <20111124225054.GA14828@google.com>
 <20111125140136.GC23307@somewhere.redhat.com>
 <20111127193001.GC4266@google.com>
 <20111202162753.GA19752@somewhere.redhat.com>
 <20111205184315.GJ627@google.com>
 <20111207153046.GC13252@somewhere.redhat.com>
 <20111207182214.GA7610@google.com>
 <20111208205055.GB12108@google.com>
 <20111209234246.GC27173@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111209234246.GC27173@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Dec 10, 2011 at 12:42:53AM +0100, Frederic Weisbecker wrote:
> > Okay, narrowed exit path protection down to setting of PF_EXITING
> > itself.  ->exit() on dangling tasks is a bit weird but I don't think
> > it's too bad.  Frederic, are you okay with this version?
> 
> Yeah that new scheme that only protects PF_EXITING may look a bit
> strange. But I think we are fine. With rcu list traversal, it should
> be safe even if a group member is concurrently dropped from the list (in that
> case all we check if its PF_EXITING then we give up). And we may
> have a concurrent ->exit() but that should be fine too.
> 
> Thanks!
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Awesome, adding Acked-by, putting it on top of pm-freezer and pushing
it out to linux-next.

Thank you.

-- 
tejun
