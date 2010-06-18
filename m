Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535Ab0FROpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 10:45:25 -0400
Received: from core.signal11.us ([64.251.29.136]:60223 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933496Ab0FROpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 10:45:23 -0400
Message-ID: <4C1B8682.7050901@signal11.us>
Date: Fri, 18 Jun 2010 10:45:22 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: [PATCH] HID: Documentation for hidraw
References: <1276832283-12084-1-git-send-email-alan@signal11.us> <alpine.LNX.2.00.1006181353120.13809@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1006181353120.13809@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jun 18 10:45:23 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4c1b8683288337036184582
X-DSPAM-Factors: 27,
	could, 0.01000,
	but, 0.01000,
	but, 0.01000,
	reports, 0.01000,
	reports, 0.01000,
	Received*26+177, 0.01000,
	AM, 0.01000,
	or, 0.01000,
	or, 0.01000,
	how+to, 0.01000,
	the+device, 0.01000,
	References*git, 0.01000,
	interface, 0.01000,
	from, 0.01000,
	from, 0.01000,
	of, 0.01000,
	of, 0.01000,
	Thanks+Alan, 0.01000,
	User-Agent*Mozilla/5.0, 0.01000,
	References*alan+signal11.us>, 0.01000,
	send, 0.01000,
	Received*ESMTP, 0.01000,
	User-Agent*rv+1.9.1.9), 0.01000,
	), 0.01000,
	), 0.01000,
	To*suse.cz>, 0.01000,
	Received*(c+76, 0.01000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2010 07:59 AM, Jiri Kosina wrote:
>> Documenation for the hidraw driver.
>>      
> Thanks a lot for writing this up, Alan. It's something that has been
> lingering on my TODO for just too long, it's great that someone finally
> got fed up with it and wrote it :)
>
>    
I wouldn't say I was fed up :)
>>   I'm sure someone here will have a better idea where
>>   to put this than the root of Documentation/. I didn't see a better place, as
>>   hidraw is used for both Bluetooth and USB.
>>      
> Either Documentation/input comes to mind, or we could even establish
> Documentation/hid directory as well.
>
>    
Antonio suggested the same, putting hidraw.txt and hiddev.txt into a new 
Documentation/hid/ directory. I'll do this for the next rev unless I 
hear otherwise.

>>   Documentation/hidraw.txt |  283 ++++++++++++++++++++++++++++++++++++++++++++++
>>   1 files changed, 283 insertions(+), 0 deletions(-)
>>   create mode 100644 Documentation/hidraw.txt
>>
>> diff --git a/Documentation/hidraw.txt b/Documentation/hidraw.txt
>> new file mode 100644
>> index 0000000..7153a06
>> --- /dev/null
>> +++ b/Documentation/hidraw.txt
>> @@ -0,0 +1,283 @@
>> +      HIDRAW - Raw Access to USB and Bluetooth Human Interface Devices
>> +     ==================================================================
>> +
>> +The hidraw driver provides a raw interface to USB and Bluetooth Human
>> +Interface Devices (HIDs).  It differs from hiddev in that reports sent and
>> +received are not parsed by the HID parser, but are sent to and received from
>> +the device unmodified.
>>      
> The important point behind hidraw (compared to hiddev), always has been
> that it's in fact completely independent on underlying hardware transport
> protocol. Currently there are no other implementations of HID than the
> ones using Bluetooth or USB, but there is no general obstacle to using
> hidraw once any vendor comes with HID-over-FibreChannel :) for example.
>
> This basic principle might be worth mentioning as well.
>
>    
I'll make sure to put that in.

>> +Hidraw should be used if the userspace application knows exactly how to
>> +communicate with the hardware device, and is able to construct the HID
>> +reports manually.  This is often the case when making userspace drivers for
>> +custom HID devices.
>> +
>> +Hidraw is also useful for communicating with non-conformant HID devices
>> +which send and receive data in a way that is inconsistent with their report
>> +descriptors.  Because hiddev parses reports which are sent and received
>> +through it and checks them against the device's report descriptor, such
>> +communication with these non-conformant devices is impossible using hiddev.
>>      
> hidraw is just one of the alternatives here of course. Writing in-kernel
> driver also can be done to overcome these obstacles.
>
>    
Also true. I'll add it.

Thanks,

Alan.


