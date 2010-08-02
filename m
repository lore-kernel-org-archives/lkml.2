Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab0HBQIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:08:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58481 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab0HBQIN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:08:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WnSviAH5xqGLWWbyRUZkUXQt8+M3nXRMTzTWwKPinESHZfRMFzo7zfg6WdqBB86JHs
         1W5MJcXHPOtVx7B20aXzx0t1Wo+p3nCX7cba7UMY8mIasoS/iiw8DYX0b1oK5ftuBuc3
         AvlvADl0fip9/0qLCdgTQCwCXvKqgXFymbTc4=
MIME-Version: 1.0
In-Reply-To: <1280722876.5125.83.camel@falcon.homelinux.org>
References: <1280716262.5125.42.camel@falcon.homelinux.org>
	<201008012138.39036.bjorn.helgaas@hp.com>
	<1280722876.5125.83.camel@falcon.homelinux.org>
Date: Mon, 2 Aug 2010 18:08:12 +0200
Message-ID: <AANLkTimK8sv5aWfcv_BAmipgVnukR5NJsZQOXYbb2LAH@mail.gmail.com>
Subject: Re: Linux 2.6.35
From: Harald Hoyer <harald.hoyer@gmail.com>
To: Donald Parsons <dparsons@brightdsl.net>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 2, 2010 at 6:21 AM, Donald Parsons <dparsons@brightdsl.net> wrote:
> On Sun, 2010-08-01 at 21:38 -0600, Bjorn Helgaas wrote:
>> On Sunday, August 01, 2010 08:31:02 pm Donald Parsons wrote:
>> > 2.6.35 still fails to boot for me, as first reported here:
>> >  http://lkml.indiana.edu/hypermail/linux/kernel/1007.3/01144.html
>> >
>> > I've manually bisected it down to around May 20 between
>> >   2.6.34-git4 (boots) and 2.6.34-git5 (boot fails)
>> > Also -git[23] boot, and -git8, -rc[126], rc6-git[136] all fail.
>> >
>> > Unfortunately first time I tried was with 2.6.35-rc6 and
>> > it failed to boot.
>> >
>> > Failure when switching from initramfs to real /root?
>> > Removing kernel "quiet" param appears to show several
>> > lines listing:
>> >
>> >   usb drives/hubs? followed by
>> >   dracut switching root (when booting works)
>> >               or
>> >   usb drives/hubs? followed by
>> >         (missing dracut... line)
>> >   No root device found
>> >   Boot has failed, sleeping forever.   (when it does not boot)
>> >
>> > Grub, typical entry:
>> > title Fedora (2.6.35)
>> >     root (hd0,0)
>> >     kernel /vmlinuz-2.6.35 ro
>> > root=UUID=686dc496-8814-4c36-8fb7-5ded2916e825 rhgb
>> > SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us
>> > rdblacklist=nouveau init=/sbin/bootchartd
>> >     initrd /initramfs-2.6.35.img
>> >
>> >
>> > My boot failure seems to be different than other two reported
>> > in the thread "2.6.35-rc6-git6: Reported regressions from 2.6.34"
>> > under Bug #16173 and #16228
>>
>> Will it boot with the "pci=nocrs" option?  If so, please open a
>
> No, I tried this on a few attempts when I saw it mentioned under
> bug #16228.  But it had no effect/benefit.  Sorry, I should have
> mentioned this.
>
>> report at https://bugzilla.kernel.org, mark it a regression, assign
>> it to me, and attach the complete dmesg log.  And please respond to
>> this thread with a pointer to the bugzilla.
>>
>> Otherwise, a complete console log should have a clue.  The best
>> thing would be a log from a serial console or netconsole, with
>> "ignore_loglevel".
>
> Maybe I will try netconsole tomorrow.  But is Ethernet up when
> this boot failure happens?  I think not, since initramfs should
> not need networking.
>
> Should I try building sata driver into kernel?  Oh, I am using
> ext3, and fdisk -l shows:

# dracut --add-drivers "sata" ....

or edit /etc/dracut.conf:

add_drivers+=" sata "
