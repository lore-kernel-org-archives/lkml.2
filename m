Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab1AUQJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:09:00 -0500
Received: from core.signal11.us ([64.251.29.136]:41053 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901Ab1AUQI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:08:59 -0500
Message-ID: <4D39A660.7040302@signal11.us>
Date: Fri, 21 Jan 2011 10:29:36 -0500
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Lightning/1.0b1 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] HID: Report Descriptor in Sysfs
References: <1295590785-7101-1-git-send-email-alan@signal11.us> <alpine.LNX.2.00.1101211054210.5725@pobox.suse.cz> <4D399DAB.3080808@signal11.us> <alpine.LNX.2.00.1101211607290.5725@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1101211607290.5725@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jan 21 11:08:58 2011
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4d39af9a153711572410651
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2011 10:09 AM, Jiri Kosina wrote:
> On Fri, 21 Jan 2011, Alan Ott wrote:
>
>    
>> Maybe it is. To be honest I didn't check debugfs. I have two concerns about
>> it:
>> 1. Is it wise for userspace programs to rely on:
>>      
> Ah, I didn't realize that you want it to be used by some acutal userspace
> applications. Out of curiosity -- what is the usage pattern you are
> targetting?
>    

Well, what I really want is the Usage Page and Usage of the device. For 
some background, I maintain a library called hidapi[1] for accessing HID 
devices in a cross platform way. There are currently four backends, 
Linux-hidraw, Linux-libusb, Mac OS, and Windows.

I've recently received requests for supporting composite HID devices. 
Since a composite device will show up as multiple devices with the same 
VID/PID, one needs a way to differentiate between its different 
interfaces. On Windows and Mac, the platform HID libraries support 
getting the Usage Page and Usage of each interface. On Linux/libusb I 
can request the HID report descriptor and parse it myself, but I have to 
claim the interface to do it, and to do that, I have to detach the 
kernel driver. Needless to say, detaching the kernel driver is not good, 
especially when the library is supposed to be just scanning for devices.

For these reasons, it would be really convenient to get the report 
descriptor from sysfs.

Alan.

[1] http://www.signal11.us/oss/hidapi/


