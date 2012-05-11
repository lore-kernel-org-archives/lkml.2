Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945960Ab2EKRup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:50:45 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:64382 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945913Ab2EKRul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:50:41 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1336758639!4641108!6
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Fri, 11 May 2012 12:50:38 -0500
Subject: RE: [PATCH] staging: comedi: Add helper macro for comedi pci driver
 boilerplate
Thread-Topic: [PATCH] staging: comedi: Add helper macro for comedi pci
 driver boilerplate
Thread-Index: Ac0vnXCqAm66zOdhRo6kD+4DIzanYAAADTWA
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698A17E89@AUSP01VMBX24.collaborationhost.net>
References: <201205111007.46754.hartleys@visionengravers.com>
 <4FAD4D20.1010302@mev.co.uk>
 <ADE657CA350FB648AAC2C43247A983F0020698A17E6A@AUSP01VMBX24.collaborationhost.net>
 <4FAD4F7F.1060603@mev.co.uk>
In-Reply-To: <4FAD4F7F.1060603@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4BHug3I020875

On Friday, May 11, 2012 10:42 AM, Ian Abbott wrote:
> On 2012-05-11 18:34, H Hartley Sweeten wrote:
>> On Friday, May 11, 2012 10:32 AM, Ian Abbott wrote:
>>> On 2012-05-11 18:07, H Hartley Sweeten wrote:
>>>> +int comedi_pci_driver_register(struct comedi_driver *comedi_driver,
>>>> +		struct pci_driver *pci_driver)
>>>> +{
>>>> +	int ret;
>>>> +
>>>> +	ret = comedi_driver_register(comedi_driver);
>>>> +	if (ret<   0)
>>>> +		return ret;
>>>> +
>>>> +	pci_driver->name = comedi_driver->driver_name;
>>>
>>> I think it would be better if the driver modules that call this function
>>> already had pci_driver->name initialized statically.
>>
>> I agree, but this is how all the pci drivers do it now.
>>
>> To change this will require auditing all the comedi pci drivers and adding
>> the static name.
>
> But if you're going to be calling this function from those drivers 
> anyway, you might as well add the static names at the same time!  Saves 
> another round of patches.

True, but many of the pci drivers still need quite a bit of cleanup.
After this patch was accepted I was going to just change the ones
that have already had the init/exit stuff cleaned up. Then as I hit
all the others I would change them.

I guess I could do it this way:

1) add the "name" to all the pci drivers and remove the
"pci_driver->name = comedi_driver->name" from all the
module_init functions.

2) add the module_comedi_pci_driver stuff, without the
"pci_driver->name = comedi_driver->name"

3) Update all the refactored comedi pci drivers to use
the module_comedi_pci_driver macro.

4) As the other comedi pci drivers are refactored, use
the module_comedi_pci_driver macro.

How does that sound?

Regards,
Hartley

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
