Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab2LVIDi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 03:03:38 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49160 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2LVIDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 03:03:34 -0500
Date: Sat, 22 Dec 2012 00:03:33 -0800 (PST)
Message-Id: <20121222.000333.912570995569137213.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: hasko.stevo@gmail.com, jhs@mojatatu.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sched: integer overflow fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <1356138997.21834.8185.camel@edumazet-glaptop>
References: <1356138300-16076-1-git-send-email-hasko.stevo@gmail.com>
	<1356138997.21834.8185.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 21 Dec 2012 17:16:37 -0800

> On Sat, 2012-12-22 at 02:04 +0100, Stefan Hasko wrote:
>> Sorry, I did not realize different sizes casting problem, now it's clear to me. Thanks for help.
>> 
>> Fixed integer overflow in function htb_dequeue
>> 
>> Signed-off-by: Stefan Hasko <hasko.stevo@gmail.com>
>> ---
>>  net/sched/sch_htb.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
>> index d2922c0..51561ea 100644
>> --- a/net/sched/sch_htb.c
>> +++ b/net/sched/sch_htb.c
>> @@ -919,7 +919,7 @@ ok:
>>  	q->now = ktime_to_ns(ktime_get());
>>  	start_at = jiffies;
>>  
>> -	next_event = q->now + 5 * NSEC_PER_SEC;
>> +	next_event = q->now + 5LLU * NSEC_PER_SEC;
>>  
>>  	for (level = 0; level < TC_HTB_MAXDEPTH; level++) {
>>  		/* common case optimization - skip event handler quickly */
> 
> I guess David will remove the first line of your changelog
> 
> Acked-by: Eric Dumazet <edumazet@google.com>

Applied.
