Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab2DFJp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 05:45:59 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:37810
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377Ab2DFJp6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 05:45:58 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zz9371I1432N98dKzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M21XSH-01-3PA-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: Clemens Ladisch <clemens@ladisch.de>
CC: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: semaphore and mutex in current Linux kernel (3.2.2)
Thread-Topic: semaphore and mutex in current Linux kernel (3.2.2)
Thread-Index: Ac0P7b5dm37XnMCsR726LS+rxvQKd///odaAgANgVTOAA464hf/+uc3Q
Date: Fri, 6 Apr 2012 09:45:50 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE0439F9E45@SCYBEXDAG02.amd.com>
References: <491D6B4EAD0A714894D8AD22F4BDE0439F94AB@SCYBEXDAG02.amd.com>
 <20120401121943.GA11893@gmail.com>
 <491D6B4EAD0A714894D8AD22F4BDE0439F9560@SCYBEXDAG02.amd.com>
 <20120403075245.GD26826@gmail.com>
 <491D6B4EAD0A714894D8AD22F4BDE0439F98F4@SCYBEXDAG02
 <4F7DA8FD.1020909@ladisch.de>
In-Reply-To: <4F7DA8FD.1020909@ladisch.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.74.102]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 5, 2012 at 10:15 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
> Chen, Dennis (SRDC SW) wrote:
>> I know that the rationale of the mutex's optimization is, if the lock owner is
>> running, it's likely to release the lock soon. So make the waiter to spin a
>> short time waiting for the lock to be released is reasonable given the workload
>> of a process switch.
>>
>> But how about if the lock owner running doesn't release the lock soon?
>
> It would not make sense to spin too long, especially if some other
> process wants to run on the same CPU.

Yes, you're right. If the waiter spin too long to wait for the owner to release the 
lock, the system performance will be degraded...

>> int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
>> {
>>       ...
>>       while (owner_running(lock, owner)) {
>>               if (need_resched())
>>                       break;
>>
>>               arch_mutex_cpu_relax();
>>       }
>>       ...
>> }
>>
>> [experiment]
>>
>> D+ means the App in CPU1 is sleeping in a UNINTERRUPTIBLE state. This is very interesting,
>> How does this happen?
>
> Your experiment shows that there must be some condition that makes the
> code break out of the spin loop ...

I guess this is related with RCU component, but I don't found the right place where the code 
Located yet. So Ingo's comments will be very helpful event a little bit... :-)

