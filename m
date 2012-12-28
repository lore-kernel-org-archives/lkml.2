Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab2L1I42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 03:56:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:30382 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab2L1I4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 03:56:25 -0500
X-IronPort-AV: E=Sophos;i="4.84,368,1355068800"; 
   d="scan'208";a="6493029"
Message-ID: <50DD5E8A.5050205@cn.fujitsu.com>
Date: Fri, 28 Dec 2012 16:55:38 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, tangchen@cn.fujitsu.com
Subject: Re: [PATCH] pci: remove redundant function calls in pci_reassigndev_resource_alignment()
References: <1356679902-4266-1-git-send-email-linfeng@cn.fujitsu.com> <CAE9FiQU1YM32pb+iGJHj1m3W-nGUbHh5f8Qkx5bRsfptgGParw@mail.gmail.com>
In-Reply-To: <CAE9FiQU1YM32pb+iGJHj1m3W-nGUbHh5f8Qkx5bRsfptgGParw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/28 16:56:08,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/28 16:56:09,
	Serialize complete at 2012/12/28 16:56:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/28/2012 03:45 PM, Yinghai Lu wrote:
> On Thu, Dec 27, 2012 at 11:31 PM, Lin Feng <linfeng@cn.fujitsu.com> wrote:
>> pci_reassigndev_resource_alignment() potentially calls
>> pci_specified_resource_alignment() twice, which is redundant.
>>
>> pci_is_reassigndev() is only called in pci_reassigndev_resource_alignment(),
>> and from sematic/functionality aspects pci_specified_resource_alignment() is
>> sufficient to substitute, so also make some cleanup.
>>
>> Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  drivers/pci/pci.c |   16 ++--------------
>>  1 files changed, 2 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index 5cb5820..789f401 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -3766,18 +3766,6 @@ resource_size_t pci_specified_resource_alignment(struct pci_dev *dev)
>>         return align;
>>  }
>>
>> -/**
>> - * pci_is_reassigndev - check if specified PCI is target device to reassign
>> - * @dev: the PCI device to check
>> - *
>> - * RETURNS: non-zero for PCI device is a target device to reassign,
>> - *          or zero is not.
>> - */
>> -int pci_is_reassigndev(struct pci_dev *dev)
>> -{
>> -       return (pci_specified_resource_alignment(dev) != 0);
>> -}
>> -
>>  /*
>>   * This function disables memory decoding and releases memory resources
>>   * of the device specified by kernel's boot parameter 'pci=resource_alignment='.
>> @@ -3792,7 +3780,8 @@ void pci_reassigndev_resource_alignment(struct pci_dev *dev)
>>         resource_size_t align, size;
>>         u16 command;
>>
>> -       if (!pci_is_reassigndev(dev))
>> +       align = pci_specified_resource_alignment(dev);
>> +       if (!align)
>>                 return;
>>
>>         if (dev->hdr_type == PCI_HEADER_TYPE_NORMAL &&
>> @@ -3808,7 +3797,6 @@ void pci_reassigndev_resource_alignment(struct pci_dev *dev)
>>         command &= ~PCI_COMMAND_MEMORY;
>>         pci_write_config_word(dev, PCI_COMMAND, command);
>>
>> -       align = pci_specified_resource_alignment(dev);
>>         for (i = 0; i < PCI_BRIDGE_RESOURCES; i++) {
>>                 r = &dev->resource[i];
>>                 if (!(r->flags & IORESOURCE_MEM))
>> --
>> 1.7.1
>>
> 
> looks the same as the one that i posted 6 months ago.
> 
> http://copilotco.com/mail-archives/linux-kernel.2012/msg18498.html
Sorry, I didn't notice your patchset before :)
Yes, they are the same. But why does nobody care this?
> 
> Yinghai
> 
