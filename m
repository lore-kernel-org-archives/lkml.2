Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab0EaJ7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 05:59:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:39947 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756838Ab0EaJ7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 05:59:41 -0400
Message-ID: <4C038841.1010507@kernel.org>
Date: Mon, 31 May 2010 11:58:25 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 4/4] sched: add hooks for workqueue
References: <1273747705-7829-1-git-send-email-tj@kernel.org>	 <1273747705-7829-5-git-send-email-tj@kernel.org> <1275292867.27810.21442.camel@twins>
In-Reply-To: <1275292867.27810.21442.camel@twins>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 09:58:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On 05/31/2010 10:01 AM, Peter Zijlstra wrote:
> On Thu, 2010-05-13 at 12:48 +0200, Tejun Heo wrote:
>> Concurrency managed workqueue needs to know when workers are going to
>> sleep and waking up, and, when a worker goes to sleep, be able to wake
>> up another worker to maintain adequate concurrency.  This patch
>> introduces PF_WQ_WORKER to identify workqueue workers and adds the
>> following two hooks.
>>
>> * wq_worker_waking_up(): called when a worker is woken up.
>>
>> * wq_worker_sleeping(): called when a worker is going to sleep and may
>>   return a pointer to a local task which should be woken up.  The
>>   returned task is woken up using try_to_wake_up_local() which is
>>   simplified ttwu which is called under rq lock and can only wake up
>>   local tasks.
> 
> This changelog seems to lack explanation for why you need the wakeup
> callback.

Because cmwq "needs to know when workers are going to sleep and waking
up, and, when a worker goes to sleep, be able to wake up another
worker to maintain adequate concurrency".  Sure, I can add more but
again forward reference here would work pretty well when digging
through history.

-- 
tejun
