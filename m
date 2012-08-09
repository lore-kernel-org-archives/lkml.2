Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031078Ab2HIPZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:25:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51795 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758235Ab2HIPZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:25:00 -0400
Message-ID: <5023D63F.1080502@gmail.com>
Date: Thu, 09 Aug 2012 23:24:47 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Toshi Kani <toshi.kani@hp.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Tony Luck <tony.luck@intel.com>, Huang Ying <ying.huang@intel.com>,
        Bob Moore <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/16] ACPI based system device hotplug framework
References: <1344082443-4608-1-git-send-email-jiang.liu@huawei.com> <1344382695.3010.770.camel@misato.fc.hp.com> <50228968.3070904@gmail.com> <CAErSpo7S0zuU=tSJVzxk8cPjop0B+JKJjkM46sFCirJCX9KQ2g@mail.gmail.com>
In-Reply-To: <CAErSpo7S0zuU=tSJVzxk8cPjop0B+JKJjkM46sFCirJCX9KQ2g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 12:27 AM, Bjorn Helgaas wrote:
> On Wed, Aug 8, 2012 at 8:44 AM, Jiang Liu <liuj97@gmail.com> wrote:
>> On 08/08/2012 07:38 AM, Toshi Kani wrote:
> 
>>> It is nice to see redundant ACPI namespace walks removed from the ACPI
>>> drivers.  But why do you need to add a new enumerator to create the
>>> acpihp_slot tree, in addition to the current acpi_device tree?  I'd
>>> prefer hotplug features to be generally integrated into the current ACPI
>>> core code and data structures, instead of adding a new layer on top of
>>> it.
>> The idea comes from PCI hotplug framework, which has an concepts of PCI
>> hotplug slot and PCI device. For system device hotplug, we could follow
>> the same model as PCI by abstracting control points as slots. By introducing
>> of hotplug slot, we could:
>>
>> 1) Report all hotplug slots and slot's capabilities to user, no matter whether
>> there are devices connecting to a slot. If we integrate hotplug functionality
>> into current ACPI device tree, the slot (or device) is only visible when the
>> connected devices are enabled.
> 
> In PCI, the idea of a slot is a pretty explicit -- you can look at the
> capabilities of a bridge device and see whether it supports hot-add of
> a device below it.  Is it the same way in ACPI?  My impression is that
> it is not: there will be a parent ACPI device under which a new device
> can be added, but you might not be able to tell by looking at the
> parent device that hot-add is possible.  I thought the platform could
> just give us a Notify event on the parent, asking us to rescan the
> namespace below it and potentially discover new devices.
> 
Hi Bjorn,
	You are right. With current ACPI V5 specification, we can't get the slot
information from the ACPI namespace, and could only guess that a device with _EJ0
supports hot-add/hot-remove.
	Realized that limitation, there's ongoing effort to provide ACPI hotplug
slot (or platform RAS capabilities) information to OS through static ACPI tables,
so OS could enable hotplug and reserve enough resources for system device hotplug.
If that static ACPI table is available, we could construct ACPI hotplug slots from
it.
	Regards!
	Gerry
