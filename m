Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab0HOQBM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 12:01:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44720 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758299Ab0HOQBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 12:01:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=u1CnLlON2xxAg0nRGZSU1fAaj2IFt64M2crB3klerPQBbvdU2VJdFkHqSZNn+AZf9+
         xi/0bcqUIMhObnpkokFil4ncz9T12dch/TAadDsScXbA36rrUYRzRIarbWYrtxdARLXB
         SxH0oeeGOE0FPxc1rU3WLUL0mGggwyioc13Ow=
MIME-Version: 1.0
In-Reply-To: <20100815130336.GA24055@agk-dp.fab.redhat.com>
References: <AANLkTime9NS3Bk-8ZpovRNy9iEGJxwYw=-aZ38JoRa_3@mail.gmail.com>
	<20100814155401.GJ26032@agk-dp.fab.redhat.com>
	<AANLkTi=aJ7f5X9sMeA85KJxi+rzWhiZCZ2ZwriNEVFCT@mail.gmail.com>
	<20100815130336.GA24055@agk-dp.fab.redhat.com>
Date: Sun, 15 Aug 2010 22:13:47 +0800
Message-ID: <AANLkTinUuphqozgrSMNnrKxJrPWFp77y2TzdEwtuMD42@mail.gmail.com>
Subject: Re: [dm-devel] linux-2.6.35+ causes LVM to fail with " device-mapper:
 version ioctl failed: Inappropriate ioctl for device"
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>,
        device-mapper development <dm-devel@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>, lvm-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 9:03 PM, Alasdair G Kergon <agk@redhat.com> wrote:
>> Just a vanilla linux. No udev.
>
> So likely a userspace problem where udev is now assumed to be present.
>
>> > Provide long listing of /dev/mapper and any dm/lvm devices in /dev.
>
> You can do that by running:
>  ls -l /dev/mapper /dev/vg01
> Also:
>  cat /proc/devices

253 device-mapper

>  cat /proc/misc

236 device-mapper <== was at 60 before the new kernel


Got it! Sorry, it's me being _dumb_!!!

With 2.6.35++, /dev/mapper/control has moved from 60 to 236!

So I fix it by recreating the control file with "mknod
/var/mapper/control c 10 253".

I got this "internal error" when I activate/deactivate the volume
group, but it seems ok. I could mount the volumes and so far it's all
good.

# vgchange -a n vg01
  Internal error: Maps lock 14217216 < unlock 14221312
  Internal error: Maps lock 14221312 < unlock 14225408
  Internal error: Maps lock 14225408 < unlock 14229504
  Internal error: Maps lock 14229504 < unlock 14233600
  Internal error: Maps lock 14233600 < unlock 14237696
  Internal error: Maps lock 14237696 < unlock 14241792
  0 logical volume(s) in volume group "vg01" now active

# vgchange -a y vg01
  Internal error: Maps lock 14192640 < unlock 14196736
  Internal error: Maps lock 14196736 < unlock 14200832
  Internal error: Maps lock 14200832 < unlock 14204928
  Internal error: Maps lock 14204928 < unlock 14209024
  Internal error: Maps lock 14209024 < unlock 14213120
  Internal error: Maps lock 14213120 < unlock 14217216
  6 logical volume(s) in volume group "vg01" now active

Hopefully those errors above means no harm.

Thanks,
Jeff
