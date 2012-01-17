Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab2AQPdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 10:33:35 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57645 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab2AQPde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 10:33:34 -0500
MIME-Version: 1.0
In-Reply-To: <20120117095056.GF10397@elte.hu>
References: <1326389222.9115.2.camel@localhost.localdomain>
	<20120116075639.GG15641@elte.hu>
	<CADZ9YHjxuqJ2YpEonqXjRsJZGsihy7ao_cA-NRwXoOM1KF3Tpw@mail.gmail.com>
	<20120116083615.GB23622@elte.hu>
	<CADZ9YHh9rnTom8dRk5PBdY0Qu6WQVNpUr2jJDeyqg7fxTiu1gg@mail.gmail.com>
	<20120117095056.GF10397@elte.hu>
Date: Tue, 17 Jan 2012 21:33:33 +0600
Message-ID: <CADZ9YHhA7BO+zRJdJvpSWuGdK316A07gNS5g3Ty=2ZpxZ--N5w@mail.gmail.com>
Subject: Re: [PATCH] sched: Update scheduler stat documentation.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 3:50 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Rakib Mullick <rakib.mullick@gmail.com> wrote:
>
>> On Mon, Jan 16, 2012 at 2:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> >
>> > Yes - but we should also change it to export a value of zero.
>> > The field is a legacy 'array expirations' field, and as such it
>> > should be zero.
>> >
>>
>> Ok, thanks for suggestions. Please, look at the following patch, it's
>> been roughly created to address your suggestion. If it looks okay,
>> then I can send formal patch (perhaps two separate patches?). In this
>> way, I think we can also remove rq->sched_switch field (not done in
>> this patch)?
>>
>> diff --git a/Documentation/scheduler/sched-stats.txt
>> b/Documentation/scheduler/sched-stats.txt
>> index 1cd5d51..cc2d107 100644
>> --- a/Documentation/scheduler/sched-stats.txt
>> +++ b/Documentation/scheduler/sched-stats.txt
>> @@ -38,7 +38,8 @@ First field is a sched_yield() statistic:
>>       1) # of times sched_yield() was called
>>
>>  Next three are schedule() statistics:
>> -     2) # of times we switched to the expired queue and reused it
>> +     2) This field is a legacy array expiration field used in O(1) scheduler.
>> +     But still kept for ABI integrity.
>
> I'd formulate it like this:
>
>> +     2) This field is a legacy array expiration count field
>> +        used in the O(1) scheduler. We kept it for ABI
>> +        compatibility, but it is always set to zero.
>
Okay, I'll take the above description.

>
>> +             int rq_sched_switch = 0;
>>  #ifdef CONFIG_SMP
>>               struct sched_domain *sd;
>>               int dcount = 0;
>> @@ -34,7 +35,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
>>               seq_printf(seq,
>>                   "cpu%d %u %u %u %u %u %u %llu %llu %lu",
>>                   cpu, rq->yld_count,
>> -                 rq->sched_switch, rq->sched_count, rq->sched_goidle,
>> +                 rq_sched_switch, rq->sched_count, rq->sched_goidle,
>
> printf can print a 0 value just fine as part of the format
> string ... :-)
>
Umm... actually, I thought using a variable would have been nice to
indicate it's purpose rather straightly putting 0. Anyway, will change
it.

> But yeah, this logic is what i had in mind.
>
I was confused what you asked for cause present code returns 0 too.
Now got it, will send a patch shortly.

Thanks,
Rakib

> Thanks,
>
>        Ingo
