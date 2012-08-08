Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab2HHQ1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 12:27:32 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43961 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758813Ab2HHQ13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:27:29 -0400
MIME-Version: 1.0
In-Reply-To: <50228968.3070904@gmail.com>
References: <1344082443-4608-1-git-send-email-jiang.liu@huawei.com>
 <1344382695.3010.770.camel@misato.fc.hp.com> <50228968.3070904@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 8 Aug 2012 09:27:07 -0700
Message-ID: <CAErSpo7S0zuU=tSJVzxk8cPjop0B+JKJjkM46sFCirJCX9KQ2g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/16] ACPI based system device hotplug framework
To: Jiang Liu <liuj97@gmail.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Jiang Liu <jiang.liu@huawei.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 8:44 AM, Jiang Liu <liuj97@gmail.com> wrote:
> On 08/08/2012 07:38 AM, Toshi Kani wrote:

>> It is nice to see redundant ACPI namespace walks removed from the ACPI
>> drivers.  But why do you need to add a new enumerator to create the
>> acpihp_slot tree, in addition to the current acpi_device tree?  I'd
>> prefer hotplug features to be generally integrated into the current ACPI
>> core code and data structures, instead of adding a new layer on top of
>> it.
> The idea comes from PCI hotplug framework, which has an concepts of PCI
> hotplug slot and PCI device. For system device hotplug, we could follow
> the same model as PCI by abstracting control points as slots. By introducing
> of hotplug slot, we could:
>
> 1) Report all hotplug slots and slot's capabilities to user, no matter whether
> there are devices connecting to a slot. If we integrate hotplug functionality
> into current ACPI device tree, the slot (or device) is only visible when the
> connected devices are enabled.

In PCI, the idea of a slot is a pretty explicit -- you can look at the
capabilities of a bridge device and see whether it supports hot-add of
a device below it.  Is it the same way in ACPI?  My impression is that
it is not: there will be a parent ACPI device under which a new device
can be added, but you might not be able to tell by looking at the
parent device that hot-add is possible.  I thought the platform could
just give us a Notify event on the parent, asking us to rescan the
namespace below it and potentially discover new devices.
