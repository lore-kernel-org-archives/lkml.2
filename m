Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab2IMJaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 05:30:00 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39119 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab2IMJ36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 05:29:58 -0400
Message-ID: <5051A793.3010107@gmail.com>
Date: Thu, 13 Sep 2012 10:29:55 +0100
From: Alan Jenkins <alan.christopher.jenkins@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Christoph Jung <jung@codemercs.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: issues with unknown/new alias [retraction]
References: <50518A75.4030608@codemercs.com> <50519E25.7080007@gmail.com> <50519FF1.9040002@codemercs.com>
In-Reply-To: <50519FF1.9040002@codemercs.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/09/12 09:57, Christoph Jung wrote:
> Am 13.09.2012 10:49, schrieb Alan Jenkins:
>> On 13/09/12 08:25, Christoph Jung wrote:
>>> Hello,
>>>
>>> I am from the company "Code Mercenaries GmbH" from Germany. We have 
>>> some USB HID devices wich work with Linux.
>>> Since kernel version 2.6 our default products will be included in 
>>> the kernel.
>>>
>>> Devicedetails
>>> VendorID: 0x07C0
>>> ProductIDs: 0x1500, 0x1501, 0x1511, 0x1512, 0x1503
>>> Devicename: iowarrior
>>>
>>> Now we have some new custom product IDs but this two new devices get 
>>> no node in dev/usb/ , but I can find the with "lsusb".
>>> If I run "modinfo iowarrior" there will be 5 alias (with the default 
>>> pIDs) .
>>>
>>> The two new pIDs are: 0x158A, 0x158B
>>>
>>> I have not much experiance with linux (I work with Ubuntu 12.04). 
>>> What have be done to get the device nodes to work with them?
>>> Have I add some rules? Or have I edit the iowarrior.ko?
>>>
>> Argh, sorry, I misread your email and went off on one.
>>
>> You will indeed need to "edit iowarrior.ko".  I.e. change the C 
>> source code to include the new pIDs, recompile, test, get patches 
>> merged into the mainline kernel etc :).
>>
>> It's also possible to test new devices with an old driver, i.e. 
>> before you modify it.  Possible instructions: http://www.ha19.no/usb/
>>
>> Alan
>>
>>
> Ah ok but where will I find the sourcecode for iowarrior.ko ?
> I have no idea about compiling, patching in linux
>
> Christoph
>

The kernel is all one big tree.  The file you're looking for is 
drivers/usb/misc/iowarrior.c.  (Preview at 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/usb/misc/iowarrior.c). 
The change you're talking about should be fairly straightforward - just 
look for the existing ids.

Step 1 for me has always been to compile a whole kernel. Unfortunately 
that's a bit of learning curve.  I'm not sure which resources to recommend.

Alan
