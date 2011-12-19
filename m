Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab1LSNoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:44:12 -0500
Received: from mx2.parallels.com ([64.131.90.16]:45313 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab1LSNoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:44:10 -0500
Message-ID: <4EEF3F7B.9080405@parallels.com>
Date: Mon, 19 Dec 2011 17:43:23 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the tip tree with the cputime tree
References: <20111219154010.c2044c038a6174dd8fb6f477@canb.auug.org.au> <20111219080813.GB30432@elte.hu> <20111219101134.3c2c0db5@de.ibm.com> <20111219103513.GA17928@elte.hu> <20111219133151.4d14af80@de.ibm.com>
In-Reply-To: <20111219133151.4d14af80@de.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 04:31 PM, Martin Schwidefsky wrote:
> On Mon, 19 Dec 2011 11:35:13 +0100
> Ingo Molnar<mingo@elte.hu>  wrote:
>
>>
>> * Martin Schwidefsky<schwidefsky@de.ibm.com>  wrote:
>>
>>> On Mon, 19 Dec 2011 09:08:13 +0100
>>> Ingo Molnar<mingo@elte.hu>  wrote:
>>>
>>>>
>>>> * Stephen Rothwell<sfr@canb.auug.org.au>  wrote:
>>>>
>>>>> Hi all,
>>>>>
>>>>> Today's linux-next merge of the tip tree got a conflict in
>>>>> fs/proc/uptime.c between commit c3e0ef9a298e ("[S390] fix cputime
>>>>> overflow in uptime_proc_show") from the cputime tree and commit
>>>>> 3292beb340c7 ("sched/accounting: Change cpustat fields to an array") from
>>>>> the tip tree.
>>>>>
>>>>> I fixed it up (I think - see below) and can carry the fix as necessary.
>>>>>
>>>>> Generally, you guys seem to be working a little at cross purposes ...
>>>>
>>>> Agreed.
>>>>
>>>> Martin, could you please send Peter and me a pull request of the
>>>> current cputime bits merged on top of tip:sched/core? Those bits
>>>> should go upstream via the scheduler tree.
>>>>
>>>
>>> All of it including "[S390] cputime: add sparse checking and
>>> cleanup" or just the fix for uptime ?
>>
>> I suspect we can take it all if it's all scheduling/time
>> related, and add new patches to sched/core to keep it all
>> concentrated in a single tree?
>
> Ok, will do. Just one question: are you sure that you want the cpustat array
> to be u64 instead of cputime64_t? The content of the cpustat array is defined
> by the architecture semantics of cputime64_t, for CONFIG_VIRT_CPU_ACCOUNTING=y
> this is not a jiffy counter. If the array is u64 we won't get the sparse
> checking when reading from cpustat.
>

 From where I stand, all I care about is for it to be an array. 
Otherwise the cgroup code get quite messy. At the time, and discussing 
this with peterz, it made sense to change it to u64.

If my mind doesn't fail me, the main reason being it cputime64 is u64 
everywhere, and it was just preventing us from doing simple assignments,
like cpustat[idx] += tmp.

But if for whatever reason you want to move it back to cputime64_t, and 
the maintainers agree so,I am fine with that, as long as you don't 
revert to the old scheme of having a struct filled with fields.



