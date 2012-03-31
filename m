Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2CaI5y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 04:57:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54346 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab2CaI5v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 04:57:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP12--1VDVLpST9NGhu5GH2U=T3-aEn-ZPuZfA04QAZSqFg@mail.gmail.com>
References: <1333127067-2043-1-git-send-email-levinsasha928@gmail.com>
 <20120330204235.GA883@kroah.com> <alpine.LFD.2.02.1203302247130.2542@ionos>
 <201203302105.52987.arnd@arndb.de> <20120330211744.GA16314@kroah.com>
 <CA+1xoqeWLrU46gBJVY1j1S2_wNkvCvG-CdK0DKx5dgWR=EmU+Q@mail.gmail.com>
 <20120330234306.GC21328@kroah.com> <CAPXgP12--1VDVLpST9NGhu5GH2U=T3-aEn-ZPuZfA04QAZSqFg@mail.gmail.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Sat, 31 Mar 2012 10:57:30 +0200
Message-ID: <CA+1xoqdNZ-xxuvaTXVq-C5RqxGa9TpUruaRrq7HSYsJ0LxKV4Q@mail.gmail.com>
Subject: Re: [PATCH] kmsg: Use vmalloc instead of kmalloc when writing
To: Kay Sievers <kay@vrfy.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>, viro@zeniv.linux.org.uk,
        davej@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 2:02 AM, Kay Sievers <kay@vrfy.org> wrote:
> On Sat, Mar 31, 2012 at 01:43, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Sat, Mar 31, 2012 at 12:02:39AM +0200, Sasha Levin wrote:
>>> On Fri, Mar 30, 2012 at 11:17 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>> > On Fri, Mar 30, 2012 at 09:05:52PM +0000, Arnd Bergmann wrote:
>>> >> On Friday 30 March 2012, Thomas Gleixner wrote:
>>> >> > I think so. This is an interface to inject stuff into dmesg. Limiting
>>> >> > that to a reasonable size makes sense. We can probably limit it to
>>> >> > something small like 1024, but I don't know about the "ideas" of those
>>> >> > folks who think that it's a great idea to do it at all.
>>> >>
>>> >> I guess a page would be a reasonable size, similar to what we do for
>>> >> sysfs.
>>> >
>>> > Ok. Sasha, as you seem to have noticed this, care to dig in syslog and
>>> > systemd to get an idea of the buffer sizes they are expecting to pass
>>> > into kmsg, and if they can handle a short write properly?  If so,
>>> > restricting it to a page is fine with me, otherwise we might want to
>>> > make it a bit bigger.
>>>
>>> systemd seems to use posix LINE_MAX sized buffers, syslog-ng uses
>>> dynamic strings, but it chews them one line at the time.
>>
>> Ok, care to update this patch with a max size?
>>
>> And again, does systemd and syslog-ng handle short writes properly?
>
> Printk has a static scratch buffer of 1024, we can not really process
> more than that, so we can limit the /dev/kmsg write() to the same
> size, I guess.

That's odd. I've tested it by writing 8000 chars into /dev/kmsg, and
all of them came out on the printk, and I saw all of them in my dmesg.

This means that while printk may be somehow limited to 1024, it's
still possible to dump more than that into dmesg.
