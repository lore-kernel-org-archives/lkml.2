Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760582Ab2EWQxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:53:25 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:60557 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150Ab2EWQxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:53:21 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1337791983!13482753!30
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Wed, 23 May 2012 11:53:07 -0500
Subject: RE: [PATCH] staging: comedi: remove this_board macro in the s526
 driver
Thread-Topic: [PATCH] staging: comedi: remove this_board macro in the s526
 driver
Thread-Index: Ac05A+qN553rAJP7RX6EqU6TxvIEpwAAFF4w
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698BAC905@AUSP01VMBX24.collaborationhost.net>
References: <201205221820.10770.hartleys@visionengravers.com>
 <20120523054849.GK4637@mwanda> <4FBCAB50.5000907@mev.co.uk>
 <ADE657CA350FB648AAC2C43247A983F0020698BAC8D8@AUSP01VMBX24.collaborationhost.net>
 <4FBD14E5.2090806@mev.co.uk>
In-Reply-To: <4FBD14E5.2090806@mev.co.uk>
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

On Wednesday, May 23, 2012 9:49 AM, Ian Abbott wrote:
> On 2012-05-23 17:28, H Hartley Sweeten wrote:
>> Side-note on the boardinfo stuff.
>>
>> I wonder if it makes sense to create a common boardinfo struct
>> and modify the comedi_driver struct a bit. Something like:
>>
>> struct comedi_boardinfo {
>> 	const char *name;
>> 	unsigned short	vendor;
>> 	unsigned short device;
>> 	void *private;
>> };
>>
>> struct comedi_driver {
>> 	struct comedi_driver *next;
>>
>> 	const char *driver_name;
>> 	struct module *module;
>> 	int (*attach) (struct comedi_device *, struct comedi_devconfig *);
>> 	void (*detach) (struct comedi_device *);
>> 	int (*attach_pci) (struct comedi_device *, struct pci_dev *);
>> 	int (*attach_usb) (struct comedi_device *, struct usb_interface *);
>>
>> 	u32 num_boards;
>> 	struct comedi_boardinfo *board;
>> };
>>
>> This would allow comedi_recognize() to walk the boardinfo
>> to find the match without all the ugly casts. It should also
>> allow creating a common comedi_find_pcidev() for all the
>> comedi pci drivers to use when probing for the board_ptr.
>>
>> This would create a bit of churn but I think it would be a
>> lot cleaner in the end.
>>
>> What do you think?
>
> Please don't do this yet.  We might want to implement auto configuration 
> for device types that have no concept of vendor ID or product ID, such 
> as PCMCIA, platform devices, SPI devices etc., either by adding extra 
> attach_xxx hooks to struct comedi_driver for the more common bus types, 
> or a more generic attach_generic hook for the less common bus types.
> 
> Also, it would waste space in the ISA-only drivers.

OK. I'll hold off on doing anything like this.

But, I think we would actually save space in all the drivers. I just need
to think about it a bit more.

Regards,
Hartley

