Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab2HNSXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:23:45 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:10179 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab2HNSXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:23:43 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-131.messagelabs.com!1344968607!24010270!30
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>
Date: Tue, 14 Aug 2012 13:23:37 -0500
Subject: RE: [PATCH 1/2 v2] staging: comedi: new adl_pci7x3x driver
Thread-Topic: [PATCH 1/2 v2] staging: comedi: new adl_pci7x3x driver
Thread-Index: Ac15+wsdLkSpdA/KQ166evQ7E1ysswATmqrQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206AAE97981@AUSP01VMBX24.collaborationhost.net>
References: <201208031028.18759.hartleys@visionengravers.com>
 <20120814012949.GA11859@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F00206AAE977F3@AUSP01VMBX24.collaborationhost.net>
 <502A134C.4000406@mev.co.uk>
In-Reply-To: <502A134C.4000406@mev.co.uk>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7EINoNC017530

On Tuesday, August 14, 2012 1:59 AM, Ian Abbott wrote:
> On 2012-08-14 02:36, H Hartley Sweeten wrote:
>> On Monday, August 13, 2012 6:30 PM, Greg KH wrote:
>>> On Fri, Aug 03, 2012 at 10:28:18AM -0700, H Hartley Sweeten wrote:
>>>> Currently the ADLink PCI-7230 and PCI-7432 Isolated Digital
>>>> I/O Boards are supported using two drivers (adl_pci7230 and
>>>> adl_pci7432). These drivers are very similar and only differ
>>>> in the total number of di/do channels provided.
>>>>
>>>> This driver combines the support for both boards into one
>>>> common driver. In addition, it adds PCI PnP support for the
>>>> other boards in the ADLink PCI-723x and PCI-743x series.
>>>>
>>>> This driver only supports the comedi PCI auto config attach
>>>> mechanism. The legacy attach using the comedi_config utility
>>>> is not supported or required by this driver.
>>>
>>> I now get the following build warnings on my box with this patch
>>> applied:
>>>
>>> drivers/staging/comedi/drivers/adl_pci7x3x.c: In function â€˜adl_pci7x3x_do_insn_bitsâ€™:
>>> drivers/staging/comedi/drivers/adl_pci7x3x.c:124:21: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>>> drivers/staging/comedi/drivers/adl_pci7x3x.c: In function â€˜adl_pci7x3x_di_insn_bitsâ€™:
>>> drivers/staging/comedi/drivers/adl_pci7x3x.c:150:21: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>>
>> Hmm.. My build does not have the [-Wpointer-to-int-cast] for some reason
>> so I didn't see this. I was trying to save having to allocate any private data but
>> I guess it's cleaner if I do.  BTW, there is another comedi driver that does this
>> but I can't recall which one of the top of my head...
>
> You could always cast to unsigned long as that is the same size as a 
> pointer, at least in the Linux kernel.

Ah, so it's a 32/64-bit issue... My build setup is only 32-bit that's why I
didn't see it.

The acl7225b driver is the other one that passes the register offset
in the s->private pointer. That one does cast the pointer to an
unsigned long.

I assume this will fix the warning in the adl_pci7x3x driver. Patch
coming shortly.

Regards,
Hartley

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
