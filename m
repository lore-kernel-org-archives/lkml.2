Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab2ITRKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 13:10:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39674 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab2ITRKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 13:10:50 -0400
Date: Thu, 20 Sep 2012 10:10:45 -0700
From: Tejun Heo <tj@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Michael Wang <wangyun@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at kernel/sched/core.c:1465!
Message-ID: <20120920171045.GC28934@google.com>
References: <20120919091230.GA25576@liondog.tnic>
 <505AB9F7.6030605@linux.vnet.ibm.com>
 <20120920125801.GA15045@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920125801.GA15045@x1.osrc.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

On Thu, Sep 20, 2012 at 02:58:01PM +0200, Borislav Petkov wrote:
> commit c5c473e29c641380aef4a9d1f9c39de49219980f
> Merge: 925a6f0bf8bd 6889125b8b4e
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Wed Sep 19 11:00:07 2012 -0700
> 
>     Merge branch 'for-3.6-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq
>     
>     Pull workqueue / powernow-k8 fix from Tejun Heo:
>      "This is the fix for the bug where cpufreq/powernow-k8 was tripping
>       BUG_ON() in try_to_wake_up_local() by migrating workqueue worker to a
>       different CPU.
> 
> and this is exactly the same BUG_ON I'm hitting. and powernowk8_target
> is in the stack trace so it has to be the same issue.

Yeah, it's powernow-k8 migrating kworker to a different CPU.  It's
really curious that there are multiple reports of this in this cycle.
Nothing on workqueue side has changed and powernow-k8 has been broken
for very long time.  The only way this can get triggered is by
contending on fidvid_mutex in powernow-k8.  I suppose something
changed in such way that this happens with some regularity.  Have no
specific idea what.  Anyways, mainline should be okay now.

Thanks.

-- 
tejun
