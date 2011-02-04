Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1BDPbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 10:31:12 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:49856 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750863Ab1BDPbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 10:31:10 -0500
X-Authenticated: #113524
X-Provags-ID: V01U2FsdGVkX1/96DYUy9P9vFlIbVYpIdgyIp1eSwKednZq++43xT
	qXGFY9I3m3pgO6
Message-ID: <4D4C1BBB.409@gmx.com>
Date: Fri, 04 Feb 2011 16:31:07 +0100
From: Andreas Heinlein <aheinlein@gmx.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem (possible bug) with the loopback block device
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have observed the following behaviour and hope you can help me find
the source of it:
1. Create a (sparse) file of < 100MB on a removable drive, e.g. USB
drive (dd if=/dev/zero of=/media/Testdrive/testfile bs=1 count=1
seek=100000000)
2. Set up a loopback device with it (losetup -f /media/Testdrive/testfile)
3. Create a filesystem (mkfs.ext3 /dev/loopX) and mount it (mount
/dev/loopX /mnt)
5. Write some files there
6. Unplug the drive without unmounting anything
7. Attempt to write some more data to the loopback-mounted filesystem

Expected result: Write attempt gives an error
Actual result: Write succeeds, even 'sync' returns without error.
Written files can be read, as well as data written in step 5. Works as
long as data fits into the page cache (therefore the small file size).

Seen first on Ubuntu 10.04 with Linux 2.6.32, tested and verified also
with Fedora 14 (Linux 2.6.35), GRML 2010.04 (Linux 2.6.35). Ubuntu 11.04
alpha with Linux 2.6.37 immediately gave a kernel panic in step #7,
which is not much better. Same with Ubuntu 10.04 with Linux 2.6.37. Only
acceptable behaviour I saw was with OpenSuSE 11.3 (Linux 2.6.34) which
returned I/O error immediately and remounted the loopback'ed filesystem
read-only.

Thanks in advance,
Andreas
