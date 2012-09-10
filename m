Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab2IJLix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 07:38:53 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:56852 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab2IJLiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 07:38:50 -0400
X-AuditID: b753bd60-991dcba000000c4c-5f-504dd0bca5f2
X-AuditID: b753bd60-991dcba000000c4c-5f-504dd0bca5f2
Message-ID: <504DD0D0.1040400@hitachi.com>
Date: Mon, 10 Sep 2012 20:36:48 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: jan.kiszka@siemens.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [RFC v2 PATCH 00/21] KVM: x86: CPU isolation and direct interrupts
 delivery to guests
References: <20120906112718.13320.8231.stgit@kvmdev> <5049AFD0.1060700@siemens.com>
In-Reply-To: <5049AFD0.1060700@siemens.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On 2012/09/07 17:26, Jan Kiszka wrote:

> On 2012-09-06 13:27, Tomoki Sekiyama wrote:
>> This RFC patch series provides facility to dedicate CPUs to KVM guests
>> and enable the guests to handle interrupts from passed-through PCI devices
>> directly (without VM exit and relay by the host).
>>
>> With this feature, we can improve throughput and response time of the device
>> and the host's CPU usage by reducing the overhead of interrupt handling.
>> This is good for the application using very high throughput/frequent
>> interrupt device (e.g. 10GbE NIC).
>> Real-time applicatoins also gets benefit from CPU isolation feature, which
>> reduces interfare from host kernel tasks and scheduling delay.
>>
>> The overview of this patch series is presented in CloudOpen 2012.
>> The slides are available at:
>> http://events.linuxfoundation.org/images/stories/pdf/lcna_co2012_sekiyama.pdf
> 
> One question regarding your benchmarks: If you measured against standard
> KVM, were the vCPU thread running on an isolcpus core of its own as
> well? If not, your numbers about the impact of these patches on maximum,
> maybe also average latencies are likely too good. Also, using a non-RT
> host and possibly a non-prioritized vCPU thread for the standard
> scenario looks like an unfair comparison.


In the standard KVM benchmark, the vCPU thread is pinned down to its own
CPU core. In addition, the vCPU thread and irq/*-kvm threads are both set
to the max priority with SCHED_RR policy.

As you said, RT-host may result in better max latencies as below.
(But min/average latencies became worse, however, this might be our setup
 issue.)
                                 Min / Avg / Max latencies
Normal KVM
  RT-host     (3.4.4-rt14)      15us / 21us / 117us
  non RT-host (3.5.0-rc6)        6us / 11us / 152us
KVM + Direct IRQ
  non RT-host (3.5.0-rc6 +patch) 1us /  2us /  14us

Thanks,
-- 
Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory

