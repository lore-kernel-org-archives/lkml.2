Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab2KHAF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 19:05:58 -0500
Received: from [201.191.100.135] ([201.191.100.135]:50437 "EHLO
	bruno.wildbear.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab2KHAF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 19:05:56 -0500
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Nov 2012 19:05:56 EST
Date: Wed, 7 Nov 2012 17:56:19 -0600 (CST)
From: Joseph Parmelee <jparmele@wildbear.com>
X-X-Sender: jparmele@bruno
To: linux-kernel@vger.kernel.org
Subject: Binutils test suite freezes kernel
Message-ID: <alpine.LNX.2.00.1211071634440.1754@bruno>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings:

The gas test suite in recent binutils snapshots from
ftp://sourceware.org/pub/binutils/snapshots/ consistently freezes my i386
custom-built kernels.  This may be a kernel configuration problem but if so
it has manifested only recently.  I have been building kernels since 1995
and this is the first instance I have seen where the kernel is brought down
by a non-privileged user space process.  AIUI this should be impossible
regardless of what that process is doing.  The problem affects all kernels
between 3.6.2 and 3.6.6.  These are merely the kernels were I have seen the
problem; it may well affect other kernels.

My system uses a raid1 array of two SATA disks, each having a root partition
and a much smaller swap partition.  Because the raid arrays have been in use
since 2001 on various disks over the years they use the older kernel
automatic raid detection metadata.

When the freeze occurs not all system processes always stop but most do such
that I can change virtual terminals but cannot enter characters into any of
them except sysreq magic keys.  Often this also affects telnet from other
hosts, but not always.  If a can kill the test process, either through
telnet or sysreq magic keys, the system returns, though it appears that the
system clock has also been stopped during the freeze.

If however I press the reset button during the freeze, this results in a
reconstruction of the raided swap partition on system restart.  What is most
striking is that this reconstruction is not always successful because of
hard disk errors in one of the swap partitions.  They are unrecoverable CRC
read errors which cause the affected partition to be kicked out of the raid
array.  However, they disappear when the badblock program is run with the -w
(write then read) option on the affected partition.  The partition can then
be added back into the array without further incident.  This suggests to me
that sometimes the system freeze occurs in the middle of swap sector writes
such that they are actually bad on the disk.  Just how that is happening is
a mystery to me.

I do not pretend to understand what is happening here but I will do what I
can to provide whatever additional information may be necessary.

Please CC me directly as I am no longer subscribed to the list.

Yours,

Joseph
jparmele at wildbear dot com

