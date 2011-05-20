Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab1ETXJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 19:09:55 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57587 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab1ETXJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 19:09:49 -0400
Message-ID: <4DD6F4A2.1070401@kernel.org>
Date: Fri, 20 May 2011 16:09:22 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage based
 on semi-formal proof"
References: <tip-80d02085d99039b3b7f3a73c8896226b0cb1ba07@git.kernel.org> <4DD6D746.6070107@kernel.org> <20110520224250.GL2366@linux.vnet.ibm.com>
In-Reply-To: <20110520224250.GL2366@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090202.4DD6F4AD.0066,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2011 03:42 PM, Paul E. McKenney wrote:
> On Fri, May 20, 2011 at 02:04:06PM -0700, Yinghai Lu wrote:
>> On 05/19/2011 02:37 PM, tip-bot for Paul E. McKenney wrote:
>>> Commit-ID:  80d02085d99039b3b7f3a73c8896226b0cb1ba07
>>> Gitweb:     http://git.kernel.org/tip/80d02085d99039b3b7f3a73c8896226b0cb1ba07
>>> Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>> AuthorDate: Thu, 12 May 2011 01:08:07 -0700
>>> Committer:  Ingo Molnar <mingo@elte.hu>
>>> CommitDate: Thu, 19 May 2011 23:25:29 +0200
>>>
>>> Revert "rcu: Decrease memory-barrier usage based on semi-formal proof"
>>>
>>> This reverts commit e59fb3120becfb36b22ddb8bd27d065d3cdca499.
>>>
>>> This reversion was due to (extreme) boot-time slowdowns on SPARC seen by
>>> Yinghai Lu and on x86 by Ingo
>>> .
>>> This is a non-trivial reversion due to intervening commits.
>>>
>>> Conflicts:
>>>
>>> 	Documentation/RCU/trace.txt
>>> 	kernel/rcutree.c
>>>
>>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>> ---
>>>  Documentation/RCU/trace.txt |   17 ++++--
>>>  kernel/rcutree.c            |  130 ++++++++++++++++++++++++------------------
>>>  kernel/rcutree.h            |    9 ++-
>>>  kernel/rcutree_plugin.h     |    7 +-
>>>  kernel/rcutree_trace.c      |   12 ++--
>>>  5 files changed, 102 insertions(+), 73 deletions(-)
>>>
>>
>> current tip/master that have this reverting and without setting DEBUG_LOCKING_API_SELFTESTS
>>
>> still get delay
>>
>> [   35.419453] cpu_dev_init done
>> [  128.981770] memory_dev_init done
>>
>> should take only 3 or 4 seconds.
> 
> Thank you for checking this out.
> 
> This is with the same configuration you sent earlier?  (Other than the
> DEBUG_LOCKING_API_SELFTESTS, of course.)
> 

8 socket westmere-ex. and compiled with gcc from opensuse 11.3.

if compile kernel from fedora 14, there will be not delay.

Thanks

Yinghai
