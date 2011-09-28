Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab1I1MHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 08:07:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62698 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab1I1MHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 08:07:17 -0400
Date: Wed, 28 Sep 2011 14:06:31 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Russell King <linux@arm.linux.org.uk>
Subject: MAC firmware does not load due to (commit 288d5abe usermodehelper)
Message-ID: <20110928120630.GB9456@netboy.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have some ARM IXP4xx based machines that use the two on chip MAC
ports (aka NPEs). The NPE needs a firmware in order to function. Ever
since the following commit, it is no longer possible to bring up the
interfaces during the init scripts.

    commit 288d5abec8314ae50fe6692f324b0444acae8486
    Author: Linus Torvalds <torvalds@linux-foundation.org>
    Date:   Wed Aug 3 22:03:29 2011 -1000

    Boot up with usermodehelper disabled

A warning appears on the console, shown below.  I don't know what
commit 288d5abe was trying to fix, but it sure made a regression for
me. It probably would also spoil using NFS boot, too.

Any ideas what to do about this?

Thanks,
Richard


------------[ cut here ]------------
WARNING: at /home/richard/git/linux/drivers/base/firmware_class.c:537 _request_firmware+0xc8/0x3b8()
Modules linked in:
Backtrace: 
[<c000bee0>] (dump_backtrace+0x0/0x114) from [<c000c3dc>] (dump_stack+0x18/0x1c)
[<c000c3c4>] (dump_stack+0x0/0x1c) from [<c001a778>] (warn_slowpath_common+0x58/0x70)
[<c001a720>] (warn_slowpath_common+0x0/0x70) from [<c001a7b4>] (warn_slowpath_null+0x24/0x2c)
[<c001a790>] (warn_slowpath_null+0x0/0x2c) from [<c0142710>] (_request_firmware+0xc8/0x3b8)
[<c0142648>] (_request_firmware+0x0/0x3b8) from [<c0142a20>] (request_firmware+0x20/0x28)
[<c0142a00>] (request_firmware+0x0/0x28) from [<c0012c98>] (npe_load_firmware+0x1c/0x488)
[<c0012c7c>] (npe_load_firmware+0x0/0x488) from [<c015dbe8>] (eth_open+0x44/0x6c0)
[<c015dba4>] (eth_open+0x0/0x6c0) from [<c017bf88>] (__dev_open+0xbc/0x114)
[<c017becc>] (__dev_open+0x0/0x114) from [<c017a044>] (__dev_change_flags+0x98/0x124)
[<c0179fac>] (__dev_change_flags+0x0/0x124) from [<c017b8e4>] (dev_change_flags+0x1c/0x50)
[<c017b8c8>] (dev_change_flags+0x0/0x50) from [<c01c2cd0>] (devinet_ioctl+0x2c4/0x674)
[<c01c2a0c>] (devinet_ioctl+0x0/0x674) from [<c01c395c>] (inet_ioctl+0xcc/0x104)
[<c01c3890>] (inet_ioctl+0x0/0x104) from [<c016cb3c>] (sock_ioctl+0x1f8/0x254)
[<c016c944>] (sock_ioctl+0x0/0x254) from [<c0082c28>] (vfs_ioctl+0x28/0x44)
[<c0082c00>] (vfs_ioctl+0x0/0x44) from [<c00832c8>] (do_vfs_ioctl+0x49c/0x4ec)
[<c0082e2c>] (do_vfs_ioctl+0x0/0x4ec) from [<c0083358>] (sys_ioctl+0x40/0x64)
[<c0083318>] (sys_ioctl+0x0/0x64) from [<c0009040>] (ret_fast_syscall+0x0/0x2c)
---[ end trace 6083e7c78b321b84 ]---
