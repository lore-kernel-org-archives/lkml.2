Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab2E2Acb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 20:32:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33100 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2E2Ac3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 20:32:29 -0400
Message-ID: <4FC41903.1060705@gmail.com>
Date: Tue, 29 May 2012 08:32:03 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@kernel.org,
        torvalds@linux-foundation.org, cmetcalf@tilera.com,
        tony.luck@intel.com, sivanich@sgi.com, akpm@linux-foundation.org,
        ralf@linux-mips.org, greg.pearson@hp.com, ink@jurassic.park.msu.ru,
        tglx@linutronix.de, rth@twiddle.net, kamezawa.hiroyu@jp.fujitsu.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        anton@samba.org, lethal@linux-sh.org, davem@davemloft.net,
        benh@kernel.crashing.org, dhowells@redhat.com, mattst88@gmail.com,
        fenghua.yu@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched/numa: Rewrite the CONFIG_NUMA sched domain
 support
References: <tip-r74n3n8hhuc2ynbrnp3vt954@git.kernel.org> <CAE9FiQWat=55Ygp-f6ovJx+CD=Knjic9Xvpp+Ngf-o19zNUy7g@mail.gmail.com> <1336671883.27020.128.camel@laptop> <CAE9FiQWB23V=XoyzQaq1X+JNtUcV=4bLQ1sGCMOTjKRqAV7XuQ@mail.gmail.com>
In-Reply-To: <CAE9FiQWB23V=XoyzQaq1X+JNtUcV=4bLQ1sGCMOTjKRqAV7XuQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,
	Does this patch fix your issue? https://lkml.org/lkml/2012/5/9/183.
I have encountered a similar issue on an IA64 platform and the patch above 
works around it. But the root cause is a BIOS bug that the order of CPUs 
in MADT table doesn't conform to the ACPI specification and the first CPU 
in MADT is not the BSP, which breaks some assumption of the booting code
and causes the core dump.
	Thanks!

On 05/11/2012 01:54 AM, Yinghai Lu wrote:
> On Thu, May 10, 2012 at 10:44 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> On Thu, 2012-05-10 at 10:30 -0700, Yinghai Lu wrote:
>>> not sure if this one or other is related....
>>>
>>> got this from 8 socket Nehalem-ex box.
>>>
>>> [   25.549259] mtrr_aps_init() done
>>> [   25.554298] ------------[ cut here ]------------
>>> [   25.554549] WARNING: at kernel/sched/core.c:6086 build_sched_domains+0x1a9/0x2d0()
>>
>> oops,.. could you get me the output of:
>>
>>  cat /sys/devices/system/node/node*/distance
>>
>> for that machine? I'll see if I can reproduce using numa=fake.
> 
> [    0.000000] ACPI: SLIT: nodes = 8
> [    0.000000]    10 15 20 15 15 20 20 20
> [    0.000000]    15 10 15 20 20 15 20 20
> [    0.000000]    20 15 10 15 20 20 15 20
> [    0.000000]    15 20 15 10 20 20 20 15
> [    0.000000]    15 20 20 20 10 15 15 20
> [    0.000000]    20 15 20 20 15 10 20 15
> [    0.000000]    20 20 15 20 15 20 10 15
> [    0.000000]    20 20 20 15 20 15 15 10
> 
> 
> [root@yhlu-pc2 ~]# cat /sys/devices/system/node/node*/distance
> 10 15 15 20 15 20 20 20
> 15 10 20 15 20 15 20 20
> 15 20 10 15 20 20 15 20
> 20 15 15 10 20 20 20 15
> 15 20 20 20 10 15 20 15
> 20 15 20 20 15 10 15 20
> 20 20 15 20 20 15 10 15
> 20 20 20 15 15 20 15 10
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

