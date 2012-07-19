Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab2GSSCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 14:02:20 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:10577 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2GSSCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 14:02:17 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-132.messagelabs.com!1342720931!13847221!9
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Thu, 19 Jul 2012 13:01:55 -0500
Subject: RE: [PATCH 88/90] staging: comedi: rtd520: store the pci_dev in the
 comedi_device
Thread-Topic: [PATCH 88/90] staging: comedi: rtd520: store the pci_dev in
 the comedi_device
Thread-Index: Ac1lq9sbTUQuEQD6QzePIdA2CB5jEQAK2LfA
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206AA9164A8@AUSP01VMBX24.collaborationhost.net>
References: <201207181905.13723.hartleys@visionengravers.com>
 <50080083.6050204@mev.co.uk>
In-Reply-To: <50080083.6050204@mev.co.uk>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6JI2QfH019338

On Thursday, July 19, 2012 5:42 AM, Ian Abbott wrote:
> On 2012-07-19 03:05, H Hartley Sweeten wrote:
>> Use the hw_dev pointer in the comedi_device struct to hold the
>> pci_dev instead of carrying it in the private data.
>
> My reply to patch 86 has a knock-on effect for this patch...
>
>>   	/* Get the physical address from PCI config */
>> -	dev->iobase = pci_resource_start(devpriv->pci_dev, LAS0_PCIINDEX);
>> -	physLas1 = pci_resource_start(devpriv->pci_dev, LAS1_PCIINDEX);
>> -	physLcfg = pci_resource_start(devpriv->pci_dev, LCFG_PCIINDEX);
>> +	dev->iobase = pci_resource_start(pcidev, LAS0_PCIINDEX);
>> +	physLas1 = pci_resource_start(pcidev, LAS1_PCIINDEX);
>> +	physLcfg = pci_resource_start(pcidev, LCFG_PCIINDEX);
>
> ...in the use of dev->iobase to hold a PCI memory address.

90 patches, 12 issues... not bad... ;-)

I already posted a v2 of PATCH 01/90 to fix calling to_pci_dev() with
a NULL pointer.

Patches 15, 19, 22, and 23 all deal with the pci_is_enabled(). I think
that call basically keeps the existing functionality of the drivers.
If you feel they should be removed, would it be ok to do that in
a separate patchset?

Patches 30, 32, and 34 deal with the 'bustype'. You already mentioned
that you would submit a patch to fix this.

Patch 61 needs the subsystem_device check. I can fix this and repost
If you feel it's necessary.

Patches 67, 86, and 88 all deal with saving the pci base address in dev->iobase.
I think these are all 32-bit PCI cards so it shouldn't "break" anything. But,
the base address should probably be fetched into a resource_size_t for
passing into the ioremap() call. We can still use dev->iobase to allow the
detach to know that the pci device has been enabled. How about setting it
to something like -EINVAL?

Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
