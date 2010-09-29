Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab0I2GkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 02:40:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:63277 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab0I2GkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 02:40:17 -0400
Message-ID: <4CA2E0BA.50908@windriver.com>
Date: Wed, 29 Sep 2010 14:46:18 +0800
From: DDD <dongdong.deng@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: dipankar@in.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] rcu: using ACCESS_ONCE() to observe the jiffies_stall/rnp->qsmask
 value
References: <1285662763-16748-1-git-send-email-dongdong.deng@windriver.com> <20100928232831.GC2419@linux.vnet.ibm.com>
In-Reply-To: <20100928232831.GC2419@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Sep 2010 06:40:12.0490 (UTC) FILETIME=[2AEF72A0:01CB5FA1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Tue, Sep 28, 2010 at 04:32:43PM +0800, Dongdong Deng wrote:
>> Using ACCESS_ONCE() to observe the jiffies_stall/rnp->qsmask value
>> due to the caller didn't hold the root_rcu/rnp node's lock.
> 
> Given that the quantities are only used once, ACCESS_ONCE() is strictly
> speaking not necessary.  I am tempted to queue your patch regardless
> for the documentation benefits.
> 
> Or is this patch necessary to fix a failure that you have been seeing?

Hello Pual,

No, I didn't see a failure about it.
I got this patch from code review.  :-)

Thanks,
Dongdong

> In any case, thank you for taking a look at RCU!
> 
> 							Thanx, Paul
> 
>> Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
>> CC: Dipankar Sarma <dipankar@in.ibm.com>
>> CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> ---
>>  kernel/rcutree.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
>> index d5bc439..07a7063 100644
>> --- a/kernel/rcutree.c
>> +++ b/kernel/rcutree.c
>> @@ -532,9 +532,9 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
>>
>>  	if (rcu_cpu_stall_panicking)
>>  		return;
>> -	delta = jiffies - rsp->jiffies_stall;
>> +	delta = jiffies - ACCESS_ONCE(rsp->jiffies_stall);
>>  	rnp = rdp->mynode;
>> -	if ((rnp->qsmask & rdp->grpmask) && delta >= 0) {
>> +	if ((ACCESS_ONCE(rnp->qsmask) & rdp->grpmask) && delta >= 0) {
>>
>>  		/* We haven't checked in, so go dump stack. */
>>  		print_cpu_stall(rsp);
>> -- 
>> 1.6.0.4
>>
> 


