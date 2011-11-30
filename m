Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840Ab1K3MAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 07:00:19 -0500
Received: from bay0-omc1-s19.bay0.hotmail.com ([65.54.190.30]:8354 "EHLO
	bay0-omc1-s19.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757724Ab1K3MAQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 07:00:16 -0500
Message-ID: <BAY163-W20B75700404320F942FB93FBB00@phx.gbl>
X-Originating-IP: [82.43.252.147]
From: Anand Kanaginhal <anand_dk@hotmail.com>
To: <greg@kroah.com>, linux kernel mailing <linux-kernel@vger.kernel.org>
Subject: RE: PCIe Hotplugging not working
Date: Wed, 30 Nov 2011 04:00:15 -0800
Importance: Normal
In-Reply-To: <20111129225552.GB27909@kroah.com>
References: <BAY163-W52E309F419E3588206D889FBB30@phx.gbl>,<BAY163-W47DD39095DA3EB108AA3F2FBB30@phx.gbl>,<20111129142214.GC14845@kroah.com>,<BAY163-W63C79C972B0F87A46B0FDCFBB30@phx.gbl>,<20111129225552.GB27909@kroah.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 30 Nov 2011 12:00:15.0916 (UTC) FILETIME=[9F74F6C0:01CCAF57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




----------------------------------------
> Date: Wed, 30 Nov 2011 07:55:52 +0900
> From: greg@kroah.com
> To: anand_dk@hotmail.com
> CC: linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; linux-hotplug@vger.kernel.org
> Subject: Re: PCIe Hotplugging not working
>
> On Tue, Nov 29, 2011 at 09:50:41AM -0800, Anand Kanaginhal wrote:
>>
>> Resending as earlier sends failed
>
> You can not send html messages to vger.kernel.org mailing lists.
 Thanks for the info, I will keep that in mind.

>>> Why is a pci driver a "char" driver? Do you have a pointer to the
>>> source of this?
>>
>> I am doing an test before putting it in its right place. Another
>> reason is that I am treating it as character device and using IOCTLs
>> for various operations. I have attached the framework code here.
>
> Just a note, but your framework is backwards, you should allocate your
> character device in your probe function, not in the module init
> function.
>
> Also, what type of driver is this, why do you need ioctls for it?

I understand that it is slightly unconventional to do this. However this module is a very thin kernel layer for custom device and custom application, which interact with the system via the IOCTLs.
The module and a dummy device needs to be present to answer apps needs, thats the reason for keeping the device create in mod init. There would be many occasions and of these end point devices appear and disappear when the system is running. There are some other of these requirerments which make it simpler to implement it this way.

>>>> 2. I run depmod and "modules.pcimap" also got updated with my module.
>>>>
>>>> However
>>>> if I unplug and plug in the endpoint, my driver .probe and .remove functions
>>>> are not being invoked. Is there something more to be done at the bus
>>>> level to get the driver to hot plug ?
>>>
>>> You need a pci hotplug controller driver, is that loaded? That is what
>>> is responsible for eventually calling your remove function.
>>
>> How do I figure out if a pci hotplug controller driver is installed?
>
> How do you know that your hardware supports PCI hotplugging at all?
>
> You need a PCI hotplug controller in the system, generally if you have
> one, the driver will be loaded for it, but if you are using a custom
> kernel, you might have to build and install it yourself.

The PEX 8609 device that we are using supports Hot-Plug through a serial Hot-Plug interface brought out through I2C port.
now the only point is whether the controller driver for this is loaded in the system. 

>>>> I have tried various kernel version, Currently I am trying on 2.6.38.12 (UBUNTU flavor).
>>>
>>> We can't help you with distro-specific kernels, please use a kernel.org
>>> kernel and we will be glad to help you out.
>>
>> I have tried with vanilla kernel as well with the same results.
>
> What release did you try?
We had tried 2.6.38.8 from kernel.org and an earlier version if I recall correctly was based on 2.6.18.

> greg k-h
 		 	   		  