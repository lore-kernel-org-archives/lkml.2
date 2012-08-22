Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901Ab2HVQKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:10:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36767 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab2HVQJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:09:58 -0400
Date: Wed, 22 Aug 2012 11:09:51 -0500 (CDT)
From: Manoj Iyer <manoj.iyer@canonical.com>
X-X-Sender: manjo@lazy
To: Andiry Xu <andiry@gmail.com>
cc: Manoj Iyer <manoj.iyer@canonical.com>, linux-kernel@vger.kernel.org,
        sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/1] xhci: Unconditionally switch ports to xHCI on
 powerup
In-Reply-To: <CAOvWMLZz2RnWG77nrxs=HhR8QAqvX47i-a9JpbdmSqQEY2TWkQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1208221108020.3981@lazy>
References: <1345521975-13708-1-git-send-email-manoj.iyer@canonical.com> <1345522015-13740-1-git-send-email-manoj.iyer@canonical.com> <CAOvWMLaAJrmOKiq=ESXq3wCvFHxWAXMBaeLsK6MUaWBZG+i4Aw@mail.gmail.com> <alpine.DEB.2.02.1208211109050.3421@lazy>
 <CAOvWMLZz2RnWG77nrxs=HhR8QAqvX47i-a9JpbdmSqQEY2TWkQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> If this is a must-to-do thing for Intel Panther Point platform, then
> we need to make sure it's called on power up and resume. Yes, I think
> moving the code below hc_init label should work and I think it's a
> better solution than your original patch.

Yes it effects a lot of machines (Lenovo), I will send out a new seperate 
patch with the fix.

Thanks
Manoj

>
> Thanks,
> Andiry
>
>>
>> On Tue, 21 Aug 2012, Andiry Xu wrote:
>>
>>> On Tue, Aug 21, 2012 at 12:06 PM,  <manoj.iyer@canonical.com> wrote:
>>>>
>>>> From: Manoj Iyer <manoj.iyer@canonical.com>
>>>>
>>>> USB 3.0 devices show up as high-speed devices on powerup, after an
>>>> s3 cycle they are correctly recognized as SuperSpeed. At powerup
>>>> unconditionally switch the port to xHCI like we do when we resume
>>>> from suspend.
>>>>
>>>> BugLink: http://bugs.launchpad.net/bugs/1000424
>>>>
>>>> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
>>>> ---
>>>>  drivers/usb/host/xhci-pci.c |    8 ++++++++
>>>>  1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
>>>> index 9bfd4ca11..5c8dbea 100644
>>>> --- a/drivers/usb/host/xhci-pci.c
>>>> +++ b/drivers/usb/host/xhci-pci.c
>>>> @@ -48,6 +48,14 @@ static int xhci_pci_reinit(struct xhci_hcd *xhci,
>>>> struct pci_dev *pdev)
>>>>         if (!pci_set_mwi(pdev))
>>>>                 xhci_dbg(xhci, "MWI active\n");
>>>>
>>>> +       /*
>>>> +        * USB SuperSpeed ports are recognized as HighSpeed ports on
>>>> powerup
>>>> +        * unconditionally switch the ports to xHCI like we do when
>>>> resume
>>>> +        * from suspend.
>>>> +        */
>>>> +       if (usb_is_intel_switchable_xhci(pdev))
>>>> +               usb_enable_xhci_ports(pdev);
>>>> +
>>>
>>>
>>> Strange. This should have been called during system power up, in
>>> quirk_usb_handoff_xhci() of pci_quirks.c. Do you see that routine get
>>> called during power up?
>>>
>>> Thanks,
>>> Andiry
>>>
>>>>         xhci_dbg(xhci, "Finished xhci_pci_reinit\n");
>>>>         return 0;
>>>>  }
>>>> --
>>>> 1.7.9.5
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>
>> --
>> ====================
>> Manoj Iyer
>> Ubuntu/Canonical
>> Hardware Enablement
>> ====================
>
>

--
====================
Manoj Iyer
Ubuntu/Canonical
Hardware Enablement
====================
