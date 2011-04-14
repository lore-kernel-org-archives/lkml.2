Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab1DNUsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:48:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:46142 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab1DNUsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:48:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,213,1301900400"; 
   d="scan'208";a="419422634"
Message-ID: <4DA75D75.8050408@linux.intel.com>
Date: Thu, 14 Apr 2011 13:47:49 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Stable <stable@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH V3] futex: set FLAGS_HAS_TIMEOUT during demux for FUTEX_WAIT
References: <58437d290f34f93366114d6ffb7703330477d1e2.1302813580.git.dvhart@linux.intel.com> <1302813795.2744.41.camel@edumazet-laptop>
In-Reply-To: <1302813795.2744.41.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/14/2011 01:43 PM, Eric Dumazet wrote:
> Le jeudi 14 avril 2011 à 13:39 -0700, Darren Hart a écrit :
>> The FLAGS_HAS_TIMEOUT flag was not getting set, causing the restart_block to
>> restart futex_wait() without a timeout after a signal.
>>
>> Commit b41277dc7a18ee332d in 2.6.38 introduced the regression by accidentally
>> removing the the FLAGS_HAS_TIMEOUT assignment from futex_wait() during the setup
>> of the restart block. Restore the originaly behavior.
>>
>> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=32922
>>
>> V2: Added references to commit message.
>> V3: Set flag during restart block instead of do_futex()
>>
>> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
>> Reported-by: Tim Smith <tsmith201104@yahoo.com>
>> Reported-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> CC: Eric Dumazet <eric.dumazet@gmail.com>
>> CC: John Kacur <jkacur@redhat.com>
>> ---
>>  kernel/futex.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/futex.c b/kernel/futex.c
>> index bda4157..9d9c476 100644
>> --- a/kernel/futex.c
>> +++ b/kernel/futex.c
>> @@ -1887,6 +1887,7 @@ retry:
>>  	restart->futex.time = abs_time->tv64;
>>  	restart->futex.bitset = bitset;
>>  	restart->futex.flags = flags;
>> +	flags |= FLAGS_HAS_TIMEOUT;
>>  
>>  	ret = -ERESTART_RESTARTBLOCK;
>>  
> 
> 
> Hmmm, I am sorry but this wont work... please try :
> 
> -	restart->futex.flags = flags;
> +	restart->futex.flags = flags | FLAGS_HAS_TIMEOUT;

Ah crud... now that's just embarrassing... resending.


-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
