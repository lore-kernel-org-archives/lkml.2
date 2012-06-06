Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab2FFOqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:46:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58545 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274Ab2FFOqh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:46:37 -0400
MIME-Version: 1.0
In-Reply-To: <CANQmPXjMUxyge05CapeE2G1JYG0KOhHX+KuL7Xv5vZ2+ahVu1g@mail.gmail.com>
References: <CAJd=RBCZL0ZkqsZJq4ydqn4gsDoDZmT8so_z8S1bJu_E58pvDQ@mail.gmail.com>
	<CANQmPXjMUxyge05CapeE2G1JYG0KOhHX+KuL7Xv5vZ2+ahVu1g@mail.gmail.com>
Date: Wed, 6 Jun 2012 22:46:37 +0800
Message-ID: <CANQmPXi=rXYc+oEuBuBJUTWPs9-38VyK24+FzaUai5+KnZFdcQ@mail.gmail.com>
Subject: Re: [patch] BFS 421: confine for_each_domain to SMP
From: Chen <hi3766691@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 10:46 PM, Chen <hi3766691@gmail.com> wrote:
> On Wed, Jun 6, 2012 at 9:23 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> Lets trap the insane build.
>>
>>
>> --- a/kernel/sched/bfs.c        Wed Jun  6 20:56:22 2012
>> +++ b/kernel/sched/bfs.c        Wed Jun  6 21:01:00 2012
>> @@ -324,7 +324,6 @@ int __weak arch_sd_sibling_asym_packing(
>>  {
>>        return 0*SD_ASYM_PACKING;
>>  }
>> -#endif
>>
>>  #define rcu_dereference_check_sched_domain(p) \
>>        rcu_dereference_check((p), \
>> @@ -339,6 +338,9 @@ int __weak arch_sd_sibling_asym_packing(
>>  */
>>  #define for_each_domain(cpu, __sd) \
>>        for (__sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd);
>> __sd; __sd = __sd->parent)
>> +#else
>> +#define for_each_domain(cpu, __sd)     BUILD_BUG()
>> +#endif
>>
>>  static inline void update_rq_clock(struct rq *rq);
>>
>> --
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> Good! You haven't give up, Hilff. :-)
