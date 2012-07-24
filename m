Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab2GXGAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 02:00:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:40024 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab2GXGAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 02:00:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="172341576"
Message-ID: <500E39E2.6020604@intel.com>
Date: Tue, 24 Jul 2012 14:00:02 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: a.p.zijlstra@chello.nl, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V6 05/13] perf: Generic intel uncore support
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com> <1339741902-8449-6-git-send-email-zheng.z.yan@intel.com> <CABPqkBS8SULKGw5gvWd4fTup7NyrvsaM1ZejCtsq4ChCPEwXHg@mail.gmail.com>
In-Reply-To: <CABPqkBS8SULKGw5gvWd4fTup7NyrvsaM1ZejCtsq4ChCPEwXHg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...snip...]
>> +
>> +static int __init intel_uncore_init(void)
>> +{
>> +       int ret;
>> +
>> +       if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
>> +               return -ENODEV;
>> +
>> +       ret = uncore_cpu_init();
>> +       if (ret)
>> +               goto fail;
>> +
>> +       uncore_pmus_register();
>> +       return 0;
>> +fail:
>> +       return ret;
>> +}
>> +device_initcall(intel_uncore_init);
> 
> 
> You cannot use device_initcall() here. Otherwise you're subject
> to linker ordering issues between intel_uncore_init() and the
> perf_event_sysfs_init() initcall. You need the perf_event sysfs
> support to be enabled BEFORE you init the uncore otherwise you
> won't see the uncore sysfs entries. Given how perf now relies on
> sysfs to parse the event, this is a showstopper.

I think the ordering makes no matter. perf_event_sysfs_init() checks
PMUs that were registered previously and allocates sysfs entries for
them.

Regards
Yan, Zheng
