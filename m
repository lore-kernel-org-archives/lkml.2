Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888Ab2FBJzY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 05:55:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52115 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933871Ab2FBJzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 05:55:22 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 2 Jun 2012 11:55:11 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux-kernel@vger.kernel.org
Cc: linux1394-user@lists.sourceforge.net,
        linux1394-devel@lists.sourceforge.net
Subject: Silent data corruption with kernel 3.4 and FireWire disks
Message-ID: <20120602115511.5ad979db@stein>
In-Reply-To: <20120524224447.57a636f7@stein>
References: <20120524224447.57a636f7@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

About a week ago I noticed silent data corruptions of files on FireWire
disks:  Mount disk, read lots of data and e.g. compute their md5sum,
unmount disk, mount disk again, read and md5sum the same files again ->
MD5s may differ.

Defects in files that were written in May hint that not only reading from
but also writing to FireWire disks resulted in corrupt data.  This was
silent corruption without any error messages from the PCI, firewire, SCSI,
block, or filesystem subsystems.

Affected:
  - kernel 3.4
  - kernel 3.4-rc5
Not affected:
  - kernel 3.3.1 (which I have been running now for the last 6 days)

I used these three kernels with the same patchlevel of FireWire drivers,
namely circa those which are about to be released in 3.5-rc1.  FireWire
disks with different 1394-to-SATA or -IDE bridge chips are affected.  I
noticed the problem at first on an Agere FW643e PCIe 1394 controller which
sits behind a PLX PEX 8505 PCIe switch.

MPEG2TS video reception through the same 1394 controller and PCIe switch
did never show a noticable sign of corruption.

I did not have time yet to systematically test
  - whether all of my FireWire controllers are affected,
  - whether SATA or USB disks are affected (SATA probably not, USB not
    used yet),
  - whether my secondary Linux PC is affected.

Kernel 3.4 and 3.4-rc5 exhibited another (seemingly harmless but
suspicious) issue on my primary PC:  frequent transmit queue time-outs of
an RTL8111/8168B Ethernet interface,
http://www.spinics.net/lists/netdev/msg197032.html

Being busy at work lately and not having Linux available at work, I will
be slow to look further into it.  With enough spare time, it should be
possible to identify the regression by bisection between kernel 3.3 and
3.4-rc but I have no estimate when I will be able to spend that time.
-- 
Stefan Richter
-=====-===-- -==- ---=-
http://arcgraph.de/sr/
