Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab0KPQNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 11:13:24 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51057 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab0KPQNX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 11:13:23 -0500
MIME-Version: 1.0
In-Reply-To: <20101116155717.6671e484@lxorguk.ukuu.org.uk>
References: <1289922400.1253.3.camel@yio.site> <20101116155717.6671e484@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 16 Nov 2010 17:13:07 +0100
Message-ID: <AANLkTimn7zyEjLhmOmUVQGnLDfM-A_uEgWETsM3nsyuY@mail.gmail.com>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Lennart Poettering <lennart@poettering.net>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 16:57, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Tue, 16 Nov 2010 16:46:40 +0100
> Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>> commit be0d5f02c9194fe41c1aad11d7282db117bda938
>> Author: Kay Sievers <kay.sievers@vrfy.org>
>> Date:   Tue Nov 9 18:53:59 2010 +0100
>>
>>     tty: add 'active' sysfs attribute to tty0 and console device
>
> This is all somewhat weird.
>
>>     Userspace can query the actual virtual console, and the configured
>>     console devices behind /dev/tt0 and /dev/console.
>
> All the other vt interface code is in the vt driver, the ioctls for it
> are in the vt driver and a query about what is the active vt only has
> meaning within that context as you need to post a waitevent first to
> track changes during the query. So if you need a VT_GETACTIVE interface
> put it in the tty ioctls where it can be properly locked and used.
>
>> +What:                /sys/class/tty/tty0/active
>> +Date:                Nov 2010
>> +Contact:     Kay Sievers <kay.sievers@vrfy.org>
>> +Description:
>> +              Shows the currently active virtual console
>> +              device, like 'tty1'.
>> +              The file supports poll() to detect virtual
>> +              console switches.
>
> NAK this, its a nonsense interface
>
> Seriously what use is an interface that tells you "what the console might
> have been", this is why we have a proper event tracking interface instead.

You mean the VT_WAITEVENT? Sleeping ioctls() can't be used. The time
between the check for the current, and you go to sleep in the ioctl()
for teh next is a window which isn't covered with such interface.

And 'might have been' does not matter, it's fine. We just need change
notification, and can query the actual vt again.

Kay
