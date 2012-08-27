Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab2H0GoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 02:44:06 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:47562 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2H0GoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 02:44:04 -0400
Message-ID: <503B16DD.8080900@huawei.com>
Date: Mon, 27 Aug 2012 14:42:37 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, PCI <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND BUGFIX PATCH 3/3] PCI: check whether pci device has been
 removed when remove a pci device by sysfs
References: <1344685946-8172-3-git-send-email-wangyijing@huawei.com> <5038A21C.4070200@huawei.com> <5038E3B7.5090601@gmail.com>
In-Reply-To: <5038E3B7.5090601@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.84]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/8/25 22:39, Jiang Liu wrote:
> Hi Yijing,
> 	The patch only patially fix the issue, there exists still small race
> condition window because pdev->is_added isn't a reliable flag to depend on.
> 	--Gerry
> 

Hi Gerry,
    You are right, add pdev->is_added flag check here only fix the race condition window
between remove and rescan sysfs interfaces. Maybe we need a more comprehensive solution to
solve these problems between hotplug/remove/rescan actions.Next, I will do a more detailed test for
[RFC PATCH v1 00/22] introduce PCI bus lock to serialize PCI hotplug operations patches.
That is a more comprehensive solution actually.

---------
Thanks.
Yijing

> On 08/25/2012 05:59 PM, Yijing Wang wrote:
>> We remove a pci device maybe like this
>> echo 1 > /sys/bus/pci/devices/xxxx:xx:xx.x/remove
>> Then remove_store function will be called to complete this remove work,
>> later the remove work will be queued to sysfs_workqueue by device_schedule_callback.
>> So if we remove a pci root port device and a pci endpoint device which was the root
>> port's child device concurrently.The endponit device will be removed when root port's
>> remove work completed,so when endpoint device itself's remove work start, since endpoint
>> device has been removed, it will result to oops.
>> This patch fix this.
>>
>> CallTrace:
>> kworker/u:2[220]: Oops 11003706212352 [1]
>> Modules linked in: cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi
>> _cpufreq binfmt_misc fuse nls_iso8859_1 loop ipmi_si ipmi_devintf ipmi_msghandle
>> r dm_mod igb ppdev iTCO_wdt parport_pc iTCO_vendor_support i2c_i801 parport sg m
>> ptctl serio_raw i2c_core lpc_ich mfd_core hid_generic button container usbhid hi
>> d uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif ext3 mbcache jbd fan pr
>> ocessor ide_pci_generic ide_core ata_piix libata mptsas mptscsih mptbase scsi_tr
>> ansport_sas scsi_mod thermal thermal_sys hwmon


