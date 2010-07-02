Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab0GBKUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 06:20:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33378 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab0GBKUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 06:20:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=QjpKIWwSi1eacnnoAReWRntRyzvqe0wz+6Z+2BOW/t9kz3NF0nw/IX/haUy6zNwnwB
         h8ow0c6IYXdwWeY1eQcCCS21XU+avdRiT8I9K3JZv+bsif1kjjIPzc7DZUwLB3SN6irt
         xRliObCc1QUWDVVKu1W9LEudHgQfi5NbMNmfY=
MIME-Version: 1.0
In-Reply-To: <20100702090801.GG10072@secunet.com>
References: <20100629203939.29a0b4ff@leibniz>
	<20100630124742.GD10072@secunet.com>
	<AANLkTimSgp_5LwfvECaAFnW-_UwxwsYVEjKcZTDIHadx@mail.gmail.com>
	<20100702090801.GG10072@secunet.com>
Date: Fri, 2 Jul 2010 14:20:15 +0400
X-Google-Sender-Auth: YFYDbL78-G-Ah5V7WaKC4Tf0HGI
Message-ID: <AANLkTinFqMtdfvbYDIGjQHoWa3dmUuruTvxG-upUU-7S@mail.gmail.com>
Subject: Re: [PATCH 2/2] pcrypt: sysfs interface
From: Dan Kruchinin <dkruchinin@acm.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 2, 2010 at 1:08 PM, Steffen Klassert
<steffen.klassert@secunet.com> wrote:
> On Thu, Jul 01, 2010 at 06:28:34PM +0400, Dan Kruchinin wrote:
>> >
>> > These statistic counters add a lot of atomic operations to the fast-path.
>> > Would'nt it be better to have these statistics in a percpu manner?
>> > This would avoid the atomic operations and we would get some additional
>> > information on the distribution of the queued objects.
>> >
>>
>> If I understood you correctly the resulting sysfs hierarchy would look like
>> this one:
>> pcrypt/
>> |- serial_cpumask
>> |- parallel_cpumask
>> |- w0/
>> +--- parallel_objects
>> +--- serial_objects
>> +--- reorder_objects
>> |- w1/
>> ...
>> |- wN/
>>
>> right? If so I think it won't be very convenient to monitor summary number
>> of parallel, serial and reorder objects.
>
> Yes, I thought about something like this. You can still take the sum
> over the percpu objects when you output the statistics.

But summation can not be clear without some kind of lock because
while we're summing another CPU can increase or decrease its percpu statistic
counters. Then each statistic percpu counter must be modified under lock, right?

>
>
>> Anyway I think these atomic operations take very small time in comparison
>> with other operations in padata. So small that it can be ignored.
>
> I have a patch in queue that simplifies the serialization mechanism and
> reduces the accesses of foreign and global memory as much as possible
> in the parallel codepath. Adding atomic operations to global memory
> (just to collect statistics) to the parallel codepath would go in the
> opposite direction.
>
> Steffen
>



-- 
W.B.R.
Dan Kruchinin
