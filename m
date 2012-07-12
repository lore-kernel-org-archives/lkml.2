Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030732Ab2GLRmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:42:43 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:40644 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030404Ab2GLRml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:42:41 -0400
Message-ID: <4FFF0C8D.5000409@msgid.tls.msk.ru>
Date: Thu, 12 Jul 2012 21:42:37 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: werner <w.landgraf@ru.ru>
CC: linux-kernel@vger.kernel.org
Subject: Re: 3.5-rcX : Big problem with root device returning
References: <web-768955641@zbackend1.aha.ru>
In-Reply-To: <web-768955641@zbackend1.aha.ru>
X-Enigmail-Version: 1.4.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.07.2012 16:08, werner wrote:
> There is a big problem since 3.5-rc1 which potentially mess the installations
> 
> rdev   don't give longer back the root device like /dev/sda1  , but in the bios form like 0x80010300

Note rdev returns information which is written to kernel image, not
information about actual device the system booted from.

> rdev is essential for the installation programs  and for the installation f.ex. of lilo .   It's not conveniente to rely on the bios numbers, because on some meinbords they change depending which boot order you select in BIOS, or only if you select another boot device in the bios boot menu with F12.   Whilst /dev/sdXY is more reliable.
> 
>   rdev is an old basical function which always worked correctly, until now.

rdev utility is obsolete, it is not present in current util-linux anymore,
because it makes just no sense nowadays.  Storing root device in the
kernel image has been obsoleted long ago by boot loaders providing
kernel command line and root= parameter.  More, root device is often
not mounted by kernel itself, but by initramfs (which become an integral
part of the kernel image).

It is obsolete because of 3 reasons:

1) you've kernel command line from the bootloader to store this and
  other info
2) it is not guaranteed that the next reboot the same device will be
 using the same /dev/sdX node, since they're discovered dynamically
 (in this sense, bios codes are more reliable, and filesystem UUIDs or
 labels are the right way to go)
3) static device numbers are slowly going away too, very few tools
 left which knows about particular major,minor pairs.

> The error starts with 3.5-rc1 and is not corrected until 3.5-rc6 .    If I go back to an earlier kernel, 3.4 or older, then the same installation works correct (rdev gives /dev/sda1 ) and if I go back then again to 3.5-rcX it's again wrong (rdev gives 0x80010300).    Thus, this seems a wrong manner how the kernel gives back the root device,  or interact with rdev.      It's also possible that this problem happens only under any kernel compilation option,   so that below I give the differences in config between 3.4 and 3.5-rc1
> 
> This problem should be fixed most quickly,  rdev always have to work correctly.

There's no problem, so nothing to fix.

Thanks,

/mjt
