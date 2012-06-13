Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab2FMIDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:03:35 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33629 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab2FMIDY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:03:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120528105131.67d74d45@pyramind.ukuu.org.uk>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
	<1338181720-4149-3-git-send-email-ming.m.lin@intel.com>
	<20120528105131.67d74d45@pyramind.ukuu.org.uk>
Date: Wed, 13 Jun 2012 16:03:23 +0800
X-Google-Sender-Auth: is96NzF2trz0eYUsnd8GwzMKn_Q
Message-ID: <CAF1ivSYBjw+UP3vP8RHaftjR8NJZEaHA1rtJ5ujDjkj-djHLTQ@mail.gmail.com>
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

On Mon, May 28, 2012 at 5:51 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> +static int is_pci_ata(struct device *dev)
>> +{
>> +     struct pci_dev *pdev;
>> +
>> +     if (!is_pci_dev(dev))
>> +             return 0;
>> +
>> +     pdev = to_pci_dev(dev);
>> +
>> +     if ((pdev->class >> 8) != PCI_CLASS_STORAGE_SATA &&
>> +         (pdev->class >> 8) != PCI_CLASS_STORAGE_IDE)
>> +             return 0;
>
> This needs a better name. It doesn't check if a device is PCI ATA or
> anything of the sort, it checks if its probably a device in compatibility
> mode. A lot of controllers will in fact report RAID class or similar in
> native mode.

How about compat_pci_ata?

>
> Alan
