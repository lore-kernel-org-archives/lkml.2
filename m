Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab2EEF7K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 01:59:10 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62781 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab2EEF7I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 01:59:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo4EGWndS0c_6SZrCz_O=3WmfZoRoRrU=9AN5TG3QfxHbg@mail.gmail.com>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com>
	<1336119221-21146-2-git-send-email-ying.huang@intel.com>
	<CAErSpo4EGWndS0c_6SZrCz_O=3WmfZoRoRrU=9AN5TG3QfxHbg@mail.gmail.com>
Date: Sat, 5 May 2012 13:59:07 +0800
Message-ID: <CAC=cRTPfkw5tQHLbACyJey1MKV=fTZiV_NqKKicgksXEF5QRpQ@mail.gmail.com>
Subject: Re: [RFC v2 1/5] PM, Runtime, Add power_must_be_on flag
From: huang ying <huang.ying.caritas@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Huang Ying <ying.huang@intel.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Zheng Yan <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 5, 2012 at 3:50 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, May 4, 2012 at 2:13 AM, Huang Ying <ying.huang@intel.com> wrote:
>> --- a/include/linux/pm.h
>> +++ b/include/linux/pm.h
>> @@ -536,6 +536,7 @@ struct dev_pm_info {
>>        unsigned int            irq_safe:1;
>>        unsigned int            use_autosuspend:1;
>>        unsigned int            timer_autosuspends:1;
>> +       unsigned int            power_must_be_on:1;
>>        enum rpm_request        request;
>>        enum rpm_status         runtime_status;
>>        int                     runtime_error;
>
> It's a little weird to just add the field, with no users.  Would it
> make sense to pull out the bits of patch 5 that use this and combine
> them into a single smaller patch?

This patch is needed by some other subsystem too, such as ZPODD
support in following patchset:

https://lkml.org/lkml/2012/3/28/23

The original plan is to merge this into linux-pm.git firstly, then
merge various usage of this flag into various subsystem git tree.
That will make cross-tree merging a little easier.  Is it possible?

> But see related comments there; it
> might be safer to have a function that computes this whenever you need
> it instead of caching the value.

This flag may be used (or calculated if implemented as a function)
when device is in suspended state.  Reason is as follow from the
changelog of this patch.

"
In general, whether to put a device into power off state should be
decided by the driver of the device, but for some buses, whether to
put a device into power off state may be done by the parent of the
device.  For example, a PCIe end point device may be put into power
off state by the PCIe port connected to it.
"

If all devices can calculate "power_must_be_on" when it is in
suspended state, then this will be a design choice.

Hi, Rafael,

What do you think about the idea to replace .power_must_be_on with a
function (maybe add a new callback in pm_ops)?

Best Regards,
Huang Ying
