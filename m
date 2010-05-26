Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934303Ab0EZIvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 04:51:04 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45604 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934048Ab0EZIvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 04:51:00 -0400
MIME-Version: 1.0
In-Reply-To: <20100525184621.89487735.akpm@linux-foundation.org>
References: <4BFB947E.9080509@aixigo.de> <20100525184621.89487735.akpm@linux-foundation.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 26 May 2010 10:50:42 +0200
Message-ID: <AANLkTil_-pV3jBkdBrWlz6iKr_lo2b3ZUFUvP8MFoByg@mail.gmail.com>
Subject: Re: 2.6.34 on Samsung P460: reset after "Waiting for /dev to be fully 
	populated"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Harald Dunkel <harald.dunkel@aixigo.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 03:46, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 25 May 2010 11:12:30 +0200 Harald Dunkel <harald.dunkel@aixigo.de> wrote:
>> Problem: At boot time I see a final message
>>
>>       Waiting for /dev to be fully populated
>>
>> then my laptop (Samsung P460) does a reset. The next
>> boot doesn't work, so I have to power-cycle the laptop.
>>
>> If I boot with "acpi=off", then 2.6.34 gets stuck instead.
>> The last 2 lines are
>>
>>       TCP reno registered
>>       Net: Registered protocol family 1
>>
>> Any helpful comment would be highly appreciated.
>
> ow, hard.
>
> I assume that the "Waiting for /dev to be fully populated" comes from
> udev?  Greg, do you know what might trigger that?
>
> Harald, I think the best (only?) way to fix this is for you to do a
> bisection search.  http://landley.net/writing/git-quick.html has some
> instructions.
>
> It's a bit of a pain to do, sorry.

A behavior like this is usually a kernel module that gets loaded which
hangs the box. The message comes from distro specific stuff, and not
from udev itself, so we can't know what exactly it is doing.

Did you wait for 3 minutes at least to let the boot processes run into
their timeouts?

Are you using an initramfs? If not, does init=/bin/sh work?

For current -git kernels it could be the FIONREAD bug, which breaks
all sorts of services using inotify. They all hang in a loop, it's not
only udevd:
  http://lkml.org/lkml/2010/5/23/100

Kay
