Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab0CZXvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 19:51:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:35576 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab0CZXvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 19:51:05 -0400
Message-ID: <4BAD47F6.3000003@kernel.org>
Date: Fri, 26 Mar 2010 16:49:10 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Ian Campbell <ian.campbell@citrix.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 03/24] x86: Do not free zero sized per cpu areas
References: <1269642114-16588-1-git-send-email-yinghai@kernel.org> <1269642114-16588-4-git-send-email-yinghai@kernel.org> <20100326234203.GD29222@cmpxchg.org>
In-Reply-To: <20100326234203.GD29222@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2010 04:42 PM, Johannes Weiner wrote:
> On Fri, Mar 26, 2010 at 03:21:33PM -0700, Yinghai Lu wrote:
>> From: Ian Campbell <ian.campbell@citrix.com>
>>
>> This avoids an infinite loop in free_early_partial().
>>
>> Add a warning to free_early_partial to catch future problems.
>>
>> -v5: put back start > end back into WARN_ONCE()
>> -v6: use one line for warning according to linus
>> -v7: more test by
>>
>> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Tested-by: Joel Becker <joel.becker@oracle.com>
>> Tested-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> ---
>>  kernel/early_res.c |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/early_res.c b/kernel/early_res.c
>> index 3cb2c66..69bed5b 100644
>> --- a/kernel/early_res.c
>> +++ b/kernel/early_res.c
>> @@ -333,6 +333,12 @@ void __init free_early_partial(u64 start, u64 end)
>>  	struct early_res *r;
>>  	int i;
>>  
>> +	if (start == end)
>> +		return;
>> +
>> +	if (WARN_ONCE(start > end, "free_early_partial: wrong range [%#llx, %#llx]\n", start, end))
>> +		return;
> 
> I think you can drop the function name, it will be in the stack dump
> anyway.  And that would get the line back into bounds :)
> 
> Other than that,
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks.

is there any chance that dump stack only print out address instead of function name ?

BTW, kernel/early_res.c will be replaced by lmb.c

Yinghai
