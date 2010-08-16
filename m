Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab0HPN46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 09:56:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab0HPN45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 09:56:57 -0400
Message-ID: <4C6943A0.9030708@redhat.com>
Date: Mon, 16 Aug 2010 15:56:48 +0200
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100624 Fedora/3.1-1.fc14 Thunderbird/3.1
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: Jeff Chua <jeff.chua.linux@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        lvm-devel@redhat.com
Subject: Re: [dm-devel] linux-2.6.35+ causes LVM to fail with " device-mapper:
 version ioctl failed: Inappropriate ioctl for device"
References: <AANLkTime9NS3Bk-8ZpovRNy9iEGJxwYw=-aZ38JoRa_3@mail.gmail.com>	<20100814155401.GJ26032@agk-dp.fab.redhat.com>	<AANLkTi=aJ7f5X9sMeA85KJxi+rzWhiZCZ2ZwriNEVFCT@mail.gmail.com>	<20100815130336.GA24055@agk-dp.fab.redhat.com> <AANLkTinUuphqozgrSMNnrKxJrPWFp77y2TzdEwtuMD42@mail.gmail.com>
In-Reply-To: <AANLkTinUuphqozgrSMNnrKxJrPWFp77y2TzdEwtuMD42@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 15.8.2010 16:13, Jeff Chua napsal(a):
> On Sun, Aug 15, 2010 at 9:03 PM, Alasdair G Kergon <agk@redhat.com> wrote:
>>> Just a vanilla linux. No udev.
>>
>> So likely a userspace problem where udev is now assumed to be present.
>>
>>>> Provide long listing of /dev/mapper and any dm/lvm devices in /dev.
>>
>> You can do that by running:
>>  ls -l /dev/mapper /dev/vg01
>> Also:
>>  cat /proc/devices
> 
> 253 device-mapper
> 
>>  cat /proc/misc
> 
> 236 device-mapper <== was at 60 before the new kernel
> 
> 
> Got it! Sorry, it's me being _dumb_!!!
> 
> With 2.6.35++, /dev/mapper/control has moved from 60 to 236!
> 
> So I fix it by recreating the control file with "mknod
> /var/mapper/control c 10 253".
> 
> I got this "internal error" when I activate/deactivate the volume
> group, but it seems ok. I could mount the volumes and so far it's all
> good.
> 
> # vgchange -a n vg01
>   Internal error: Maps lock 14217216 < unlock 14221312
>   Internal error: Maps lock 14221312 < unlock 14225408
>   Internal error: Maps lock 14225408 < unlock 14229504
>   Internal error: Maps lock 14229504 < unlock 14233600
>   Internal error: Maps lock 14233600 < unlock 14237696
>   Internal error: Maps lock 14237696 < unlock 14241792
>   0 logical volume(s) in volume group "vg01" now active
> 
> # vgchange -a y vg01
>   Internal error: Maps lock 14192640 < unlock 14196736
>   Internal error: Maps lock 14196736 < unlock 14200832
>   Internal error: Maps lock 14200832 < unlock 14204928
>   Internal error: Maps lock 14204928 < unlock 14209024
>   Internal error: Maps lock 14209024 < unlock 14213120
>   Internal error: Maps lock 14213120 < unlock 14217216
>   6 logical volume(s) in volume group "vg01" now active
> 
> Hopefully those errors above means no harm.
> 

Well error is usually error - so some harm under certain circumstances could
happen (low memory situation)...

But in this case I assume it's related to this kernel commit  which should fix
this problem ?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d7824370e26325c881b665350ce64fb0a4fde24a

Zdenek
