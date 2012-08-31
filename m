Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab2HaHM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 03:12:27 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56477 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2HaHM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 03:12:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLEPh4PH-jV-S7jPZExg0r_YsqL+2tHErRtA7bpygbP6iQ@mail.gmail.com>
References: <1345540117-14164-1-git-send-email-zheng.z.yan@intel.com>
	<CAOJsxLEPh4PH-jV-S7jPZExg0r_YsqL+2tHErRtA7bpygbP6iQ@mail.gmail.com>
Date: Fri, 31 Aug 2012 10:12:24 +0300
X-Google-Sender-Auth: BWlLGQ09C3q83gVc-7jSxaCAn9I
Message-ID: <CAOJsxLG7K=Xua+=EVCDmT1JJ1MAudHGEz123EHX2CsHmasBooQ@mail.gmail.com>
Subject: Re: [PATCH] perf/x86: Disable uncore on virtualized CPU.
From: Pekka Enberg <penberg@kernel.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: a.p.zijlstra@chello.nl, eranian@google.com, mingo@elte.hu,
        andi@firstfloor.org, avi@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 12:08 PM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>>
>> Initializing uncore PMU on virtualized CPU may hang the kernel.
>> This is because kvm does not emulate the entire hardware. Thers
>> are lots of uncore related MSRs, making kvm enumerate them all
>> is a non-trival task. So just disable uncore on virtualized CPU.
>>
>> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
>> ---
>>  arch/x86/kernel/cpu/perf_event_intel_uncore.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> index 0a55710..2f005ba 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> @@ -2898,6 +2898,9 @@ static int __init intel_uncore_init(void)
>>         if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
>>                 return -ENODEV;
>>
>> +       if (cpu_has_hypervisor)
>> +               return -ENODEV;
>> +
>>         ret = uncore_pci_init();
>>         if (ret)
>>                 goto fail;

On Tue, Aug 21, 2012 at 3:55 PM, Pekka Enberg <penberg@kernel.org> wrote:
> Tested-by: Pekka Enberg <penberg@kernel.org>

Ping? I have not seen a tip bot email for this. Is the patch queued?
