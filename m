Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab2AML1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 06:27:34 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:38641 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab2AML1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 06:27:31 -0500
Message-ID: <4F10151A.8000209@petalogix.com>
Date: Fri, 13 Jan 2012 12:27:22 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Alan Stern <stern@rowland.harvard.edu>, Michal Simek <monstr@monstr.eu>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] USB: EHCI: Don't use NO_IRQ in xilinx ehci driver
References: <Pine.LNX.4.44L0.1201121055370.1384-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1201121055370.1384-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Thu, 12 Jan 2012, Michal Simek wrote:
> 
>> Drivers shouldn't use NO_IRQ. This driver is used
>> by Microblaze and PPC. PPC defines NO_IRQ as 0
>> and Microblaze has removed it.
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>> CC: Alan Stern <stern@rowland.harvard.edu>
>> CC: Greg Kroah-Hartman <gregkh@suse.de>
>> CC: Grant Likely <grant.likely@secretlab.ca>
>> CC: linux-usb@vger.kernel.org
>> CC: devicetree-discuss@lists.ozlabs.org
>> ---
>>  drivers/usb/host/ehci-xilinx-of.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
>> index 32793ce..9c2cc46 100644
>> --- a/drivers/usb/host/ehci-xilinx-of.c
>> +++ b/drivers/usb/host/ehci-xilinx-of.c
>> @@ -183,7 +183,7 @@ static int __devinit ehci_hcd_xilinx_of_probe(struct platform_device *op)
>>  	}
>>  
>>  	irq = irq_of_parse_and_map(dn, 0);
>> -	if (irq == NO_IRQ) {
>> +	if (!irq) {
>>  		printk(KERN_ERR "%s: irq_of_parse_and_map failed\n", __FILE__);
>>  		rv = -EBUSY;
>>  		goto err_irq;
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Thanks Alan.

I have seen that Grant sent the same patch to lkml too.
Here is the thread: http://lkml.org/lkml/2012/1/11/342

Grant: How fast do you think you are able to merge your patches?

Currently I have remove NO_IRQ from Microblaze and we use this driver which
means that driver compilation failed right now. That's why I would like to fix asap.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
