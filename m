Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab1EDREe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:04:34 -0400
Received: from christianhoffmann.info ([88.175.101.52]:57776 "EHLO
	christianhoffmann.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab1EDREd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:04:33 -0400
Message-ID: <4DC1871C.3090109@christianhoffmann.info>
Date: Wed, 04 May 2011 19:04:28 +0200
From: Christian Hoffmann <email@christianhoffmann.info>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Long timeout when booting >= 2.6.38
References: <4DBEFCBA.3070501@christianhoffmann.info>	 <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info>	 <1304372955.3226.15.camel@work-vm>	 <4DBF2FB4.8000304@christianhoffmann.info>	 <1304382664.3226.24.camel@work-vm>	 <4DC04E15.2030308@christianhoffmann.info> <1304473134.3037.14.camel@work-vm> <4DC0FC60.2080701@christianhoffmann.info>
In-Reply-To: <4DC0FC60.2080701@christianhoffmann.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2011 09:12 AM, Christian Hoffmann wrote:
>
>> Can you send dmesg on a broken kernel with the following patch added?
>>
>> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
>> index 5129ed6..6718e7f 100644
>> --- a/drivers/pci/quirks.c
>> +++ b/drivers/pci/quirks.c
>> @@ -2791,6 +2791,7 @@ static void pci_do_fixups(struct pci_dev *dev,
>> struct pci_fixup *f,
>> if ((f->vendor == dev->vendor || f->vendor == (u16) PCI_ANY_ID)&&
>> (f->device == dev->device || f->device == (u16) PCI_ANY_ID)) {
>> dev_dbg(&dev->dev, "calling %pF\n", f->hook);
>> + printk("Calling fixup hook: %pF\n", f->hook);
>> f->hook(dev);
>> }
>> f++;
>
> Hi,
>
> dmesg output with patch applied can be found here:
>
> http://pastebin.com/raw.php?i=y6gC848k

As it "works" with acpi=off, I put the dmesg output of same "broken" 
kernel with acpi_off here:

http://pastebin.com/raw.php?i=yBGNL8f2

And
cat /sys/devices/system/clocksource/clocksource0/available_clocksource
jiffies tsc

Rgds,
Chris
