Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab1EOFlx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 01:41:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51947 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab1EOFlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 01:41:52 -0400
Message-ID: <4DCF6789.70701@kernel.org>
Date: Sat, 14 May 2011 22:41:29 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
References: <4DCAFFD8.2080605@kernel.org> <4DCB157F.20202@kernel.org> <20110512060344.GB3191@elte.hu> <4DCB8BCD.1080607@kernel.org> <4DCB8F7A.90603@kernel.org> <20110512092013.GJ2258@linux.vnet.ibm.com> <4DCC52FB.6030500@kernel.org> <BANLkTin1haL+isnR0UUoHdNm99bnxYPt-g@mail.gmail.com> <20110514142621.GB2258@linux.vnet.ibm.com> <20110514153118.GA24311@linux.vnet.ibm.com> <20110514183453.GA32756@linux.vnet.ibm.com> <4DCF5322.7030305@kernel.org>
In-Reply-To: <4DCF5322.7030305@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090205.4DCF6797.00CF,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2011 09:14 PM, Yinghai Lu wrote:
> On 05/14/2011 11:34 AM, Paul E. McKenney wrote:
>>> and do the inspection afterwards.
>>
>> And here is a lightly-tested patch, which applies on tip/core/rcu.
>>
>> This problem could account for both the long delays seen with e59fb312
>> (Decrease memory-barrier usage based on semi-formal proof) and the
>> shorter delays seen with a26ac245 (move TREE_RCU from softirq to kthread).
> 
> yes. it fixes the problem.
> 
> for 1024g system when hotadd mem enabled in kernel config
> 
> [   31.814803] cpu_dev_init done
> [   35.437163] memory_dev_init done
> 
> even it is with gcc from opensuse 11.3

got:

[   86.931217] Switched to NOHz mode on CPU #0
[   86.931272] Switched to NOHz mode on CPU #25
[   86.931278] ------------[ cut here ]------------
[   86.931290] WARNING: at kernel/rcutree.c:364 rcu_enter_nohz+0x44/0x76()
[   86.931294] Hardware name: Sun Fire X4800 M2 
[   86.931297] Modules linked in:
[   86.931303] Pid: 0, comm: swapper Not tainted 2.6.39-rc7-tip-yh-04836-g5e42dc2-dirty #3
[   86.931307] Call Trace:
[   86.931333]  [<ffffffff81080280>] warn_slowpath_common+0x85/0x9d
[   86.931338] Switched to NOHz mode on CPU #74
[   86.931346]  [<ffffffff810802b2>] warn_slowpath_null+0x1a/0x1c
[   86.931356]  [<ffffffff810d3615>] rcu_enter_nohz+0x44/0x76
[   86.931370]  [<ffffffff810ab3cb>] tick_nohz_stop_sched_tick+0x27d/0x366
[   86.931381]  [<ffffffff810391bc>] cpu_idle+0x7a/0xcc
[   86.931397]  [<ffffffff81bd1aa3>] rest_init+0xb7/0xbe
[   86.931408]  [<ffffffff81bd19ec>] ? csum_partial_copy_generic+0x16c/0x16c
[   86.931423]  [<ffffffff82738e39>] start_kernel+0x3b2/0x3bd
[   86.931428] Switched to NOHz mode on CPU #94
[   86.931436]  [<ffffffff827382cc>] x86_64_start_reservations+0x9c/0xa0
[   86.931446]  [<ffffffff827384a8>] x86_64_start_kernel+0x1d8/0x1e3
[   86.931463] ---[ end trace 2cfc591bf7de931f ]---
[   86.931598] Switched to NOHz mode on CPU #151
[   86.931613] Switched to NOHz mode on CPU #152
