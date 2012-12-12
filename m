Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab2LLGbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 01:31:55 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:44682 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab2LLGbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 01:31:53 -0500
Message-ID: <50C823A5.3050904@gmail.com>
Date: Wed, 12 Dec 2012 00:26:45 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: prasannatsmkumar <prasannatsmkumar@gmail.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        nautilus-list@gnome.org
Subject: Re: Fwd: Safely remove option shows with Micro SD Card connected
 to Linux through an Android phone
References: <CANc+2y50-AYJcJgeQ8JHJiMjwxg=tbkQ2HQR4=ZZsEthKiWXgw@mail.gmail.com> <Pine.LNX.4.44L0.1212111530250.1180-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1212111530250.1180-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 02:37 PM, Alan Stern wrote:
> On Tue, 11 Dec 2012, prasannatsmkumar wrote:
>
>> Hi All,
>>
>> I connected an Android phone using USB cable to my machine running
>> Linux (Linux 3.0, 3.2, 3.5). Mounted the SD card in phone in system
>> (phone is just a pass through I guess). When I choose "Safely Remove"
>> option in nautilus file manager (gnome's default file manager) I got
>> an error saying
>>
>> "Error detaching: helper exited with exit code 1: Detaching device /dev/sdb
>> USB device: /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-5)
>> SYNCHRONIZE CACHE: OK
>> STOP UNIT: FAILED: No such file or directory"
>
> STOP UNIT means spin down the disk or eject the disc.  Since your phone
> doesn't have a disk drive or an optical disc, no wonder this step
> failed.

The reason it's likely doing a STOP UNIT on USB storage devices is that 
this is preferable for at least USB-connected HDs (at least where the 
USB to SATA, etc. converter bothers to implement the translation). For 
many drives, it's better for the disk's lifespan to power it down 
normally (as it would be if it was in a machine that was being shut 
down) so it can unload its heads in a controlled fashion, rather than 
just cutting the power on the running disk and causing an emergency head 
retract.

Some types of devices may not support that command or may not do 
anything useful with it, but "No such file or directory" seems a strange 
error to run into.

>
>> and it goes to unmounted state (yes it should go to and this is not a
>> problem). But I am not able to find the reason for the above error
>> message pop-up. If I choose "Eject" option then things are fine (I
>> think Eject does more than un-mounting the file system).
>>
>> I think "safely remove" tries to cut the power supply to the device
>> but eject does not do that. Is that correct?
>
> No, neither option cuts power.  The main difference is that "safely
> remove" disables the USB connection, so that if the device has an "okay
> to unplug now" light, the light will turn on.
>
>> If the device cannot be
>> powered down (due to battery charging) why this option is shown? Is
>> kernel exposing such capability to the user space?
>>
>> I am not sure whether this is the correct place to ask this question.
>> If this is not the correct place please direct me to correct place.
>
> You probably should get in touch with the people who maintain the
> Nautilus program if you want to know why it does something.
>
> Alan Stern
>

