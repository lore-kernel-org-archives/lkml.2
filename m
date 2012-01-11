Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab2AKJRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 04:17:30 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:56125 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab2AKJR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 04:17:27 -0500
Message-ID: <4F0D538C.5040202@de.ibm.com>
Date: Wed, 11 Jan 2012 10:17:00 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/s390: fix compile error in sched/core.c
References: <1326268696-30904-1-git-send-email-borntraeger@de.ibm.com> <1326272868.2442.122.camel@twins>
In-Reply-To: <1326272868.2442.122.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 12011109-0542-0000-0000-000000A28E7B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/12 10:07, Peter Zijlstra wrote:
> On Wed, 2012-01-11 at 08:58 +0100, Christian Borntraeger wrote:
>> From: Christian Borntraeger <borntraeger@de.ibm.com>
>>
>> commit 029632fbb7b7c9d85063cc9eb470de6c54873df3
>>     sched: Make separate sched*.c translation units
>>
>> removed the include of asm/mutex.h from sched.c. This breaks the combination of
>>
>> CONFIG_MUTEX_SPIN_ON_OWNER=yes
>> CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX=yes
>> like s390 without mutex debugging:
>>
>>   CC      kernel/sched/core.o
>> kernel/sched/core.c: In function ‘mutex_spin_on_owner’:
>> kernel/sched/core.c:3287: error: implicit declaration of function ‘arch_mutex_cpu_relax’
>> make[2]: *** [kernel/sched/core.o] Error 1
>>
>> Lets re-add the include to kernel/sched/core.c
> 
> Weird, I would have expected -next to pick this up.. 
Maybe the builds of next runs with DEBUG_MUTEXES, which disables MUTEX_SPIN_ON_OWNER.

> Anyway, no objection although do we really need that extra #ifdef ?

Dont think so. I consider this more as a comment why we need this. Whoever applies the patch,
feel free to remove the ifdefs.

Christian

