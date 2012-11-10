Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab2KJFr7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 00:47:59 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47110 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab2KJFrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 00:47:55 -0500
MIME-Version: 1.0
In-Reply-To: <20121110053334.GO2616@ZenIV.linux.org.uk>
References: <CANN689FmsFBjfiD8V-nQyDh+GtTF5B3SDUcuXc=3OeeN6JW0kw@mail.gmail.com>
	<20121110045104.GN2616@ZenIV.linux.org.uk>
	<CANN689GetguA+1bqKXC=Cq0SLcLqaqLsn5XGBZYVbWeBogX+zA@mail.gmail.com>
	<20121110053334.GO2616@ZenIV.linux.org.uk>
Date: Fri, 9 Nov 2012 21:47:54 -0800
Message-ID: <CANN689G+j0VS5JcFDx08XexZmqZ95YUPMVRd+3ji=8Fr3Q2R=Q@mail.gmail.com>
Subject: Re: Issues with "x86, um: switch to generic fork/vfork/clone" commit
From: Michel Lespinasse <walken@google.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 9:33 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Nov 09, 2012 at 08:57:58PM -0800, Michel Lespinasse wrote:
>> On Fri, Nov 9, 2012 at 8:51 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> > On Fri, Nov 09, 2012 at 08:36:53PM -0800, Michel Lespinasse wrote:
>> >> Hi,
>> >>
>> >> I'm having an issue booting current linux-next kernels on my test
>> >> machines. Userspace crashes when it's supposed to pivot to the rootfs.
>> >> With the loglevel=8 kernel parameter, the last messages I see are:
>> >>
>> >> Checking root filesystem in pivot_root init.
>> >> [    6.252717] usb 2-1: link qh256-0001/ffff880853ec9ab8 start 1 [1/0 us]
>> >> [    6.259419] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0000
>> >> [    6.292302] traps: hotplug[1633] general protection ip:f767c06b
>> >> sp:ffbb2d1c error:0 in libc-2.3.6.so[f7652000+126000]
>> >>
>> >> I ran a bisection and it turns out that
>> >> e52d03a3775841cc68d0ea9d86f2f09b603c41e6 (x86, um: switch to generic
>> >> fork/vfork/clone) is the commit breaking my setup. When reverting
>> >> that, I am able to boot linux-next (or mmotm, which is what I was
>> >> trying to do in the first place) without issues.
>> >>
>> >> Sorry for not having a more complete root cause at the moment - I'm
>> >> lacking some context as to what the change is trying to do.
>> >
>> > Hmm...  32bit native, presumably?
>>
>> This is running on a x86_64 system; I believe the userspace binaries
>> should be 64-bit as well.
>
> Curious...  After the second look at that sucker, it seems that you have
> 32bit hotplug(8) in there, and yes, it's clearly a 64bit kernel...  Could
> you check which binary it is and whether it's really 32bit or not?

Looks like /sbin/hotplug is a script on this system, using /bin/bash
as the interpreter, and /bin/bash is ELF 32-bit LSB executable.
(wow, I had no idea, I thought more of that system was 64-bits :)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
