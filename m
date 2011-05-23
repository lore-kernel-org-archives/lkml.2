Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab1EWSGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:06:32 -0400
Received: from edu-smtp-02.edutel.nl ([88.159.1.172]:63052 "EHLO
	edu-smtp-02.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933076Ab1EWSGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:06:25 -0400
Message-ID: <4DDAA219.2020507@neli.hopto.org>
Date: Mon, 23 May 2011 20:06:17 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Randy Dunlap <rdunlap@xenotime.net>, Jens Axboe <axboe@kernel.dk>,
        TejunHeo <tj@kernel.org>, lud <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: USB stick as root device does not work
References: <Pine.LNX.4.44L0.1105231332090.2020-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1105231332090.2020-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Alan Stern wrote:
> On Mon, 23 May 2011, Randy Dunlap wrote:
> Better to ask people familiar with the block layer (CC'ed).

I found out what happened: I use LILO, and lilo was not passing
root=/dev/sdb1 on the commandline, but root=811. However, I didn't see
that since on i386 that part had already scrolled off-screen. I found
out by accident, due to a user space program trying to parse that,
expecting a string, getting a number :-).

Using the following in my lilo.conf:

	append="root=/dev/sdb1 rootwait"
instead of
	root=/dev/sdb1

works perfectly. Maybe this information is useful for somebody else; I
did not find it using a quick google.

Thanks for your attention.

Micha


>> On Sun, 22 May 2011 16:13:17 +0200 Micha Nelissen wrote:
>>
>>> Hi,
>>>
>>> Using USB stick as root device does not work for me. I specify
>>> 'root=/dev/sdb1 rootwait' on the kernel commandline, but the kernel does
>>> not wait for the USB stick to be scanned and its partitions found. I
>>> have a harddisk which is /dev/sda, and this USB stick would be /dev/sdb.
>>>
>>> I think blk_lookup_devt returns the block device number even if it does
>>> not exist yet, and init/do_mounts.c:473 therefore skips waiting:
>>>
>>>         if ((ROOT_DEV == 0) && root_wait) {
>>>
>>> due to ROOT_DEV having become non-zero already.
>>>
>>> If I use the commandline: 'root=/dev/sdb1 rootdelay=5' then it does
>>> mount and boot properly. However, using rootwait seems safer and faster
>>> to me, that it's meant for this use case.
>>>
>>> Thanks for any pointers,
>>>
>>> Micha
>>> --
>> ---
>> ~Randy
>> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> 
