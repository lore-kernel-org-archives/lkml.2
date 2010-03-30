Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab0C3M67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 08:58:59 -0400
Received: from lucidpixels.com ([75.144.35.66]:43353 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755738Ab0C3M65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 08:58:57 -0400
Date: Tue, 30 Mar 2010 08:58:55 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.33: Xorg+khubd lockup (D-state) BUG / ioctl EVIOCGNAME
 failed: Inappropriate ioctl for device / PreInit returned NULL
In-Reply-To: <alpine.DEB.2.00.1003291443330.10153@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.1003300848430.20258@p34.internal.lan>
References: <Pine.LNX.4.44L0.1003291253410.3358-100000@iolanthe.rowland.org> <alpine.DEB.2.00.1003291443330.10153@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Mar 2010, Justin Piszcz wrote:

>
>
> On Mon, 29 Mar 2010, Alan Stern wrote:
>
>> On Mon, 29 Mar 2010, Justin Piszcz wrote:
>> 
>> Yes it does.  Maybe there's something wrong with the way your email
>> client extracted the patch from the message.
> You're correct, sorry about that, when it recurs and I have the usbmon
> trace output I will send it along.
>
>> 
>>> It also fails against 2.6.34-rc2, can you diff -u and show the patch so
>>> I can patch manually or include a patch against 2.6.33 or 2.6.34-rc2?
>> 
>> That _was_ a "diff -u"-style patch.
>> 
>> Alan Stern
>> 
>

Hello!

I have all the data you asked for:

1. # cat 0u > /tmp/0u.mon.out
2. The kernel log file.

Also 3.
# date; cat 0u > /tmp/0u_after_disconnect_usb.mon.out
Tue Mar 30 08:50:45 EDT 2010

Here, I ran this, disconnected the mouse and re-connected it.

All files are here:

http://home.comcast.net/~jpiszcz/20100330/0u.mon.out.bz2
http://home.comcast.net/~jpiszcz/20100330/0u_after_disconnect_usb.mon.out.bz2
http://home.comcast.net/~jpiszcz/20100330/kern.log.bz2

Hopefully something can be found!

It has happened again, in addition, this is a LONG outstanding bug since
2006 or 2007, see below research:

URL:
http://forums.linuxmint.com/viewtopic.php?f=55&t=44951&p=259375
DESCRIPTION:
Screen Randomly Freezes
Sometimes the screen just freezes and the cursor will not move, and nothing responds at all. The only way (I have found so far) is to hold down the power button until the whole laptop powers off.
CHIPSET:
00:0b.0 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3)
00:0b.1 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3)

URL:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=476633
DESCRIPTION:
Debian Bug report logs - #476633
linux-image-2.6.24-1-686: USB mouse hangs system
CHIPSET:
00:0b.0 USB Controller [0c03]: nVidia Corporation MCP51 USB Controller [10de:026d] (rev a2) (prog-if 10 [OHCI])

URL:
https://bugzilla.redhat.com/show_bug.cgi?id=215539
DESCRIPTION:
https://bugzilla.redhat.com/show_bug.cgi?id=215539
CHIPSET:
  Bug 215539 - Unpredictable freeze of mouse and/or keyboard on amd64 x2 nvidia chipset (Dell E521)
Aliases: 
Summary:        Unpredictable freeze of mouse and/or keyboard on amd64 x2 nvidia chipset (Del...
00:0b.0 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3)

A good post here:
Luis Felipe Marzagao      2006-12-04 21:57:16 EST

Hello. This bug is *serious* because it happens with all nforce 430 chipsets.
The problem seems to be with that specifc chipset.

This bug is a duplicate of:
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=201445

Here is a lot of info about this issue:
http://forums.fedoraforum.org/showthread.php?t=136879&page=1&pp=15
https://launchpad.net/distros/ubuntu/+source/linux-source-2.6.17/+bug/67734
http://forums.us.dell.com/supportforums/board/message?board.id=sw_other&message.id=54328&view=by_date_ascending&page=1



Justin.

