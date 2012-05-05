Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab2EEGg0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 02:36:26 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53250 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751133Ab2EEGgY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 02:36:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7yRWCWKrd93AJ3b1VZW-_gWeJgru4cfHN7cp3wFmW96w@mail.gmail.com>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com>
	<1336119221-21146-3-git-send-email-ying.huang@intel.com>
	<CAErSpo7yRWCWKrd93AJ3b1VZW-_gWeJgru4cfHN7cp3wFmW96w@mail.gmail.com>
Date: Sat, 5 May 2012 14:36:23 +0800
Message-ID: <CAC=cRTNedUZgefQjyQ1L-nY8O2=UcgmEkjVwdL9JCCMgVJqwKg@mail.gmail.com>
Subject: Re: [RFC v2 2/5] PM, Add sysfs file power_off to control device power
 off policy
From: huang ying <huang.ying.caritas@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Huang Ying <ying.huang@intel.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Zheng Yan <zheng.z.yan@intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 5, 2012 at 3:50 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, May 4, 2012 at 2:13 AM, Huang Ying <ying.huang@intel.com> wrote:
>> From: Lan Tianyu <tianyu.lan@intel.com>
>>
>> Some devices can be powered off to save more power via some platform
>> mechanism, e.g., ACPI.  But that may not work as expected for some
>> device or platform.  So, this patch adds a sysfs file named power_off
>> under <device>/power directory to provide a mechanism for user to control
>> whether to allow the device to be power off.
>>
>> power_off => "enabled" means allowing the device to be powered off if
>> possible.
>>
>> power_off => "disabled" means the device must be power on anytime.
>>
>> Also add flag power_off_user to struct dev_pm_info to record users'
>> choice. The bus layer can use this field to determine whether to
>> power off the device.
>
> My first thought was that writing to "power_off" would actually turn
> the power off, which isn't true.  Maybe something like
> "poweroff_allowed" would work.

Yes. "power_off" is not a good name.  "poweroff_allowed" is much better.

> I think there's only one use of this new field, in
> pci_pm_runtime_suspend().  Maybe you could pull out that hunk from
> patch 5, combine it with this one, and move it to after patch 5?

This will be used by various places, such as ZPODD support, power domain, etc.

Best Regards,
Huang Ying
