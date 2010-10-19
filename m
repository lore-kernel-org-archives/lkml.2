Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933957Ab0JSLMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:12:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39484 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393Ab0JSLMI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:12:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LcrU9dmjkOQYWV2Ew46e4wx0FtG3QGm53HJynO6rDMUsZhWbS3k6Gm4KpRGIa+W+Q3
         22iIVgEbpruokNOhNgIs9DQQXRg/jGkiu5AAVtmf+bZ3B09MsV14DG2Mb8z2k2WRtE68
         rIxfDVS/68xueLZlBBmncbmkfMlW0Gj9GmUVo=
MIME-Version: 1.0
In-Reply-To: <1287486167.1994.1.camel@twins>
References: <AANLkTinoaJX3M2zU_zZOpmFm9Ekxpw-LUVUf_TU8yuSq@mail.gmail.com>
	<1287486167.1994.1.camel@twins>
Date: Tue, 19 Oct 2010 17:12:06 +0600
Message-ID: <AANLkTiku=BcJBQx5Av=Ri+Cd4b+VFY_Y2NL2sd4iQxLM@mail.gmail.com>
Subject: Re: [PATCH] sched_rt: Removes extra checking for nr_cpus_allowed when
 calling find_lowest_rq
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Gregory Haskins <ghaskins@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 5:02 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-10-19 at 16:57 +0600, Rakib Mullick wrote:
>> sched_rt: Removes extra checking for nr_cpus_allowed when calling
>> find_lowest_rq
>
> Why repeat this subject?

Just trying to give a good looking format :-). Not sure whether it
really is or not.
>
>
> That's just not explaining anything.. what can go wrong, how does this
> fix it.

Actually it's not a fix. It just removes a check. It checks whether
this process is movable to other processor or not. And this check is
made from inside the find_lowest_cpu function. Thats why, the check
before calling find_lowest_cpu has been removed. Is my explanation
okay?

Thanks,
Rakib


>
>> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
>> ---
>>
>> --- linus-rc8/kernel/sched_rt.c       2010-10-15 05:26:43.000000000 +0600
>> +++ rakib-rc8/kernel/sched_rt.c       2010-10-19 16:22:30.000000000 +0600
>> @@ -971,8 +971,7 @@ select_task_rq_rt(struct rq *rq, struct
>>        * that is just being woken and probably will have
>>        * cold cache anyway.
>>        */
>> -     if (unlikely(rt_task(rq->curr)) &&
>> -         (p->rt.nr_cpus_allowed > 1)) {
>> +     if (unlikely(rt_task(rq->curr))) {
>>               int cpu = find_lowest_rq(p);
>>
>>               return (cpu == -1) ? task_cpu(p) : cpu;
>
>
