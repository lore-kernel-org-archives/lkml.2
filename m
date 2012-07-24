Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab2GXGVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 02:21:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36187 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab2GXGV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 02:21:29 -0400
MIME-Version: 1.0
In-Reply-To: <500E39E2.6020604@intel.com>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
	<1339741902-8449-6-git-send-email-zheng.z.yan@intel.com>
	<CABPqkBS8SULKGw5gvWd4fTup7NyrvsaM1ZejCtsq4ChCPEwXHg@mail.gmail.com>
	<500E39E2.6020604@intel.com>
Date: Tue, 24 Jul 2012 08:21:28 +0200
Message-ID: <CABPqkBRcmZDKPN9RpR7TKAPC4orvCxd232Tt0QQt1mhzXVUfhA@mail.gmail.com>
Subject: Re: [PATCH V6 05/13] perf: Generic intel uncore support
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 8:00 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> [...snip...]
>>> +
>>> +static int __init intel_uncore_init(void)
>>> +{
>>> +       int ret;
>>> +
>>> +       if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
>>> +               return -ENODEV;
>>> +
>>> +       ret = uncore_cpu_init();
>>> +       if (ret)
>>> +               goto fail;
>>> +
>>> +       uncore_pmus_register();
>>> +       return 0;
>>> +fail:
>>> +       return ret;
>>> +}
>>> +device_initcall(intel_uncore_init);
>>
>>
>> You cannot use device_initcall() here. Otherwise you're subject
>> to linker ordering issues between intel_uncore_init() and the
>> perf_event_sysfs_init() initcall. You need the perf_event sysfs
>> support to be enabled BEFORE you init the uncore otherwise you
>> won't see the uncore sysfs entries. Given how perf now relies on
>> sysfs to parse the event, this is a showstopper.
>
> I think the ordering makes no matter. perf_event_sysfs_init() checks
> PMUs that were registered previously and allocates sysfs entries for
> them.
>
You're right, seems like I had a bad kernel that caused the problem
to happen.
Thanks for checking.
