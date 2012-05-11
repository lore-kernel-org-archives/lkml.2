Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845Ab2EKRma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:42:30 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:47547 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab2EKRm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:42:28 -0400
Message-ID: <4FAD4F7F.1060603@mev.co.uk>
Date: Fri, 11 May 2012 18:42:23 +0100
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
References: <201205111007.46754.hartleys@visionengravers.com> <4FAD4D20.1010302@mev.co.uk> <ADE657CA350FB648AAC2C43247A983F0020698A17E6A@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698A17E6A@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-11 18:34, H Hartley Sweeten wrote:
> On Friday, May 11, 2012 10:32 AM, Ian Abbott wrote:
>> On 2012-05-11 18:07, H Hartley Sweeten wrote:
>>> +int comedi_pci_driver_register(struct comedi_driver *comedi_driver,
>>> +		struct pci_driver *pci_driver)
>>> +{
>>> +	int ret;
>>> +
>>> +	ret = comedi_driver_register(comedi_driver);
>>> +	if (ret<   0)
>>> +		return ret;
>>> +
>>> +	pci_driver->name = comedi_driver->driver_name;
>>
>> I think it would be better if the driver modules that call this function
>> already had pci_driver->name initialized statically.
>
> I agree, but this is how all the pci drivers do it now.
>
> To change this will require auditing all the comedi pci drivers and adding
> the static name.

But if you're going to be calling this function from those drivers 
anyway, you might as well add the static names at the same time!  Saves 
another round of patches.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
