Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761094Ab2C3QvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 12:51:00 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:51010 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228Ab2C3Qu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 12:50:56 -0400
Message-ID: <4F75E46E.2000503@msgid.tls.msk.ru>
Date: Fri, 30 Mar 2012 20:50:54 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111120 Icedove/8.0
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: dramatic I/O slowdown after upgrading 2.6.32->3.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I'm observing a dramatic slowdown of several hosts after upgrading
from 2.6.32.y to 3.0.x i686 kernels (in both cases from kernel.org,
on both cases the last version is relatively latest).

On 2.6.32 everything is fast.  On 3.0 the same operations which goes
instantly takes ages to complete.

For example, out of observed actual differences, munin-graph process
on 2.6.32 completes in a few secs writing to a ext4 /var filesystem.
On 3.0, the same process takes about a minute and keeps all 5 hard
drives (md raid5) 99% busy all this time.

apt-get upgrade (from debian/ubuntu) first reads current package
status database.  This process takes about 3 secs on a freshly
booted 2.6.32, and about 40 seconds on a freshly booted 3.0,
again, keeping all 5 hdds 99% busy (according to iostat).

Only the kernel is different, all the rest is exactly the same.
I can reboot into 2.6.32 again after running 3.0, and the system
is fast again.

The machine is relatively old, it is an IBM xSeries 345 server
with some 2.66GHz Xeon (stepping 9) CPU, a Broadcom chipset, an
LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320
SCSI controller and 5x74Gb pSCSI drives.  But it is obviously not
a reason for it to run _this_ slow... ;)

There's another machine here, with an AMD BE-2400 CPU, nVidia MCP55
chipset, AHA-3940U2x pSCSI controller and a set of 74Gb HDDs.  It
shows similar sympthoms after upgrading from 2.6.32 to 3.0 -- every
I/O becomes very slow with all HDDs being busy for long periods.

What's the way to debug this issue?

Thank you!

/mjt
