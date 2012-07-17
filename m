Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab2GQBzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 21:55:52 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:45368 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2GQBzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 21:55:51 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-127.messagelabs.com!1342490150!8784714!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>
Date: Mon, 16 Jul 2012 20:55:47 -0500
Subject: RE: [PATCH 01/30] staging: comedi: add pci_dev pointer to
 comedi_device
Thread-Topic: [PATCH 01/30] staging: comedi: add pci_dev pointer to
 comedi_device
Thread-Index: Ac1jvsZSGu7zc15XTVWeu1w7o1mDZgAAA7/A
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206AA915E16@AUSP01VMBX24.collaborationhost.net>
References: <201207111449.15203.hartleys@visionengravers.com>
 <20120717015201.GA10048@kroah.com>
In-Reply-To: <20120717015201.GA10048@kroah.com>
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

On Monday, July 16, 2012 6:52 PM, Greg KH wrote:
> On Wed, Jul 11, 2012 at 02:49:14PM -0700, H Hartley Sweeten wrote:
>> The pci_dev pointer in the private driver data is used by every
>> comedi pci driver. Some of them only have the need for the
>> private data because of this pointer.
>> 
>> Introduce the pci_dev pointer in the comedi_device struct so it
>> can be used instead of needing it in the private data.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Ian Abbott <abbotti@mev.co.uk>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>  drivers/staging/comedi/comedidev.h | 2 ++
>>  1 file changed, 2 insertions(+)
>> 
>> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
>> index de8c99c..55f2373 100644
>> --- a/drivers/staging/comedi/comedidev.h
>> +++ b/drivers/staging/comedi/comedidev.h
>> @@ -212,6 +212,8 @@ struct comedi_device {
>>  	 * DMA_NONE */
>>  	struct device *hw_dev;
>>  
>> +	struct pci_dev *pcidev;
>
> No, the field above this, hw_dev, should be used instead here, as that's
> what it is there for, right?

The hw_dev pointer is currently only used for something dealing with dma.
I have not dug into it yet to see what exactly it's used for.  The comment
says:

	/* hw_dev is passed to dma_alloc_coherent when allocating async buffers
	 * for subdevices that have async_dma_dir set to something other than
	 * DMA_NONE */

> Care to rework this series with that change instead?

It could probably be used with some sort of container_of but I'm not sure.

Regards,
Hartley
