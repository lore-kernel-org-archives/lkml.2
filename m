Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab1GZGOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 02:14:40 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35678 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab1GZGOg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 02:14:36 -0400
MIME-Version: 1.0
In-Reply-To: <4E2E507F.7030607@jp.fujitsu.com>
References: <1311599418-1915-1-git-send-email-yong.zhang0@gmail.com>
	<4E2E507F.7030607@jp.fujitsu.com>
Date: Tue, 26 Jul 2011 14:14:35 +0800
Message-ID: <CAM2zO=CGkVCMNZS8F6LxFi-NdYXf0fDLB_AEc00xrPvO_D02qw@mail.gmail.com>
Subject: Re: [PATCH] proc/softirqs: only show state for online cpus
From: Yong Zhang <yong.zhang0@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kobayashi.kk@ncos.nec.co.jp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/26 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
>> Like /proc/interrupts, no need to output data for nobody.
>>
>> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
> If the cpu never be onlined, its statistics always 0. Then, it definitely

Yeah, so your screen may contain noise.

> no value. In the other hand, if the cpu was offlined dynamically, we don't
> know the user want to know the cpus's statistics or not.

Same to /proc/interrupts :)

IMHO, if user want to check the value of offline-cpu, maybe that means
he want to check the state of the whole system, /proc/stat should be the
right choice. /proc/{softirqs,interrupts} is just for immediate state.

>
> Anyway, it's incompatibility change.

Yup, I should have marked the patch with RFC :)

Thanks,
Yong

> I don't think this is valuable change.
>
>
>> ---
>>  fs/proc/softirqs.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/proc/softirqs.c b/fs/proc/softirqs.c
>> index 62604be..2b32b46 100644
>> --- a/fs/proc/softirqs.c
>> +++ b/fs/proc/softirqs.c
>> @@ -11,13 +11,13 @@ static int show_softirqs(struct seq_file *p, void *v)
>>       int i, j;
>>
>>       seq_puts(p, "                    ");
>> -     for_each_possible_cpu(i)
>> +     for_each_online_cpu(i)
>>               seq_printf(p, "CPU%-8d", i);
>>       seq_putc(p, '\n');
>>
>>       for (i = 0; i < NR_SOFTIRQS; i++) {
>>               seq_printf(p, "%12s:", softirq_to_name[i]);
>> -             for_each_possible_cpu(j)
>> +             for_each_online_cpu(j)
>>                       seq_printf(p, " %10u", kstat_softirqs_cpu(i, j));
>>               seq_putc(p, '\n');
>>       }
>
>
>



-- 
Only stand for myself
