Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1DTSII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 14:08:08 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:51533 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1DTSIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 14:08:06 -0400
Message-ID: <4DAF20FE.2040603@ahsoftware.de>
Date: Wed, 20 Apr 2011 20:07:58 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Implement /dev/byte (a generic byte source similiar
 to /dev/zero)
References: <1303126676-3456-1-git-send-email-holler@ahsoftware.de> <1303126676-3456-2-git-send-email-holler@ahsoftware.de> <20110420105754.GA14722@ucw.cz>
In-Reply-To: <20110420105754.GA14722@ucw.cz>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.04.2011 12:57, schrieb Pavel Machek:
> On Mon 2011-04-18 13:37:56, Alexander Holler wrote:
>> This device outputs by default 0xff instead 0 which makes more sense
>> than 0 to clear e.g. FLASH based devices.
>
> Well, now you should provide example where you mmap /dev/byte, then
> write() the flash directly from the mapping.
>
> ... hmm, that brings good question: what happens on existing mappings
> when the byte is changed?

I never used mmap (never had a need to use it) explicit and barely know 
what it does. And I don't see a reason to use mmap on /dev/byte. 
Otherwise I would have known before the reason why /dev/zero exists. ;)

So I can't answer what happens when someone uses mmap on /dev/byte and 
changes the value while the map exists (without testing it by myself).

>> To make the device more general usable, the value it outputs is changeable
>> on a per file descriptor basis through simple writes to it.
>> Values can be decimal (0 - 255), octal (00 - 0377) or hex (0x0 - 0xff).
>> For other values (or strings) written to it, the write operation returns an
>> error and the subsequent output is undefined.
> ...
>>   # Create a file of size 10GB and filled with 0xaa.
>> exec 5<>/dev/byte # Open /dev/byte and assign fd 5 to it
>> echo 0xaa>&5     # Instruct the device to output 0xaa
>
> That's seriously strange. /dev/byte should be changeable... by writing
> bytes.

As I've written before, that was the only solution I could come up with 
which makes it possible to change the output of /dev/byte on the fly 
without introducing race conditions (except ioctl). I know, it's ugly, 
but works, at least for common (read) file operations.

So it seems the only proper solution would be to use minors which would 
make such a device static.
So I better stick to something in userland, even when I would like to 
have at least /dev/byteFF. Chances seem to be minimal to get such 
included in the kernel if no one else sees a usage pattern for such.

Regards,

Alexander
