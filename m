Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab1FRUL2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 16:11:28 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:50008 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750798Ab1FRUL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 16:11:27 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: 3.0 version number: good to make links ; linux utils: correct
 fdisk, rdev
To: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Sat, 18 Jun 2011 16:11:20 -0400
Message-ID: <web-550957181@zbackend1.aha.ru>
In-Reply-To: <BANLkTimTjcXPfiPDvyMEgRCH0EA2E9mMpQ@mail.gmail.com>
References: <web-546810453@zbackend1.aha.ru>
 <BANLkTimTjcXPfiPDvyMEgRCH0EA2E9mMpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I read people have problems with the 3.0 vs. 3.0.0 kernel 
version.

I also think that the version of the package and 
internelly that of the kernel should be equal.

However, that's not a real problem. It's suficient to make 
just links. With this, everything works completely normal, 
also depmod etc.  , since 3.0-rc1

Although this is trivial, because of the big discusion 
about this, one should tell this the people.  Simply put 
in the kernel slackbuild script, to make such links, 
always if the package / source .bz2 number is diferent to 
the version number in makefile.    Also in the kernel 
source makefile should be included to make auch links 
automatically always if the package and kernel version 
numbers are different.

What however seems to be removed from the linux kernel 
tools, is rdev .  That should be put back, because that's 
important, specially for building distro kernels,  to put 
in vmlinuz the bootdev to 0x80 and videomod 0 as default 
(and also for the installer on the user's computer, which 
adapt it to the user's computer)

There is a next problem that recent versions of fdisk 
starts only with sector 2048 for the 1st partition. This 
gives problems, because some systems needs to start with 
sector 63 or 129. This also should be return as it was.

wl


in /usr/src:
  0 lrwxrwxrwx   1 root root    23 Jun 14 00:55 linux-3 -> 
linux-3.0-rc3-i486-1sys
  0 lrwxrwxrwx   1 root root    23 Jun 14 00:55 linux-3.0 
-> linux-3.0-rc3-i486-1sys
  4 drwxr-xr-x   2 root root  4096 Jun 14 01:16 
linux-3.0-rc2-i486-1sys
  0 lrwxrwxrwx   1 root root    23 Jun 14 00:55 
linux-3.0-rc3 -> linux-3.0-rc3-i486-1sys
  4 drwxr-xr-x  24 root root  4096 Jun 14 00:55 
linux-3.0-rc3-i486-1sys
  0 lrwxrwxrwx   1 root root    23 Jun 14 00:55 
linux-3.0.0 -> linux-3.0-rc3-i486-1sys
  0 lrwxrwxrwx   1 root root    23 Jun 14 00:55 
linux-3.0.0-rc3 -> linux-3.0-rc3-i486-1sys
  0 lrwxrwxrwx   1 root root    23 Jun 14 00:55 
linux-3.0.0-rc3-i486-1sys -> linux-3.0-rc3-i486-1sys
in /lib/modules
0 lrwxrwxrwx 1 root root   19 Jun 14 00:55 3 -> 
3.0.0-rc3-i486-1sys
0 lrwxrwxrwx 1 root root   30 Jun 14 00:55 3.0 -> 
/lib/modules/3.0-rc3-i486-1sys
0 lrwxrwxrwx 1 root root   19 Jun 14 00:55 3.0-rc3 -> 
3.0.0-rc3-i486-1sys
0 lrwxrwxrwx 1 root root   19 Jun 14 00:55 
3.0-rc3-i486-1sys -> 3.0.0-rc3-i486-1sys
0 lrwxrwxrwx 1 root root   19 Jun 14 00:55 3.0.0 -> 
3.0.0-rc3-i486-1sys
0 lrwxrwxrwx 1 root root   19 Jun 14 00:55 3.0.0-rc3 -> 
3.0.0-rc3-i486-1sys
4 drwxr-xr-x 3 root root 4096 Jun 14 22:09 
3.0.0-rc3-i486-1sys


bash-4.1# depmod -av | less
WARNING: terminal is not fully functional
/lib/modules/3.0.0-rc3-i486-1sys/kernel/drivers/bluetooth/bluecard_cs.ko 
needs "hci_free_dev":
/lib/modules/3.0.0-rc3-i486-1sys/kernel/net/bluetooth/bluetooth.ko
/lib/modules/3.0.0-rc3-i486-1sys/kernel/drivers/bluetooth/bluecard_cs.ko 
needs "hci_alloc_dev":
  /lib/modules/3.0.0-rc3-i486-1sys/kernel/net/bluetooth/bluetooth.ko
/lib/modules/3.0.0-rc3-i486-1sys/kernel/drivers/bluetooth/bluecard_cs.ko 
needs "hci_unregister_
dev": 
/lib/modules/3.0.0-rc3-i486-1sys/kernel/net/bluetooth/bluetooth.ko
/lib/modules/3.0.0-rc3-i486-1sys/kernel/drivers/bluetooth/bluecard_cs.ko 
needs "hci_recv_frame"
: 
/lib/modules/3.0.0-rc3-i486-1sys/kernel/net/bluetooth/bluetooth.ko
/lib/modules/3.0.0-rc3-i486-1sys/kernel/drivers/bluetooth/bluecard_cs.ko 
needs "hci_register_de
v": 
/lib/modules/3.0.0-rc3-i486-1sys/kernel/net/bluetooth/bluetooth.ko
/lib/modules/3.0.0-rc3-i486-1sys/kernel/drivers/bluetooth/bfusb.ko 
needs "hci_free_dev": /lib/m
odules/3.0.0-rc3-i486-1sys/kernel/net/bluetooth/bluetooth.ko
/lib/modules/3.0.0-rc3-i486-1sys/kernel/drivers/bluetooth/bfusb.ko 
needs "hci_alloc_dev": /lib/
modules/3.0.0-rc3-i486-1sys/kernel/net/bluetooth/bluetooth.ko
/lib/modules/3.0.0-rc3-i486-1sys/kernel/drivers/bluetooth/bfusb.ko 
needs "hci_unregister_dev":
/lib/modules/3.0.0-rc3-i486-1sys/kernel/net/bluetooth/bluetooth.ko
/lib/modules/3.0.0-rc3-i486-1sys/kernel/drivers/bluetooth/bfusb.ko 
needs "hci_recv_frame": /lib
/modules/3.0.0-rc3-i486-1sys/kernel/net/bluetooth/bluetooth.ko
/lib/modules/3.0.0-rc3-i486-1sys/kernel/drivers/bluetooth/bfusb.ko 
needs "hci_register_dev": /l
ib/modules/3.0.0-rc3-i486-1sys/kernel/net/bluetooth/bluetooth.ko
/lib/modules/3.0.0-rc3-i486-1sys/kernel/drivers/bluetooth/btusb.ko 
needs "hci_free_dev": /lib/m
odules/3.0.0-rc3-i486-1sys/kernel/net/bluetooth/bluetooth.ko
/lib/modules/3.0.0-rc3-i486-1sys/kernel/drivers/bluetooth/btusb.ko 
needs "hci_alloc_dev": /lib/
modules/3.0.0-rc3-i486-1sys/kernel/net/bluetooth/bluetooth.ko
/lib/modules/3.0.0-rc3-i486-1sys/kernel/drivers/bluetooth/btusb.ko 
needs "hci_unregister_dev":
/lib/modules/3.0.0-rc3-i486-1sys/kernel/net/bluetooth/bluetooth.ko
/lib/modules/3.0.0-rc3-i486-1sys/kernel/drivers/bluetooth/btusb.ko 
needs "hci_recv_fragment": /
lib/modules/3.0.0-rc3-i486-1sys/kernel/net/bluetooth/bluetooth.ko
/lib/modules/3.0.0-rc3-i486-1sys/kernel/drivers/bluetooth/btusb.ko 
needs "hci_register_dev": /l
ib/modules/3.0.0-rc3-i486-1sys/kernel/net/bluetooth/bluetooth.ko
/lib/modules/3.0.0-rc3-i486-1sys/kernel/drivers/bluetooth/btmrvl.ko 
needs "hci_free_dev": /lib/
bash-4.1#

(only the first lines, via konsole)
---
Professional hosting for everyone - http://www.host.ru
