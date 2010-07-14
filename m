Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab0GNNzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:55:52 -0400
Received: from smtp.nokia.com ([192.100.105.134]:56298 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab0GNNzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:55:51 -0400
Message-ID: <4C3DC1D5.4060406@nokia.com>
Date: Wed, 14 Jul 2010 16:55:33 +0300
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: ext Andy Shevchenko <andy.shevchenko@gmail.com>
CC: =?UTF-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shevchenko Andriy (EXT-Teleca/Helsinki)" 
	<ext-andriy.shevchenko@nokia.com>,
        "Karpov Denis.2 (EXT-Teleca/Helsinki)" <ext-denis.2.karpov@nokia.com>,
        "Hunter Adrian (Nokia-MS/Helsinki)" <adrian.hunter@nokia.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCHv2] usb: gadget: storage: optional SCSI WRITE FUA bit
References: <Pine.LNX.4.44L0.1007131003560.1568-100000@iolanthe.rowland.org>	<1279098331-7872-1-git-send-email-ext-andriy.shevchenko@nokia.com>	<op.vft2p6do7p4s8u@pikus> <AANLkTil1eG5yzBxvryf-TZINYjeGph-rNz8eELQtm5tj@mail.gmail.com>
In-Reply-To: <AANLkTil1eG5yzBxvryf-TZINYjeGph-rNz8eELQtm5tj@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 14 Jul 2010 13:55:07.0522 (UTC) FILETIME=[2AFA9620:01CB235C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 04:44 PM, ext Andy Shevchenko wrote:
> 2010/7/14 Michał Nazarewicz<m.nazarewicz@samsung.com>:
>> On Wed, 14 Jul 2010 11:05:31 +0200, Andy Shevchenko
>> <andy.shevchenko@gmail.com>  wrote:
>>>
>>> MS Windows mounts removable storage in "Removal optimized mode" by
>>> default. All the writes to the media are synchronous which is achieved
>>> by setting FUA (Force Unit Access) bit in SCSI WRITE(10,12) commands.
>>> This prevents I/O requests aggregation in block layer dramatically
>>> decreasing performance.
>>
>>> diff --git a/drivers/usb/gadget/file_storage.c
>>> b/drivers/usb/gadget/file_storage.c
>>> index b49d86e..45f58d9 100644
>>> --- a/drivers/usb/gadget/file_storage.c
>>> +++ b/drivers/usb/gadget/file_storage.c
>>> @@ -93,6 +93,8 @@
>>>   *     removable               Default false, boolean for removable media
>>>   *     luns=N                  Default N = number of filenames, number of
>>>   *                                     LUNs to support
>>> + *     fua=b[,b...]            Default false, booleans for ignore FUA
>>> flag
>>> + *                                     in SCSI WRITE(6,10,12) commands
>>
>> I wonder if it makes sense to make it per-LUN.  I would imagine that it's
>> great
>> to ignore FUA if the device has its own power supply in which case after
>> disconnect
>> the data won't be lost.  This is a per-device property not really per-LUN.
>>   As such
>> I'd make this option global for the gadget.
> Make sense only for removable media with one partition.
> Otherwise. why we have sync option per partition f.e., not per device?
>
by partition do you mean medium? They are different terms.
A storage medium may have 1 or more logical partitions. It is left upto the 
Host/user to decide how he wants to partition the medium.

file_storage driver does not deal with partitions. only mediums.

regards,
-roger
