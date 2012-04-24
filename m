Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab2DXDRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 23:17:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30256 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450Ab2DXDRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 23:17:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6690"; a="184317711"
Message-ID: <4F961B2F.4060203@codeaurora.org>
Date: Mon, 23 Apr 2012 20:17:03 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] spinlock_debug: Print kallsyms name for lock
References: <1335217525-30709-1-git-send-email-sboyd@codeaurora.org> <1335217525-30709-2-git-send-email-sboyd@codeaurora.org> <20120423145431.617c2b01.akpm@linux-foundation.org>
In-Reply-To: <20120423145431.617c2b01.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/12 14:54, Andrew Morton wrote:
>
>> --- a/lib/spinlock_debug.c
>> +++ b/lib/spinlock_debug.c
>> @@ -58,7 +58,7 @@ static void spin_dump(raw_spinlock_t *lock, const char *msg)
>>  	printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d\n",
>>  		msg, raw_smp_processor_id(),
>>  		current->comm, task_pid_nr(current));
>> -	printk(KERN_EMERG " lock: %p, .magic: %08x, .owner: %s/%d, "
>> +	printk(KERN_EMERG " lock: %ps, .magic: %08x, .owner: %s/%d, "
>>  			".owner_cpu: %d\n",
>>  		lock, lock->magic,
>>  		owner ? owner->comm : "<none>",
> Maybe.  It will only do useful things for statically-allocated locks
> which are rare and which we are unlikely to screw up as easily as locks
> which lie in dynamically allocated memory.

Agreed. It catches the really stupid stuff and that's about it. I was
thinking we could get more information about dynamic allocated locks by
adding some code to slab to find the slab that a pointer is allocated
in. Does that sound possible?

With stacktrace support in slub we could even find the caller who
allocated the storage for the spinlock. It might be useful but one could
argue the stacktrace from this function is already pretty useful for
tracking down which spinlock it is.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

