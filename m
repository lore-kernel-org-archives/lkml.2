Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873Ab2CMG0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:26:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45949 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759857Ab2CMG0k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:26:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7MEUsBEVQy0=YRzFOBDx8b4ahVTLaFesiEtkFbDNpuow@mail.gmail.com>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
	<1331362837-10740-36-git-send-email-yinghai@kernel.org>
	<CAErSpo7MEUsBEVQy0=YRzFOBDx8b4ahVTLaFesiEtkFbDNpuow@mail.gmail.com>
Date: Mon, 12 Mar 2012 23:26:40 -0700
X-Google-Sender-Auth: lGtot4g7KPlRRkNAeQai6eJb2gI
Message-ID: <CAE9FiQXwk8MhaaHB=yF78GKzZeGDvjXwCdryN=xFzTkM9FS5FQ@mail.gmail.com>
Subject: Re: [PATCH v2 35/37] PCI: Make /sys/bus/pci/rescan rescan root
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 8:44 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Sat, Mar 10, 2012 at 12:00 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> It will rediscover removed pci root buses.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  drivers/pci/pci-sysfs.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
>> index 4d122cb..fc0a7de 100644
>> --- a/drivers/pci/pci-sysfs.c
>> +++ b/drivers/pci/pci-sysfs.c
>> @@ -284,6 +284,7 @@ msi_bus_store(struct device *dev, struct device_attribute *attr,
>>
>>  #ifdef CONFIG_HOTPLUG
>>  static DEFINE_MUTEX(pci_remove_rescan_mutex);
>> +void __weak arch_pci_root_rescan(void) { }
>>  static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
>>                                size_t count)
>>  {
>> @@ -295,6 +296,7 @@ static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
>>
>>        if (val) {
>>                mutex_lock(&pci_remove_rescan_mutex);
>> +               arch_pci_root_rescan();
>>                while ((b = pci_find_next_bus(b)) != NULL)
>>                        pci_rescan_bus(b);
>>                mutex_unlock(&pci_remove_rescan_mutex);
>
> This is gross.  We used to rescan every previously-discovered PCI root bus.
>
> Now, we do the same, plus:
> 1) Scan the ACPI namespace for PCI host bridges, adding and scanning
> any we haven't seen before, and
> 2) scan domain 0, buses 0 - pcibios_last_bus, looking for any we
> haven't seen before.

to have /sys/bus/pci/scan_root again?

Yinghai
