Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab2ATUuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 15:50:20 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49908 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab2ATUuS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 15:50:18 -0500
MIME-Version: 1.0
In-Reply-To: <4F19CB06.6040801@exemail.com.au>
References: <4F192242.1070909@exemail.com.au>
	<20120120160210.GA21565@kroah.com>
	<4F19CB06.6040801@exemail.com.au>
Date: Fri, 20 Jan 2012 21:50:16 +0100
Message-ID: <CAN+gG=EOLQwqRwVV_PreOoGR887x_KfsjFBpK7a=bj0uj9Tc5A@mail.gmail.com>
Subject: Re: PROBLEM: Kernel version 3.2.1 usb touchscreen device not
 recognised [UDEV? USBINPUT? HOOK]
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: padfoot@exemail.com.au
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lachlan,

Well, many eGalax devices are multitouch devices, and can not be
handled by the generic input hid layer without having strange issues.
We have a patch in 3.2 that auto detect such devices and release them
from the generic input stack.
Then, it's easier for people to handle the devices through
hid-multitouch as the recompilation of the kernel is not required
anymore.
I also submitted a patch to catch multitouch devices in
hid-multitouch, but it has not been accepted as it would require
everybody to load hid-multitouch for every hid device.

To enable your device, do (as root)
# modprobe hid-multitouch
# echo 3 VID PID 104 >
/sys/module/hid_multitouch/drivers/hid\:hid-multitouch/new_id

where:
- 3 is the bus, usb here
- VID: vendor ID (must be 0eef in your case)
- PID: product ID
- 104 is the number of the right class of multitouch device to use
(see MT_CLS_* definitions in hid-multitouch)
VID/PID  can be retrieved from lsusb.

If it's working, then you should also give us your PID so that we can
add it in the source of hid-multitouch.

Cheers,
Benjamin


On Fri, Jan 20, 2012 at 21:13, Padfoot <padfoot@exemail.com.au> wrote:
> On 21/01/12 03:02, Greg KH wrote:
>>
>> On Fri, Jan 20, 2012 at 07:13:54PM +1100, Padfoot wrote:
>>>
>>> Upgrade from kernel 3.1.9 to 3.2.1 eGalax usb touchscreen device is
>>> no longer recognised.
>>>
>>> Device is an Acer Iconia Tab w501 with inbuilt touchscreen. Screen
>>> is a pci device but is connected on boot as a usb input device.
>>> Issue appears to be with either UDEV or USBINPUT boot hook failing
>>> to recognise the device as can be seen in the dmesg.3.2.1
>>> attachment.
>>>
>>> Downgrading to kernel 3.1.9 corrects the issue.
>>
>> Can you run 'git bisect' between 3.1.0 and 3.2.0 to find the problem
>> commit here?
>>
>> Also, you might want to cc: the linux-input developers, they can help
>> you out much better than the general list can.
>>
>> greg k-h
>>
> Hi Greg,
>
> I am not a kernel dev, nor have I ever compiled a kernel, so I don't think I
> am able to help with a git bisect to locate the offending commit. I am just
> a regular user running pre-compiled packages on my Arch Linux distro. But,
> of course I am happy to assist wherever I can.
>
> Cheers.
> Lachlan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
