Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab2IUBp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 21:45:58 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:35655 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab2IUBp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 21:45:56 -0400
Message-ID: <505BC6CA.4060602@linux.vnet.ibm.com>
Date: Fri, 21 Sep 2012 09:45:46 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: kernel BUG at kernel/sched/core.c:1465!
References: <20120919091230.GA25576@liondog.tnic> <505AB9F7.6030605@linux.vnet.ibm.com> <20120920125801.GA15045@x1.osrc.amd.com>
In-Reply-To: <20120920125801.GA15045@x1.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092101-5140-0000-0000-0000021AB623
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 08:58 PM, Borislav Petkov wrote:
> On Thu, Sep 20, 2012 at 02:38:47PM +0800, Michael Wang wrote:
>> Could you please try below patch and see whether the new WARNING
>> appear or not?
>>
>> And cc Tejun Heo <tj@kernel.org> since wq_worker_sleeping() doesn't
>> work as it's introduced...
> 
> Ok, now that you mentioned workqueues, I remember the powernow-k8
> workaround from Tejun a couple of days ago and looking at Linus' tree
> from today, he actually merged a fix for exactly that:
> 
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
> 
> I'll update my tree to latest Linus and retest.

Happen to see the problem solved.

Regards,
Michael Wang

> 
> Thanks for pointing this out.
> 

