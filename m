Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab2HNI0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:26:45 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:38347 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab2HNI0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:26:43 -0400
Message-ID: <502A0BB1.4030608@linux.vnet.ibm.com>
Date: Tue, 14 Aug 2012 13:56:25 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: tglx@linutronix.de, mingo@kernel.org, paulmck@linux.vnet.ibm.com,
        josh@joshtriplett.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] preempt/hardirq.h: Fix comment about PREEMPT_ACTIVE bit
 location
References: <20120720192459.6149.14821.stgit@srivatsabhat.in.ibm.com> <1343706583.27983.28.camel@gandalf.stny.rr.com>
In-Reply-To: <1343706583.27983.28.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
x-cbid: 12081408-9574-0000-0000-000003F818A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 09:19 AM, Steven Rostedt wrote:
> On Sat, 2012-07-21 at 00:54 +0530, Srivatsa S. Bhat wrote:
>> PREEMPT_ACTIVE flag is bit 27, not 28. Fix the comment.
>>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
>>
>>  include/linux/hardirq.h |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
>> index bb7f309..305f23c 100644
>> --- a/include/linux/hardirq.h
>> +++ b/include/linux/hardirq.h
>> @@ -22,7 +22,7 @@
>>   *
>>   * - bits 16-25 are the hardirq count (max # of nested hardirqs: 1024)
>>   * - bit 26 is the NMI_MASK
>> - * - bit 28 is the PREEMPT_ACTIVE flag
>> + * - bit 27 is the PREEMPT_ACTIVE flag
> 
> Sorry but in arch/x86/include/asm/thread_info.h we have:
> 
> #define PREEMPT_ACTIVE		0x10000000
> 
> Which happens to be the 28th bit, not 27th. Although, if an arch did not
> define PREEMPT_ACTIVE it would be 27th.
> 
> Perhaps the correct thing to do is to say:
> 
>   By default the following bits are defined as:
> 	[...]
>   Different architectures may modify these.
> 
> And then add your change.
> 

Thanks a lot for your suggestions Steve! And sorry for the delay..
I'll post the updated patch (which applies on latest Linus master) as a reply
to this thread.

Regards,
Srivatsa S. Bhat

