Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422681Ab2EKSOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:14:35 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:47599 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab2EKSOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:14:34 -0400
Message-ID: <4FAD5703.7080504@mev.co.uk>
Date: Fri, 11 May 2012 19:14:27 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120414 Thunderbird/11.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: Add helper macro for comedi pci driver
 boilerplate
References: <201205111007.46754.hartleys@visionengravers.com> <4FAD4D20.1010302@mev.co.uk> <ADE657CA350FB648AAC2C43247A983F0020698A17E6A@AUSP01VMBX24.collaborationhost.net> <4FAD4F7F.1060603@mev.co.uk> <ADE657CA350FB648AAC2C43247A983F0020698A17E89@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698A17E89@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-11 18:50, H Hartley Sweeten wrote:
> On Friday, May 11, 2012 10:42 AM, Ian Abbott wrote:
>> On 2012-05-11 18:34, H Hartley Sweeten wrote:
>>> On Friday, May 11, 2012 10:32 AM, Ian Abbott wrote:
>>>> On 2012-05-11 18:07, H Hartley Sweeten wrote:
>>>>> +int comedi_pci_driver_register(struct comedi_driver *comedi_driver,
>>>>> +		struct pci_driver *pci_driver)
>>>>> +{
>>>>> +	int ret;
>>>>> +
>>>>> +	ret = comedi_driver_register(comedi_driver);
>>>>> +	if (ret<    0)
>>>>> +		return ret;
>>>>> +
>>>>> +	pci_driver->name = comedi_driver->driver_name;
>>>>
>>>> I think it would be better if the driver modules that call this function
>>>> already had pci_driver->name initialized statically.
>>>
>>> I agree, but this is how all the pci drivers do it now.
>>>
>>> To change this will require auditing all the comedi pci drivers and adding
>>> the static name.
>>
>> But if you're going to be calling this function from those drivers
>> anyway, you might as well add the static names at the same time!  Saves
>> another round of patches.
>
> True, but many of the pci drivers still need quite a bit of cleanup.
> After this patch was accepted I was going to just change the ones
> that have already had the init/exit stuff cleaned up. Then as I hit
> all the others I would change them.
>
> I guess I could do it this way:
>
> 1) add the "name" to all the pci drivers and remove the
> "pci_driver->name = comedi_driver->name" from all the
> module_init functions.
>
> 2) add the module_comedi_pci_driver stuff, without the
> "pci_driver->name = comedi_driver->name"
>
> 3) Update all the refactored comedi pci drivers to use
> the module_comedi_pci_driver macro.
>
> 4) As the other comedi pci drivers are refactored, use
> the module_comedi_pci_driver macro.
>
> How does that sound?

Okay, but I don't think it's worth doing three patches for each driver 
where one would do.  Adding a one-line .name = "foo", to the single 
patch for each driver you were planning to do anyway seems like a 
trivial addition that could be slotted into the patch without too much 
argument from the "one change per patch" folks, especially if you 
mention the purpose of that line in the commit message.  (I'd defer to 
the better judgement of Greg though.)

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
