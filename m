Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab1JYHZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:25:22 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:55883 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1JYHZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:25:21 -0400
Message-ID: <4EA6645C.2010408@scalemp.com>
Date: Tue, 25 Oct 2011 09:25:16 +0200
From: Eial Czerwacki <eial@scalemp.com>
Organization: ScaleMP
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.11) Gecko/20101020 Remi/fc8 Thunderbird/3.1.5
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Subject: Re: [PATCH] Move mostly read variables to __read_mostly section.
References: <4EA45BB8.20505@scalemp.com> <m2sjmj572m.fsf@firstfloor.org>
In-Reply-To: <m2sjmj572m.fsf@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2011 06:47 AM, Andi Kleen wrote:
> Eial Czerwacki<eial@scalemp.com>  writes:
>>    * Once the number of bh's in the machine exceeds this level, we start
>> --- a/kernel/time/timekeeping.c	2010-05-12 14:59:32.000000000 -0700
>> +++ b/kernel/time/timekeeping.c	2010-05-24 11:56:32.000000000 -0700
>> @@ -154,7 +154,7 @@ __cacheline_aligned_in_smp DEFINE_SEQLOC
>>    * used instead.
>>    */
>>   static struct timespec xtime __attribute__ ((aligned (16)));
>> -static struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
>> +static struct timespec wall_to_monotonic __attribute__ ((aligned
>>    (16))) __read_mostly;
>
> That means that a common time fetch/update call will usually have to fetch two
> cachelines now instead of one, because it needs xtime and
> wall_to_monotonic. Usually those end up nearby.
>
> On the other hand it's rare to fetch wall_to_monotonic without xtime.
>
> So if anything all those variables should be grouped together in a
> single cacheline, but definitely not split like you do.
>
> The other changes in your patch are fine for me.
>
> -Andi
Hello Andi,

Thanks for the input, we've removed the mentioned above section from the 
patch and it will be handled in a different patch.

the new patch is as follows:

Signed-off-by: Eial Czerwacki<eial@ScaleMP.com>
Signed-off-by: Shai Fultheim<Shai@ScaleMP.com>
---

--- a/fs/buffer.c	2010-05-12 14:59:32.000000000 -0700
+++ b/fs/buffer.c	2010-05-24 11:56:32.000000000 -0700
@@ -3233,7 +3233,7 @@ SYSCALL_DEFINE2(bdflush, int, func, long
  /*
   * Buffer-head allocation
   */
-static struct kmem_cache *bh_cachep;
+static struct kmem_cache __read_mostly *bh_cachep;

  /*
   * Once the number of bh's in the machine exceeds this level, we start


