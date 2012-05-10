Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249Ab2EJRyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:54:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52968 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2EJRyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:54:20 -0400
MIME-Version: 1.0
In-Reply-To: <1336671883.27020.128.camel@laptop>
References: <tip-r74n3n8hhuc2ynbrnp3vt954@git.kernel.org>
	<CAE9FiQWat=55Ygp-f6ovJx+CD=Knjic9Xvpp+Ngf-o19zNUy7g@mail.gmail.com>
	<1336671883.27020.128.camel@laptop>
Date: Thu, 10 May 2012 10:54:19 -0700
X-Google-Sender-Auth: k-R2ZvGnUyyTB-TJCX4K46gb6gg
Message-ID: <CAE9FiQWB23V=XoyzQaq1X+JNtUcV=4bLQ1sGCMOTjKRqAV7XuQ@mail.gmail.com>
Subject: Re: [tip:sched/core] sched/numa: Rewrite the CONFIG_NUMA sched domain support
From: Yinghai Lu <yinghai@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, cmetcalf@tilera.com,
        tony.luck@intel.com, sivanich@sgi.com, akpm@linux-foundation.org,
        ralf@linux-mips.org, greg.pearson@hp.com, ink@jurassic.park.msu.ru,
        tglx@linutronix.de, rth@twiddle.net, kamezawa.hiroyu@jp.fujitsu.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        anton@samba.org, lethal@linux-sh.org, davem@davemloft.net,
        benh@kernel.crashing.org, dhowells@redhat.com, mattst88@gmail.com,
        fenghua.yu@intel.com, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 10:44 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2012-05-10 at 10:30 -0700, Yinghai Lu wrote:
>> not sure if this one or other is related....
>>
>> got this from 8 socket Nehalem-ex box.
>>
>> [   25.549259] mtrr_aps_init() done
>> [   25.554298] ------------[ cut here ]------------
>> [   25.554549] WARNING: at kernel/sched/core.c:6086 build_sched_domains+0x1a9/0x2d0()
>
> oops,.. could you get me the output of:
>
>  cat /sys/devices/system/node/node*/distance
>
> for that machine? I'll see if I can reproduce using numa=fake.

[    0.000000] ACPI: SLIT: nodes = 8
[    0.000000]    10 15 20 15 15 20 20 20
[    0.000000]    15 10 15 20 20 15 20 20
[    0.000000]    20 15 10 15 20 20 15 20
[    0.000000]    15 20 15 10 20 20 20 15
[    0.000000]    15 20 20 20 10 15 15 20
[    0.000000]    20 15 20 20 15 10 20 15
[    0.000000]    20 20 15 20 15 20 10 15
[    0.000000]    20 20 20 15 20 15 15 10


[root@yhlu-pc2 ~]# cat /sys/devices/system/node/node*/distance
10 15 15 20 15 20 20 20
15 10 20 15 20 15 20 20
15 20 10 15 20 20 15 20
20 15 15 10 20 20 20 15
15 20 20 20 10 15 20 15
20 15 20 20 15 10 15 20
20 20 15 20 20 15 10 15
20 20 20 15 15 20 15 10
