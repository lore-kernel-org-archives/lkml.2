Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab1AUQ52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:57:28 -0500
Received: from core.signal11.us ([64.251.29.136]:39130 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581Ab1AUQ50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:57:26 -0500
Message-ID: <4D39BAF5.9010506@signal11.us>
Date: Fri, 21 Jan 2011 11:57:25 -0500
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Lightning/1.0b1 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] HID: Report Descriptor in Sysfs
References: <1295590785-7101-1-git-send-email-alan@signal11.us> <alpine.LNX.2.00.1101211054210.5725@pobox.suse.cz> <4D399DAB.3080808@signal11.us> <alpine.LNX.2.00.1101211607290.5725@pobox.suse.cz> <4D39A660.7040302@signal11.us> <alpine.LNX.2.00.1101211714050.5725@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1101211714050.5725@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jan 21 11:57:26 2011
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4d39baf6157481982510456
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2011 11:14 AM, Jiri Kosina wrote:
> On Fri, 21 Jan 2011, Alan Ott wrote:
>
>    
>> Well, what I really want is the Usage Page and Usage of the device. For some
>> background, I maintain a library called hidapi[1] for accessing HID devices in
>> a cross platform way. There are currently four backends, Linux-hidraw,
>> Linux-libusb, Mac OS, and Windows.
>>
>> I've recently received requests for supporting composite HID devices. Since a
>> composite device will show up as multiple devices with the same VID/PID, one
>> needs a way to differentiate between its different interfaces. On Windows and
>> Mac, the platform HID libraries support getting the Usage Page and Usage of
>> each interface. On Linux/libusb I can request the HID report descriptor and
>> parse it myself, but I have to claim the interface to do it, and to do that, I
>> have to detach the kernel driver. Needless to say, detaching the kernel driver
>> is not good, especially when the library is supposed to be just scanning for
>> devices.
>>
>> For these reasons, it would be really convenient to get the report descriptor
>> from sysfs.
>>      
> In this case, you can still get the report descriptor from hidraw (which
> is parallel to any other HID-bus based kernel driver). Woudl that suit
> your needs?
>
>    

Not exactly, because not all HID devices have a hidraw interface 
(because some are blacklisted). These devices are still accessible 
through libusb. Plus, getting it from hidraw involves having permissions 
to open the device[1]. Maybe that's less of a limitation, but since I 
can get everything else from sysfs (vid/pid, strings, device version), 
it seemed to make sense to me to have the hid report descriptor in the 
same place.

Again, if I'm completely wrong about how I should be going about this, 
just let me know.

Alan.


[1] Last year, I suggested adding some interfaces to hidraw to get 
things like the serial number, and it was suggested to me on 
linux-usb[2] that I use sysfs (through libudev) instead. I extrapolated 
that the proper paradigm was to use sysfs to get information about the 
device, and to use the device node itself to actually communicate with 
the device. I could be wrong again.

[2] I didn't realize at the time that I really should have asked on 
linux-input instead of linux-usb.


