Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760449Ab2CMKKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 06:10:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35033 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760153Ab2CMKKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 06:10:14 -0400
Message-ID: <4F5F1CF2.5000809@gmail.com>
Date: Tue, 13 Mar 2012 18:09:54 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] module: use rcu to protect module list read
References: <1331389203-3309-1-git-send-email-xiyou.wangcong@gmail.com> <1331393157.2453.15.camel@edumazet-laptop> <87k42pz66x.fsf@rustcorp.com.au>
In-Reply-To: <87k42pz66x.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 08:37 AM, Rusty Russell wrote:
> On Sat, 10 Mar 2012 07:25:57 -0800, Eric Dumazet<eric.dumazet@gmail.com>  wrote:
>> Le samedi 10 mars 2012 à 22:20 +0800, Cong Wang a écrit :
>>> Now the read of module list is protected by preempt disable + *_rcu
>>> list operations, this is odd, as RCU read lock should be able to
>>> protect it directly. This patch makes the read of module list
>>> protected by RCU read lock and the write still protected by
>>> module_mutex.
>>>
>>
>> Problem is that your patch does more than that.
>>
>> In set_all_modules_text_rw() and set_all_modules_text_ro() you removed
>> the mutex in favor of rcu_read_lock()
>>
>> Also, module code uses synchronize_sched(), not synchronize_rcu()
>
> Yes, but only for paranoia.  Really, it's vs. stop_machine().
>
>> Take a look at Documentation/RCU/whatisRCU.txt and see that
>> preempt_disable() / preempt_enable() are documented as a right protect
>> code, in line 333.
>>
>> You added races in /proc/modules as well.
>
> I'm surprised that patch didn't warn... CONFIG_DEBUG_ATOMIC_SLEEP=y
> might help here....

Ok I will enable it for testing.

Thanks.
