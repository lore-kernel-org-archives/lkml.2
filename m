Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086Ab2EOPzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:55:04 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51442 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272Ab2EOPzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:55:02 -0400
Message-ID: <4FB27C50.2000609@mev.co.uk>
Date: Tue, 15 May 2012 16:54:56 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120414 Thunderbird/11.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: refactor ni_pcimio driver and use module_comedi_pci_driver
References: <201205111651.56541.hartleys@visionengravers.com> <4FB23DF8.8090508@mev.co.uk> <ADE657CA350FB648AAC2C43247A983F0020698AE0932@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698AE0932@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-15 16:41, H Hartley Sweeten wrote:
> On Tuesday, May 15, 2012 4:29 AM, Ian Abbott wrote:
>> On 2012-05-12 00:51, H Hartley Sweeten wrote:
>>> +static struct comedi_driver ni_pcimio_driver = {
>>> +	.driver_name	= "ni_pcimio",
>>
>> The original used the DRV_NAME macro expanding to "ni_pcimio" here...
>>
>>> +static struct pci_driver ni_pcimio_pci_driver = {
>>> +	.name		= "ni_pcimio",
>>
>> ... which could also be used here.
>>
>>   (I realize this is a bit late as the patch is already committed!)
>
> I noticed that. A couple of the comedi drivers do this but it's not consistent.
>
> Personally I don't care for the use of the DRV_NAME (or DRIVER_NAME
> or whatever someone wants to call it) usage. It doesn't same any code
> space and always makes me have to do a second search to see what the
> "name" actually is.
>
> Regardsless, if you prefer this in the drivers please let me know. It
> would be nice to have them somewhat consistent before the comedi
> support leaves staging.

It doesn't really matter as long as it's consistent within the driver. 
I tend to use macros for literals used several times as it often allows 
mistakes to be caught at compile-time.

I think DRV_NAME is still used in the request_irq() call though.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
