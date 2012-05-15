Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965684Ab2EOQL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:11:27 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:13265 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965264Ab2EOQL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:11:26 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1337098269!12666993!33
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Tue, 15 May 2012 11:11:17 -0500
Subject: RE: [PATCH] staging: comedi: refactor ni_pcimio driver and use
 module_comedi_pci_driver
Thread-Topic: [PATCH] staging: comedi: refactor ni_pcimio driver and use
 module_comedi_pci_driver
Thread-Index: Ac0ysxd/DnnmsaesRHOle38IjugIcwAAG1gg
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698AE0956@AUSP01VMBX24.collaborationhost.net>
References: <201205111651.56541.hartleys@visionengravers.com>
 <4FB23DF8.8090508@mev.co.uk>
 <ADE657CA350FB648AAC2C43247A983F0020698AE0932@AUSP01VMBX24.collaborationhost.net>
 <4FB27C50.2000609@mev.co.uk>
In-Reply-To: <4FB27C50.2000609@mev.co.uk>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4FGBXij012582

On Tuesday, May 15, 2012 8:55 AM, Ian Abbott wrote:
> On 2012-05-15 16:41, H Hartley Sweeten wrote:
>> On Tuesday, May 15, 2012 4:29 AM, Ian Abbott wrote:
>>> On 2012-05-12 00:51, H Hartley Sweeten wrote:
>>>> +static struct comedi_driver ni_pcimio_driver = {
>>>> +	.driver_name	= "ni_pcimio",
>>>
>>> The original used the DRV_NAME macro expanding to "ni_pcimio" here...
>>>
>>>> +static struct pci_driver ni_pcimio_pci_driver = {
>>>> +	.name		= "ni_pcimio",
>>>
>>> ... which could also be used here.
>>>
>>>   (I realize this is a bit late as the patch is already committed!)
>>
>> I noticed that. A couple of the comedi drivers do this but it's not consistent.
>>
>> Personally I don't care for the use of the DRV_NAME (or DRIVER_NAME
>> or whatever someone wants to call it) usage. It doesn't same any code
>> space and always makes me have to do a second search to see what the
>> "name" actually is.
>>
>> Regardsless, if you prefer this in the drivers please let me know. It
>> would be nice to have them somewhat consistent before the comedi
>> support leaves staging.
>
> It doesn't really matter as long as it's consistent within the driver. 
> I tend to use macros for literals used several times as it often allows 
> mistakes to be caught at compile-time.
>
> I think DRV_NAME is still used in the request_irq() call though.

Yah, I missed that one.

I was going to clean up all the request_irq()'s so that dev->driver->driver_name
is used for all "name" parameters. This fixes a number of drivers that directly
reference the static comedi_driver variable. And it removes all the static "names".

When I do this I will also drop all the DRV_NAME macros that are no longer used.

Regards,
Hartley


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
