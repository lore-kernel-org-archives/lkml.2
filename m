Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab2KEWPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:15:11 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61805 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab2KEWPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:15:08 -0500
MIME-Version: 1.0
In-Reply-To: <3515628.KRd0S4T47k@vostro.rjw.lan>
References: <1351228071-15161-1-git-send-email-ying.huang@intel.com> <3515628.KRd0S4T47k@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 5 Nov 2012 15:14:46 -0700
Message-ID: <CAErSpo4z+P+NxA_LOb5rKyO34yOx=_vu+=qAWMvnpDjJsAYL-g@mail.gmail.com>
Subject: Re: PCI/PM: Add comments for PME poll support for PCIe
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 5:18 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, October 26, 2012 01:07:51 PM Huang Ying wrote:
>> There are comments on why PME poll support is necessary for PCI
>> devices, but not for PCIe devices.  That may lead to misunderstanding
>> that PME poll is only necessary for PCI devices.  So add comments
>> related to PCIe PME poll to make it more clear.
>>
>> The content of comments comes from the changelog of commit:
>>
>> 379021d5c0899fcf9410cae4ca7a59a5a94ca769
>>
>> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Signed-off-by: Huang Ying <ying.huang@intel.com>
>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

I applied this to my pci/misc branch as v3.8 material.  Thanks!

>> ---
>>  drivers/pci/pci.c |   28 +++++++++++++++++++---------
>>  1 file changed, 19 insertions(+), 9 deletions(-)
>>
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -1578,15 +1578,25 @@ void pci_pme_active(struct pci_dev *dev,
>>
>>       pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, pmcsr);
>>
>> -     /* PCI (as opposed to PCIe) PME requires that the device have
>> -        its PME# line hooked up correctly. Not all hardware vendors
>> -        do this, so the PME never gets delivered and the device
>> -        remains asleep. The easiest way around this is to
>> -        periodically walk the list of suspended devices and check
>> -        whether any have their PME flag set. The assumption is that
>> -        we'll wake up often enough anyway that this won't be a huge
>> -        hit, and the power savings from the devices will still be a
>> -        win. */
>> +     /*
>> +      * PCI (as opposed to PCIe) PME requires that the device have
>> +      * its PME# line hooked up correctly. Not all hardware vendors
>> +      * do this, so the PME never gets delivered and the device
>> +      * remains asleep. The easiest way around this is to
>> +      * periodically walk the list of suspended devices and check
>> +      * whether any have their PME flag set. The assumption is that
>> +      * we'll wake up often enough anyway that this won't be a huge
>> +      * hit, and the power savings from the devices will still be a
>> +      * win.
>> +      *
>> +      * Although PCIe uses in-band PME message instead of PME# line
>> +      * to report PME, PME does not work for some PCIe devices in
>> +      * reality.  For example, there are devices that set their PME
>> +      * status bits, but don't really bother to send a PME message;
>> +      * there are PCI Express Root Ports that don't bother to
>> +      * trigger interrupts when they receive PME messages from the
>> +      * devices below.  So PME poll is used for PCIe devices too.
>> +      */
>>
>>       if (dev->pme_poll) {
>>               struct pci_pme_device *pme_dev;
>>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
