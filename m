Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151Ab2CHAxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 19:53:06 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55849 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab2CHAxD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 19:53:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo59kzBL1ApWuWWcymd9UR3m3vB3zkUoJezn66As+-97dQ@mail.gmail.com>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
	<1331018040-30725-17-git-send-email-yinghai@kernel.org>
	<CAErSpo59kzBL1ApWuWWcymd9UR3m3vB3zkUoJezn66As+-97dQ@mail.gmail.com>
Date: Wed, 7 Mar 2012 16:53:02 -0800
X-Google-Sender-Auth: CmKcmmnGZLgdNZQsvg30D0BACI4
Message-ID: <CAE9FiQVTng2Bi4z9YY9CustC7KkTr-6+qFaaqu8F4dd0WAKGig@mail.gmail.com>
Subject: Re: [PATCH 16/23] PCI: add pci bus removal through /sys/.../pci_bus/.../remove
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 4:03 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Mar 6, 2012 at 12:13 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> it supports both pci root bus and pci bus under pci bridge.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: Randy Dunlap <rdunlap@xenotime.net>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: linux-doc@vger.kernel.org
>> ---
>>  Documentation/ABI/testing/sysfs-bus-pci |    8 ++++++++
>>  drivers/pci/pci-sysfs.c                 |   28 ++++++++++++++++++++++++++++
>>  2 files changed, 36 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
>> index 95f0f37..22392de 100644
>> --- a/Documentation/ABI/testing/sysfs-bus-pci
>> +++ b/Documentation/ABI/testing/sysfs-bus-pci
>> @@ -92,6 +92,14 @@ Description:
>>                hot-remove the PCI device and any of its children.
>>                Depends on CONFIG_HOTPLUG.
>>
>> +What:          /sys/bus/pci/devices/.../pci_bus/.../remove
>> +Date:          March 2012
>> +Contact:       Linux PCI developers <linux-pci@vger.kernel.org>
>> +Description:
>> +               Writing a non-zero value to this attribute will
>> +               hot-remove the PCI bus and any of its children.
>
> Is this the interface we want?  It seems like the ultimate goal is to
> remove the *host bridge*, i.e., the PNP0A08 device on x86.  If that's
> the case, the logical thing seems like a
> /sys/bus/acpi/devices/PNP0A08:00/remove file.
>
> All the current "remove" attributes are for *devices*, e.g.,
> /sys/devices/pci0000:00/0000:00:03.0/remove, not for *buses*.

could add that later.

I am thinking to add some non-intrusive way to make notification work
for root-bus hot removal/add.
...

also in some case, cpu buses get scan during booting, could use that
to remove those not needed
root buses.

>
> I'm not sure it makes sense to talk about removing a "bus" and leaving
> the upstream bridge (either a host bridge or a P2P bridge).  I think
> it'd make more sense to remove the bridge itself, which would of
> course have the consequence of removing the secondary bus.

for root bus, that remove pci_host_bridge and pci root bus.

for pci bus under pci bridge, will remove that pci bus, but will still
keep  that pci bridge.
that should be ok. just like some pci bridge is there, and later can
not create child bus for it.

there is one case: during test busn_alloc, i need to remove all device
on one bus, and
use setpci to change bridge bus number register. then use rescan
bridge to create new bus.

with this one, I just need to remove that bus, instead of remove
children devices one by one.

Yinghai
