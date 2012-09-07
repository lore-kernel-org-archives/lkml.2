Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab2IGXdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 19:33:47 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:53671 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755191Ab2IGXdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 19:33:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7-6PEEt+pDV-XRrfHVKDuw+_CbtKK-fEguyGhd_qapdw@mail.gmail.com>
References: <201209072328.30553.rjw@sisk.pl> <CAErSpo7-6PEEt+pDV-XRrfHVKDuw+_CbtKK-fEguyGhd_qapdw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 7 Sep 2012 16:33:22 -0700
Message-ID: <CAErSpo7YZ75Q7zSfNPGONAwpMjr0MViBJH52uAOWjPuQYoTsAw@mail.gmail.com>
Subject: Re: [Resend][PATCH] pciehp: always implement resume
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oliver@neukum.org>, linux-pci@vger.kernel.org,
        Mark Lord <mlord@pobox.com>,
        Kristen Carlson Accardi <kristen.c.accardi@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+cc Mark & Kristen

Commit cd2fe83a815 by Mark added the code we're changing here, so this
is your chance to speak up if we're not doing the right thing :)

On Fri, Sep 7, 2012 at 4:28 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Sep 7, 2012 at 2:28 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> From: Oliver Neukum <oliver@neukum.org>
>> Subject: pciehp: always implement resume
>>
>> The driver by default ignores resume. On some laptops
>> that means that interrupts are not delivered after S3.
>> So card removals and insertions will not be handled. Requiring
>> a forced load isn't right.
>>
>> Signed-off-by: Oliver Neukum <oneukum@suse.de>
>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>
> I applied this (with fixed From: email address and slightly modified
> changelog) to http://git.kernel.org/?p=linux/kernel/git/helgaas/pci.git;a=shortlog;h=refs/heads/pci/oliver-pciehp-resume
> and will merge it to "next" after Fengguang's build/smoke tests.
>
> Thanks!
>
> Bjorn
>
>> ---
>> drivers/pci/hotplug/pciehp_core.c |   28 ++++++++++++++--------------
>>  drivers/pci/hotplug/pciehp_core.c |   28 ++++++++++++++--------------
>>  1 file changed, 14 insertions(+), 14 deletions(-)
>>
>> Index: linux/drivers/pci/hotplug/pciehp_core.c
>> ===================================================================
>> --- linux.orig/drivers/pci/hotplug/pciehp_core.c
>> +++ linux/drivers/pci/hotplug/pciehp_core.c
>> @@ -300,24 +300,24 @@ static int pciehp_suspend (struct pcie_d
>>
>>  static int pciehp_resume (struct pcie_device *dev)
>>  {
>> +       struct controller *ctrl;
>> +       struct slot *slot;
>> +       u8 status;
>> +
>>         dev_info(&dev->device, "%s ENTRY\n", __func__);
>> -       if (pciehp_force) {
>> -               struct controller *ctrl = get_service_data(dev);
>> -               struct slot *slot;
>> -               u8 status;
>> +       ctrl = get_service_data(dev);
>>
>> -               /* reinitialize the chipset's event detection logic */
>> -               pcie_enable_notification(ctrl);
>> +       /* reinitialize the chipset's event detection logic */
>> +       pcie_enable_notification(ctrl);
>>
>> -               slot = ctrl->slot;
>> +       slot = ctrl->slot;
>>
>> -               /* Check if slot is occupied */
>> -               pciehp_get_adapter_status(slot, &status);
>> -               if (status)
>> -                       pciehp_enable_slot(slot);
>> -               else
>> -                       pciehp_disable_slot(slot);
>> -       }
>> +       /* Check if slot is occupied */
>> +       pciehp_get_adapter_status(slot, &status);
>> +       if (status)
>> +               pciehp_enable_slot(slot);
>> +       else
>> +               pciehp_disable_slot(slot);
>>         return 0;
>>  }
>>  #endif /* PM */
