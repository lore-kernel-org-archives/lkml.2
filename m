Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030329Ab2CMKRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 06:17:21 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59351 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965046Ab2CMKRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 06:17:19 -0400
Message-ID: <4F5F1E86.8060707@gmail.com>
Date: Tue, 13 Mar 2012 18:16:38 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [V2 PATCH 1/3] module: use rcu to protect module list read
References: <1331463255-31019-1-git-send-email-xiyou.wangcong@gmail.com> <1331487502.2449.20.camel@edumazet-laptop>
In-Reply-To: <1331487502.2449.20.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 01:38 AM, Eric Dumazet wrote:
> Le dimanche 11 mars 2012 à 18:54 +0800, Cong Wang a écrit :
>> V2:
> ...
>>
>> @@ -1639,7 +1639,7 @@ static void mod_sysfs_teardown(struct module *mod)
>>   static int __unlink_module(void *_mod)
>>   {
>>   	struct module *mod = _mod;
>> -	list_del(&mod->list);
>> +	list_del_rcu(&mod->list);
>>   	module_bug_cleanup(mod);
>>   	return 0;
>>   }
>> @@
>
> You mix too many different things in a single patch.
>
> For example, lets review this __unlink_module() change...

Oops, sorry I missed this part...

>
> If this was really needed, it should be a single patch so that it can be
> a stable submission.
>
> As it is not needed (since its called from stop_machine()), this makes
> your whole patch looking suspicious.
>
> I suggest you make a 100% cleanup patch, changing the title as well,
> because module code _already_ uses RCU.
>
> "module: use rcu to protect module list read" makes no sense at all.
>
> To meet current RCU API best pratices, you change preempt_enable() by
> rcu_read_unlock_sched() and preempt_disable() by rcu_read_lock_sched()
>
> Then, if you believe other changes are needed, submit them with an
> explicit changelog explaining the change, not hiding them in a big
> cleanup patch.
>
>

Fair enough, Rusty gave me the same suggestion, I will split this patch.

Thanks!
