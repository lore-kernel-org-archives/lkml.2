Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0JOOtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:49:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:44101 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984Ab0JOOtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:49:02 -0400
Message-ID: <4CB869CC.7070800@kernel.org>
Date: Fri, 15 Oct 2010 16:48:44 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: lkml <linux-kernel@vger.kernel.org>, mst@redhat.com
Subject: Re: [PATCH RFC] workqueue: remove in_workqueue_context()
References: <4C9B497B.4060302@kernel.org> <20100923171019.GD2406@linux.vnet.ibm.com>
In-Reply-To: <20100923171019.GD2406@linux.vnet.ibm.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 14:48:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2010 07:10 PM, Paul E. McKenney wrote:
> On Thu, Sep 23, 2010 at 02:35:07PM +0200, Tejun Heo wrote:
>> Commit a25909a4 (lockdep: Add an in_workqueue_context() lockdep-based
>> test function) added in_workqueue_context() but there hasn't been any
>> in-kernel user and the lockdep annotation in workqueue is scheduled to
>> change.  Remove the unused function.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> ---
>> Paul, I was looking through lockdep annotations to see how they can be
>> improved and noticed that in_workqueue_context() isn't used by anyone
>> and it seems like there hasn't been any in-kernel user either.  Can
>> this be removed or do you expect to use it somewhere?
> 
> I added it for the drivers/vhost changes.  They were using a
> variant of RCU where executing in workqueue context acted as an RCU
> read-side critical section and where flushing workqueues acted as
> an RCU grace period.  The in_workqueue_context() was then passed to
> rcu_dereference_check() to verify correct usage.
> 
> But you are right, I don't see it being used any more, though I do still
> see the big block comment documenting this in drivers/vhost/vhost.h.
> 
> Michael, what are Tejun and I missing here?

Ping.  Shall I go forward with this patch?

Thanks.

-- 
tejun
