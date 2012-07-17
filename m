Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab2GQC0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 22:26:18 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:34533 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab2GQCZz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 22:25:55 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-132.messagelabs.com!1342491953!14555344!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 16 Jul 2012 21:25:51 -0500
Subject: RE: [PATCH 01/30] staging: comedi: add pci_dev pointer to
 comedi_device
Thread-Topic: [PATCH 01/30] staging: comedi: add pci_dev pointer to
 comedi_device
Thread-Index: Ac1jv/c1Q5gPrey3R+aG/qhizmXBUQAAzZfw
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206AA915E1B@AUSP01VMBX24.collaborationhost.net>
References: <201207111449.15203.hartleys@visionengravers.com>
 <20120717015201.GA10048@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F00206AA915E16@AUSP01VMBX24.collaborationhost.net>
 <20120717020034.GA28771@kroah.com>
In-Reply-To: <20120717020034.GA28771@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 16, 2012 7:01 PM, Greg KH wrote:
> On Mon, Jul 16, 2012 at 08:55:47PM -0500, H Hartley Sweeten wrote:
>> On Monday, July 16, 2012 6:52 PM, Greg KH wrote:
>>> No, the field above this, hw_dev, should be used instead here, as that's
>>> what it is there for, right?
>>
>> The hw_dev pointer is currently only used for something dealing with dma.
>> I have not dug into it yet to see what exactly it's used for.  The comment
>> says:
>> 
>> 	/* hw_dev is passed to dma_alloc_coherent when allocating async buffers
>> 	 * for subdevices that have async_dma_dir set to something other than
>> 	 * DMA_NONE */
>
> Which is exactly what the pci device should be used for, it knows this
> information :)
>
>>> Care to rework this series with that change instead?
>> 
>> It could probably be used with some sort of container_of but I'm not sure.
>
> Yes it can.
>
> To set the field:
>
> 	hw_dev = &pci_dev->dev;
>
> to get it back:
>	pci_dev = container_of(hw_dev, struct pci_device, struct device);
>
> I think.  That's off the top of my head, please try it out first.
>
> And use a macro for the container_of stuff, that makes it easier to
> understand.

Greg,

I'm posting a patch to the adl_pci6208 driver right now. It compiles fine
but could you look it over and see if it looks right.

Thanks,
Hartley

