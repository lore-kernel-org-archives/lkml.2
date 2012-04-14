Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab2DNUhs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 16:37:48 -0400
Received: from grendel.xisp.net ([96.255.255.193]:52133 "EHLO ba-blue.xisp.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754951Ab2DNUhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 16:37:47 -0400
Date: Sat, 14 Apr 2012 21:21:58 +0100
From: Dale Amon <amon@vnl.com>
To: linux-kernel@vger.kernel.org
Cc: amon@vnl.com
Subject: Repeated fd0 messages during boot
Message-ID: <20120414202158.GB3257@vnl.com>
Mail-Followup-To: Dale Amon <amon@vnl.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Delayed for 00:15:24 by milter-greylist-3.0 (ba-blue.xisp.net [96.255.255.200]); Sat, 14 Apr 2012 16:37:26 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This happened after a recent upgrade using an Ubuntu
Precise kernel, 3.2.0-22-generic-pae to be, er, precise.
The machine is an old one. It has a floppy controller but
has no floppy installed. The dmesg shows some floppy related
messages that are not terribly worrisome earlier on:

[    2.071881] agpgart-sis 0000:00:00.0: SiS chipset [1039/0746]
[    2.102241] agpgart-sis 0000:00:00.0: AGP aperture is 128M @ 0xe0000000
[    2.116375] Floppy drive(s): fd0 is 1.44M
[    2.136428] FDC 0 is a post-1991 82077
[    2.227141] sis900.c: v1.08.10 Apr. 2 2006


[    3.111250]  sdc: sdc1
[    3.111838] sd 3:0:0:0: [sdc] Attached SCSI disk
[    4.523572] Btrfs loaded
[   17.188579] end_request: I/O error, dev fd0, sector 0
[   17.313154] REISERFS (device sda1): found reiserfs format "3.6" with standard journal

But around about here, it gets into trouble:

[   58.907693] ata4.00: configured for UDMA/133
[   58.907754] ata4: EH complete
[   60.434537] init: udev-fallback-graphics main process (1063) terminated with status 1
[   67.164604] end_request: I/O error, dev fd0, sector 0
[   68.704019] br0: no IPv6 routers present
[   73.568022] br0: port 1(eth1) entering forwarding state
[   79.320863] end_request: I/O error, dev fd0, sector 0
[   79.320883] Buffer I/O error on device fd0, logical block 0
[   91.488597] end_request: I/O error, dev fd0, sector 0
[   91.488619] Buffer I/O error on device fd0, logical block 0
[  103.644762] end_request: I/O error, dev fd0, sector 0
[  103.644784] Buffer I/O error on device fd0, logical block 0
[  115.808406] end_request: I/O error, dev fd0, sector 0
[  115.808425] Buffer I/O error on device fd0, logical block 0
[  127.976466] end_request: I/O error, dev fd0, sector 0

This continues for a considerable time, ie many minutes. Then the 
machine continues booting normally:

[ 1174.164517] Buffer I/O error on device fd0, logical block 0
[ 1174.314178] reiserfs: enabling write barrier flush mode
[ 1174.369389] REISERFS (device sda1): Removing [63554 81060 0x0 SD]..done
[ 1174.369575] REISERFS (device sda1): Removing [63554 51447 0x0 SD]..done

Any idea what is causing this? Kernel bug? Ubuntu patch bug?
