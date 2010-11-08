Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab0KHV7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:59:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:65012 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266Ab0KHV7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:59:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,170,1288594800"; 
   d="scan'208";a="855447311"
Message-ID: <4CD872A6.1020903@linux.intel.com>
Date: Mon, 08 Nov 2010 13:59:02 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH V3] futex: add futex_q static initializer
References: <1289250770-16533-1-git-send-email-dvhart@linux.intel.com> <1289252428-18383-1-git-send-email-dvhart@linux.intel.com> <alpine.LFD.2.00.1011082247160.2900@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1011082247160.2900@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2010 01:48 PM, Thomas Gleixner wrote:
> On Mon, 8 Nov 2010, Darren Hart wrote:

>>   /*
>>    * Hash buckets are shared by all the futex_keys that hash to the same
>>    * location.  Each key may have multiple futex_q structures, one for each task
>> @@ -1751,7 +1757,6 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, unsigned int flags,
>>   	 * rare, but normal.
>>   	 */
>>   retry:
>> -	q->key = FUTEX_KEY_INIT;
>
> You sure about that one in the retry path ?
>
>> @@ -1906,11 +1907,7 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned int flags, int detect,
>>   		hrtimer_set_expires(&to->timer, *time);
>>   	}
>>
>> -	q.pi_state = NULL;
>> -	q.rt_waiter = NULL;
>> -	q.requeue_pi_key = NULL;
>>   retry:
>> -	q.key = FUTEX_KEY_INIT;
>
> Ditto

Yes, these are fine. get_futex_key (called immediately after retry: in 
both cases) will set the mm or inode or error out. On error we return 
immediately. No need to zero both.ptr.

Thanks,

-- 
Darren Hart
Embedded Linux Kernel
