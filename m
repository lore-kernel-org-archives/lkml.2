Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab2EEFP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 01:15:59 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45715 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2EEFP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 01:15:57 -0400
MIME-Version: 1.0
In-Reply-To: <201205042137.16425.rjw@sisk.pl>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com>
	<1336119221-21146-2-git-send-email-ying.huang@intel.com>
	<201205042137.16425.rjw@sisk.pl>
Date: Sat, 5 May 2012 13:15:56 +0800
Message-ID: <CAC=cRTOpbbHCSXN3=JKZkpy753G0-Vgbu0DkbV-v_coVMM7Qzw@mail.gmail.com>
Subject: Re: [RFC v2 1/5] PM, Runtime, Add power_must_be_on flag
From: huang ying <huang.ying.caritas@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Huang Ying <ying.huang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Zheng Yan <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 5, 2012 at 3:37 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, May 04, 2012, Huang Ying wrote:
>> The extreme way to save device power in runtime is to turn off power
>> of device.  For example, D3cold for PCIe bus and ZPODD (Zero Power
>> Optical Disk Drive) for SATA bus will do that.
>>
>> But sometimes power off is not expected, some possible reason is as
>> follow
>>
>> - power off device usually incurs longer resume latency, if it exceeds
>>   power QoS requirement, power off should be disabled.
>>
>> - For some buses, device in power off state can not support remote
>>   wakeup.  If remote wakeup is desired, power off should be disabled.
>>
>> In general, whether to put a device into power off state should be
>> decided by the driver of the device, but for some buses, whether to
>> put a device into power off state may be done by the parent of the
>> device.  For example, a PCIe end point device may be put into power
>> off state by the PCIe port connected to it.
>>
>> So a flag is introduced for the children devices to tell the parent
>> device, whether it should be put into power off state.
>>
>> This flag is also used for device driver to tell bus layer whether it
>> is OK to be powered off.
>>
>> Signed-off-by: Huang Ying <ying.huang@intel.com>
>
> I would be almost fine with this patch, if [2/5] were not present.
>
> However, if you introduce a flag like this, you need to put checks
> against it into all places where power may be removed from devices,
> like the generic PM domains framework (but not only there).

Yes.  At least this flag will be needed by other buses, like ZPODD
support from Lin Ming:

https://lkml.org/lkml/2012/3/28/23

So my original plan is to introduce this flag firstly, then to add
checking for this flag in various places need it.  Do you suggest to
put PCIe D3cold support, ZPODD support, power domain related checking
into one patchset.

Best Regards,
Huang Ying
