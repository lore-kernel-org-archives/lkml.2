Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab1GSN5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 09:57:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53328 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab1GSN5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 09:57:07 -0400
MIME-Version: 1.0
Date: Tue, 19 Jul 2011 15:57:06 +0200
Message-ID: <CACTFLANAFT=G4kFvHUqvLrt=MxgpJnJ-EeHY8zd49pZvsNRejw@mail.gmail.com>
Subject: Regression in handling of unsafe UBI shutdown
From: Daniel Mack <zonque@gmail.com>
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Sven Neumann <s.neumann@raumfeld.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

we're facing a new behaviour with 3.0-rc7 kernels wrt UBI file systems
that are not properly unmounted on shut down. The newest kernel we're
using in production is 2.6.36.4, and this version doesn't show the
effect.

When our devices boot up, the bootloader (U-Boot) initializes its UBI
code, reads in the uImage from the root partition and executes it.
This worked very well in thousands of installations previously (with
kernels up to version 2.6.36.4), and generally, it still does work
well with the latest cutting edge when the kernel is shut down
properly and unmounts the UBI partitions safely. However, if the power
is removed out of a sudden from a running system, U-Boot now doesn't
like the FS anymore upon the next boot:


Creating 1 MTD partitions on "nand0":
0x00120000-0x08000000 : "mtd=3"
UBI: attaching mtd1 to ubi0
UBI: physical eraseblock size:   131072 bytes (128 KiB)
UBI: logical eraseblock size:    126976 bytes
UBI: smallest flash I/O unit:    2048
UBI: VID header offset:          2048 (aligned 2048)
UBI: data offset:                4096
UBI: attached mtd1 to ubi0
UBI: MTD device name:            "mtd=3"
UBI: MTD device size:            126 MiB
UBI: number of good PEBs:        1014
UBI: number of bad PEBs:         1
UBI: max. allowed volumes:       128
UBI: wear-leveling threshold:    4096
UBI: number of internal volumes: 1
UBI: number of user volumes:     2
UBI: available PEBs:             8
UBI: total number of reserved PEBs: 1006
UBI: number of PEBs reserved for bad PEB handling: 10
UBI: max/mean erase counter: 4/3
UBIFS: recovery needed
Error reading superblock on volume 'ubi:RootFS'!
UBIFS not mounted, use ubifs mount to mount volume first!
Wrong Image Format for bootm command
ERROR: can't get kernel image!


Hence my question is: were there any radical changes in the UBI/UBIFS
code on the kernel side that make older code not like the new content
anymore?


Thanks,
Daniel
