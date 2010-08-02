Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab0HBDiA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 23:38:00 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:17545 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab0HBDh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 23:37:59 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Donald Parsons <dparsons@brightdsl.net>
Subject: Re: Linux 2.6.35
Date: Sun, 1 Aug 2010 21:38:38 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-23-generic; KDE/4.4.2; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <1280716262.5125.42.camel@falcon.homelinux.org>
In-Reply-To: <1280716262.5125.42.camel@falcon.homelinux.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008012138.39036.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 01, 2010 08:31:02 pm Donald Parsons wrote:
> 2.6.35 still fails to boot for me, as first reported here:
>  http://lkml.indiana.edu/hypermail/linux/kernel/1007.3/01144.html
> 
> I've manually bisected it down to around May 20 between
>   2.6.34-git4 (boots) and 2.6.34-git5 (boot fails)
> Also -git[23] boot, and -git8, -rc[126], rc6-git[136] all fail.
> 
> Unfortunately first time I tried was with 2.6.35-rc6 and
> it failed to boot.
> 
> Failure when switching from initramfs to real /root?
> Removing kernel "quiet" param appears to show several
> lines listing:
> 
>   usb drives/hubs? followed by
>   dracut switching root (when booting works)
>               or
>   usb drives/hubs? followed by
>         (missing dracut... line)
>   No root device found
>   Boot has failed, sleeping forever.   (when it does not boot)
> 
> Grub, typical entry:
> title Fedora (2.6.35)
> 	root (hd0,0)
> 	kernel /vmlinuz-2.6.35 ro
> root=UUID=686dc496-8814-4c36-8fb7-5ded2916e825 rhgb
> SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us
> rdblacklist=nouveau init=/sbin/bootchartd
> 	initrd /initramfs-2.6.35.img
> 
> 
> My boot failure seems to be different than other two reported
> in the thread "2.6.35-rc6-git6: Reported regressions from 2.6.34"
> under Bug #16173 and #16228

Will it boot with the "pci=nocrs" option?  If so, please open a
report at https://bugzilla.kernel.org, mark it a regression, assign
it to me, and attach the complete dmesg log.  And please respond to
this thread with a pointer to the bugzilla.

Otherwise, a complete console log should have a clue.  The best
thing would be a log from a serial console or netconsole, with
"ignore_loglevel".

Thanks a lot for your report!

Bjorn
