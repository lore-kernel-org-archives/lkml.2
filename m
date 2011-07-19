Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab1GSUvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 16:51:53 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:45220 "EHLO Ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab1GSUvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 16:51:52 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jul 2011 16:51:51 EDT
Message-ID: <4E25ED24.6020404@tlinx.org>
Date: Tue, 19 Jul 2011 13:46:28 -0700
From: "Linda A. Walsh" <lvm@tlinx.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.8.1.24) Gecko/20100228 Thunderbird/2.0.0.24 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: LVM general discussion and development <linux-lvm@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-lvm] mount's (&udev's) dirty little naming problem
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Luca Berra wrote:
> On Tue, Jul 19, 2011 at 12:57:21AM -0700, Linda A. Walsh wrote:
>>   (sorry for the length of this, in advance, but I've tried to give
>> this some though...(maybe not enough/maybe too much!) ;-) )
>>
>> Luca Berra wrote:
>> > On Mon, Jul 11, 2011 at 03:16:31AM +0100, Alasdair G Kergon wrote:
>> >> The canonical name to use is /dev/<vgname>/<lvname>. ...
>> >>
>> >> [~Other forms - dm-N and /dev/mapper/X-Y are internal and ...
>> >> there'll probably be some further changes to workaround other
>> >> arbitrary   udev restrictions...~]
>> >>
>> >> Different versions of df and mount haven't always retained this
>> >> preferred form for their output.
>> >>
>> > note that on a freshly installed rhel 6.1 i have this in fstab
>> >
>> > /dev/mapper/vg_candela--lv_root / ext4 ....
>>
>> ---
>>
>>   Why are there two dashes between the VG&LG? 
> woops, typo, sorry for that  it is :
> /dev/mapper/vg_candela-lv_root / ext4 defaults 1 1
>
> L. 
------
   That's consistent with current behavior -- the problem is
in the current name mangling   (i,e. mounts by  "/dev/VG/LV"   get
xlated into   "/dev/mapper/<mangled-VG>-<mangled-LV>", where
at least one manglement is xlating "-" into "--".  But I've already been
told that future manglements may be added due to limitations in udev.

   For non LV devs, it would be like having  '/dev/sdc2'  xlated
into  '(hd2,<rand>)' (where <rand> = some not always consistent integer)
which, of course would be silly! ( ;-) ), or  xlating
LABEL="MyDisk-Label" =>  '/dev'disk/by-label/MYDISK--LABEL'
(with 'My-Label' being 'canonicalized', for some definition of thereof,
into some other value), vs. now, it's given the real devname
(/dev/sdc<x>) (which is FINE with me...; it's the real HW name that
the kernel uses, whereas 'label=xxx was a syntax I was encouraged
to use as part of the suse boot system, as 'everything works with labels'
(well, lets not speak about lilo, or booting from an HD w/o a ram disk,
as we'll just drop support for those options...*cough*)....

    As noted, the current behavior isn't giving/using either
the 'real devname' /dev/dm-[x], NOR the user name, but a mangled name 
making it the worst of all worlds, as there is no easy way to find
out the LV and VG of the device mounted on a given mount point.

    To get around this == and tell me if I'm wrong, I have to use
lvm, to output a list of all VG,LV groups.

Then using a [perl] script (I suppose BASH's Associative arrays might
work too, but familiarity points toward perl at this point), I can
build up an Assoc array to map devno's -> VG,LV, then use the devno
of the mountpoint as an index into that.

    That level of complexity is so completely LAME just to find out
the name I used to mount a FS on some mount point!.... 

    If there is an easier way, please, hit me with a clue stick!

-l

