Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab0HPQS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:18:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35702 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab0HPQSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:18:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=HtxBGuoHCe1aXUQITYqajlfVvvdZphokLcN42CWurwQrngb71AC85Cz8tkXhsJ62pa
         VYz2MMCgM/omO9SE6c7qpdeFVSTFZctDum+OI9t4Z26aTMp/2css6O1qTeaJv9oxz/A9
         es5apPG6M7IyXGUXtpRCPWsC/H743YbOB0CZc=
MIME-Version: 1.0
In-Reply-To: <20100816155516.GD11907@agk-dp.fab.redhat.com>
References: <AANLkTime9NS3Bk-8ZpovRNy9iEGJxwYw=-aZ38JoRa_3@mail.gmail.com>
	<20100814155401.GJ26032@agk-dp.fab.redhat.com>
	<AANLkTi=aJ7f5X9sMeA85KJxi+rzWhiZCZ2ZwriNEVFCT@mail.gmail.com>
	<20100815130336.GA24055@agk-dp.fab.redhat.com>
	<AANLkTinUuphqozgrSMNnrKxJrPWFp77y2TzdEwtuMD42@mail.gmail.com>
	<4C6943A0.9030708@redhat.com>
	<20100816142246.GA11907@agk-dp.fab.redhat.com>
	<AANLkTik0naaXsicwLgLeBUA0u2+BQQbww-44Fs_cHXHH@mail.gmail.com>
	<20100816155516.GD11907@agk-dp.fab.redhat.com>
Date: Tue, 17 Aug 2010 00:10:48 +0800
Message-ID: <AANLkTi=rm97rBs+Umvp7dNc_i5uzg6vhhVx=9BZH1AW4@mail.gmail.com>
Subject: Re: [dm-devel] [lvm-devel] linux-2.6.35+ causes LVM to fail with "
 device-mapper: version ioctl failed: Inappropriate ioctl for device"
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>,
        Zdenek Kabelac <zkabelac@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>, lvm-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 11:55 PM, Alasdair G Kergon <agk@redhat.com> wrote:
> On Mon, Aug 16, 2010 at 11:32:15PM +0800, Jeff Chua wrote:
>> It'll be nice if lvm returns a more meanful message like "ioctl
>> failed. Check /proc/misc to ensure the device is mapped correctly."
>
> No need - LVM should be quite capable of detecting/dealing with the problem.

Ok, cool.

>> To take care of it automatically with udev, I'm doing this in rc.S
>> if [ -f /sys/devices/virtual/misc/device-mapper/dev ]
>> then
>>         NODE=$(</sys/devices/virtual/misc/device-mapper/dev)
>>         rm -f /dev/mapper/control
>>         mknod /dev/mapper/control c ${NODE/:/ }
>
> The whole point of this change was to trigger the loading of dm-mod
> automatically for people using it as a module, based on using a known
> major/minor number instead of a dynamic one only known after the module
> has been loaded.  That needs to happen regardless of whether someone is
> using udev or not.
>
> This can all be fixed easily enough in userspace.

I'm not using module. It's all built-in to the kernel. Hopefully this
would be taken care of as well. That's why I had it in rc.S just
before the lvm filesystems are mounted.

Thanks,
Jeff.
