Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab0HBQCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:02:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60014 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab0HBQCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:02:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:from:in-reply-to:mime-version:date:message-id:subject:to
         :cc:content-type;
        b=ed59wrZmy7afYqHe+w6JmAl1mQZ9YpuIDsW4Ylyf/2aoreGfIoQDd7n4qS7SS/yDi2
         kCDVACHZAEddd8Qgyne1fkTIXZLMJo+RM+BYS5y3tu6By89V9bLuKMU1atIUejuqdwaA
         dN/ZNmNPe0UoxBS+0OnGd7gPyiL2/w9bHQTKE=
References: <1280716262.5125.42.camel@falcon.homelinux.org> 
	<201008012138.39036.bjorn.helgaas@hp.com> <1280722876.5125.83.camel@falcon.homelinux.org> 
	<201008020748.09968.bjorn.helgaas@hp.com>
From: Harald Hoyer <harald.hoyer@gmail.com>
In-Reply-To: <201008020748.09968.bjorn.helgaas@hp.com>
Mime-Version: 1.0 (iPad Mail 7B367)
Date: Mon, 2 Aug 2010 17:59:12 +0200
Message-ID: <7975590447314667432@unknownmsgid>
Subject: Re: Linux 2.6.35
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Donald Parsons <dparsons@brightdsl.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dracut does not include the SATA module by default. Either force
dracut to include the module in the initramfs, or use build it in the
Kernel.

Am 02.08.2010 um 15:48 schrieb Bjorn Helgaas <bjorn.helgaas@hp.com>:

> On Sunday, August 01, 2010 10:21:16 pm Donald Parsons wrote:
>> On Sun, 2010-08-01 at 21:38 -0600, Bjorn Helgaas wrote:
>>> On Sunday, August 01, 2010 08:31:02 pm Donald Parsons wrote:
>>>> 2.6.35 still fails to boot for me, as first reported here:
>>>> http://lkml.indiana.edu/hypermail/linux/kernel/1007.3/01144.html
>>>>
>>>> I've manually bisected it down to around May 20 between
>>>>  2.6.34-git4 (boots) and 2.6.34-git5 (boot fails)
>>>> Also -git[23] boot, and -git8, -rc[126], rc6-git[136] all fail.
>>>>
>>>> Unfortunately first time I tried was with 2.6.35-rc6 and
>>>> it failed to boot.
>>>>
>>>> Failure when switching from initramfs to real /root?
>>>> Removing kernel "quiet" param appears to show several
>>>> lines listing:
>>>>
>>>>  usb drives/hubs? followed by
>>>>  dracut switching root (when booting works)
>>>>              or
>>>>  usb drives/hubs? followed by
>>>>        (missing dracut... line)
>>>>  No root device found
>>>>  Boot has failed, sleeping forever.   (when it does not boot)
>>>>
>>>> Grub, typical entry:
>>>> title Fedora (2.6.35)
>>>> 	root (hd0,0)
>>>> 	kernel /vmlinuz-2.6.35 ro
>>>> root=UUID=686dc496-8814-4c36-8fb7-5ded2916e825 rhgb
>>>> SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us
>>>> rdblacklist=nouveau init=/sbin/bootchartd
>>>> 	initrd /initramfs-2.6.35.img
>>>>
>>>>
>>>> My boot failure seems to be different than other two reported
>>>> in the thread "2.6.35-rc6-git6: Reported regressions from 2.6.34"
>>>> under Bug #16173 and #16228
>>>
>>> Will it boot with the "pci=nocrs" option?  If so, please open a
>>
>> No, I tried this on a few attempts when I saw it mentioned under
>> bug #16228.  But it had no effect/benefit.  Sorry, I should have
>> mentioned this.
>>
>>> report at https://bugzilla.kernel.org, mark it a regression, assign
>>> it to me, and attach the complete dmesg log.  And please respond to
>>> this thread with a pointer to the bugzilla.
>>>
>>> Otherwise, a complete console log should have a clue.  The best
>>> thing would be a log from a serial console or netconsole, with
>>> "ignore_loglevel".
>>
>> Maybe I will try netconsole tomorrow.  But is Ethernet up when
>> this boot failure happens?  I think not, since initramfs should
>> not need networking.
>
> Netconsole has special kernel support that doesn't require the normal
> networking stack to be configured, so it works quite early.  You
> would want to build your networking driver into the kernel for the
> most benefit.
>
> If that doesn't work, you could try capturing the log on VGA with a
> digital camera or video camera, possibly with "boot_delay=" to
> slow things down.
>
>> Should I try building sata driver into kernel?
>
> I doubt that will make a difference.  It seems like the problem
> is that we don't find your root filesystem, probably because there's
> something wrong with the HBA leading to that device.  For example,
> maybe the PCI core mistakenly moved or disabled the adapter, or
> there's some problem with its interrupt.
>
> Bjorn
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
