Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab2H0Byp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 21:54:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58666 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab2H0Byn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 21:54:43 -0400
MIME-Version: 1.0
In-Reply-To: <50379008.3080500@gmail.com>
References: <CAFgQCTt82Mu2mhVxeZ01=1bJzuzDWZjBEV58X9xjeEPQY3R8ww@mail.gmail.com>
	<50379008.3080500@gmail.com>
Date: Mon, 27 Aug 2012 09:54:42 +0800
Message-ID: <CAFgQCTs_8WSpmqXwQUznb-hz=VNxHkuAmR5J22O62d1qw7Smgg@mail.gmail.com>
Subject: Re: pci: question about the life cycle of pci_dev and its parent pci_bus
From: Liu ping fan <kernelfans@gmail.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Scott Murray <scott@spiteful.org>, Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 10:30 PM, Jiang Liu <liuj97@gmail.com> wrote:
> Hi Pingfan,
>
>         We have realized the same when implementing lock mechanisms for PCI hotplug
> operations, and we are planning to holding a reference to parent bus for each pci dev.

Thanks! You save me from searching such codes.
Regards,
pingfan

>         Regards!
>         Gerry
>
> On 08/23/2012 01:24 PM, Liu ping fan wrote:
>> Hi,
>>
>> I have a question about the life cycle of pci_dev and its parent pci_bus.
>> In pci_destroy_dev(), we remove the pci_dev from the bus_list, so
>> pci_dev is isolated from its parent pci_bus, and their life cycle are
>> independent too. But it seems that in pci_dev, we can still access the
>> pci_bus from the pointer pci_dev->bus.  To resolve such issue, I think
>> during the pci_dev removal,  there should be process to 1.prevent the
>> reader incoming 2. ensure the current reader has exit.  But can not
>> find them.
>>
>> Could anyone tell me?
>>
>> Thanx, pingfan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
