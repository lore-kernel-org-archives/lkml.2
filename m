Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab1EJSFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 14:05:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17503 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab1EJSFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 14:05:37 -0400
Message-ID: <4DC97E49.7040401@kernel.org>
Date: Tue, 10 May 2011 11:04:57 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
References: <20110508151848.GA21906@linux.vnet.ibm.com> <20110509073636.GA18247@elte.hu> <BANLkTin82W0yZ5Nvv3Dp62X1eou_GxZ6EA@mail.gmail.com> <20110510085623.GG2258@linux.vnet.ibm.com>
In-Reply-To: <20110510085623.GG2258@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DC97E5B.00BB,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2011 01:56 AM, Paul E. McKenney wrote:
> On Mon, May 09, 2011 at 02:09:21PM -0700, Yinghai Lu wrote:
>> On Mon, May 9, 2011 at 12:36 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
>>>
>>>> Hello, Ingo,
>>>>
>>>> This pull request covers RCU chnages for 2.6.40.  The major new features
>>>> are RCU priority boosting and the addition of kfree_rcu(), the latter
>>>> courtesy of Lai Jiangshan.  These two features cover well over half
>>>> of the commits.  There are a number of smaller features and bug fixes.
>>>> All have been sent to LKML in the following batches:
>>>>
>>>> 0.    https://lkml.org/lkml/2011/2/22/660: RCU priority boosting preview
>>>> 1.    https://lkml.org/lkml/2011/5/1/19: RCU priority boosting, kfree_rcu()
>>>> 2.    https://lkml.org/lkml/2011/5/2/40: More uses of kfree_rcu()
>>>> 3.    https://lkml.org/lkml/2011/5/8/60: miscellaneous
>>>>
>>>> The kfree_rcu() uses in the pull request have Acked-by:s from the
>>>> maintainers.  I have some additional kfree_rcu() requests that lack
>>>> Acked-by:s, and I will deal with these later.
>>>>
>>>> These channges are available in the -rcu git repository at:
>>>>
>>>>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next
>>>
>>> Pulled, thanks a lot Paul!
>>>
>>
>> it seems with this one in tip, my 8 sockets test setup will report cpu stall.
>>
>> after hard code to enable rcu_cpu_stall_suppress
>>
>> Index: linux-2.6/kernel/rcutree.c
>> ===================================================================
>> --- linux-2.6.orig/kernel/rcutree.c
>> +++ linux-2.6/kernel/rcutree.c
>> @@ -174,7 +174,7 @@ module_param(blimit, int, 0);
>>  module_param(qhimark, int, 0);
>>  module_param(qlowmark, int, 0);
>>
>> -int rcu_cpu_stall_suppress __read_mostly;
>> +int rcu_cpu_stall_suppress __read_mostly = 1;
>>  module_param(rcu_cpu_stall_suppress, int, 0644);
>>
>>  static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
>>
>> will get system hang after pnp ACPI init.
> 
> Could you please send the stack traces from the RCU CPU stall?  Also,
> you do have ce31332d3c77532d6ea97ddcb475a2b02dd358b4 applied, correct?
> 
> 							Thanx, Paul

Do not have time to bisect it at this point.

can you prepare clean revert patch for following commit to test?

commit a00e0d714fbded07a7a2254391ce9ed5a5cb9d82
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Tue Feb 8 17:14:39 2011 -0800

    rcu: Remove conditional compilation for RCU CPU stall warnings


Thanks

Yinghai Lu
