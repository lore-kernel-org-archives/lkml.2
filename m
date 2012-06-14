Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab2FNHoC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 03:44:02 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34952 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2FNHn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 03:43:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120613120050.164c3f29@pyramind.ukuu.org.uk>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
	<1338181720-4149-3-git-send-email-ming.m.lin@intel.com>
	<20120528105131.67d74d45@pyramind.ukuu.org.uk>
	<CAF1ivSYBjw+UP3vP8RHaftjR8NJZEaHA1rtJ5ujDjkj-djHLTQ@mail.gmail.com>
	<20120613120050.164c3f29@pyramind.ukuu.org.uk>
Date: Thu, 14 Jun 2012 15:43:57 +0800
X-Google-Sender-Auth: T7QCuBN9yuOJr9_pVPvAXAZkWHk
Message-ID: <CAF1ivSZTtJ651p5WgwKde8gHvJX7KcsTDXMzhej+Chka9P5ozw@mail.gmail.com>
Subject: Re: [PATCH v4 02/13] libata: bind the Linux device tree to the ACPI
 device tree
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jgarzik@pobox.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 7:00 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 13 Jun 2012 16:03:23 +0800
> Lin Ming <ming.m.lin@intel.com> wrote:
>
>> On Mon, May 28, 2012 at 5:51 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> >> +static int is_pci_ata(struct device *dev)
>> >> +{
>> >> +     struct pci_dev *pdev;
>> >> +
>> >> +     if (!is_pci_dev(dev))
>> >> +             return 0;
>> >> +
>> >> +     pdev = to_pci_dev(dev);
>> >> +
>> >> +     if ((pdev->class >> 8) != PCI_CLASS_STORAGE_SATA &&
>> >> +         (pdev->class >> 8) != PCI_CLASS_STORAGE_IDE)
>> >> +             return 0;
>> >
>> > This needs a better name. It doesn't check if a device is PCI ATA or
>> > anything of the sort, it checks if its probably a device in compatibility
>> > mode. A lot of controllers will in fact report RAID class or similar in
>> > native mode.
>>
>> How about compat_pci_ata?
>
> Sounds reasonable. I'm not btw sure the test is entirely right, but I'm
> not sure quite what you are trying to figure out from it and how ACPI
> expects this mapping to work.

It's used to figure out if the dev passed in from scsi layer is a ata device.

scsi_sysfs_add_sdev
device_add
acpi_platform_notify
ata_acpi_find_device
is_pci_ata

Thanks,
Lin Ming

>
> Alan
