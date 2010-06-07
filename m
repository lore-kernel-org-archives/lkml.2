Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab0FGPpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 11:45:41 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:59456 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab0FGPpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 11:45:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19468.57971.470556.376718@pilspetsen.it.uu.se>
Date: Mon, 7 Jun 2010 14:13:39 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Stefan <dhj58ad@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel 2.6.35-rc1 on avila ixp4xx board booting problem
In-Reply-To: <4C0CC867.7010407@googlemail.com>
References: <4C0CC867.7010407@googlemail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan writes:
 > Hi all,
 > 
 > I just compiled the kernel from wireless-testing git tree for my 
 > gateworks avila ixp4xx  board. I used the OpenWrt toolchain for cross 
 > compiling for the arm - architecture and I used the .config of the 
 > original kernel of OpenWrt (2.6.32-10)
 > 
 > The kernel hangs up directly after being uncompressed.
 > 
 > console output:
 > 
 > +
 > Trying NPE-B...success. Using NPE-B with PHY 0.
 > Ethernet eth0: MAC address 00:d0:12:02:93:53
 > IP: 192.168.3.2/255.255.255.0, Gateway: 0.0.0.0
 > Default server: 192.168.3.1
 >  
 > RedBoot(tm) bootstrap and debug environment [ROM]
 > Gateworks certified release, version 2.02 - built 05:22:19, Mar  3 2006
 >  
 > Platform: Gateworks Avila GW234X (IXP42X 533MHz) BE
 > Copyright (C) 2000, 2001, 2002, 2003, 2004 Red Hat, Inc.
 > Copyright (C) 2004, 2005 Gateworks Corporation
 >  
 > RAM: 0x00000000-0x04000000, [0x000298b0-0x03fc1000] available
 > FLASH: 0x50000000 - 0x51000000, 128 blocks of 0x00020000 bytes each.
 > == Executing boot script in 5.000 seconds - enter ^C to abort
 > RedBoot> load -r -m disk -b 0x01600000 hda1:openwrt-avila-zImage
 > Raw file loaded 0x01600000-0x016f2f3b, assumed entry at 0x01600000
 > RedBoot> exec -c "console=ttyS0,115200 root=/dev/sda2 rootfstype=ext2 
 > init=/etc/preinit" 0x01600000
 > Using base address 0x01600000 and length 0x000f2f3c
 > Uncompressing Linux... done, booting the kernel.
 > 
 > I don't know, how to debug such behaviour. Any suggestions would be 
 > extremely helpful.
 > I attached my kernel config.
 > Thanks in advance

You should send this to the linux-arm-kernel@lists.infradead.org
mailing list.

FWIW, 2.6.35-rc1 boots fine on my ixp4xx NAS box.

You should also investigate if this is a regression from earlier
kernels or not. If you can't compile and boot earlier kernels
either then it may be a problem in your build tools or build procedure.
For starters, are you building with the correct endianess, and
are you sure you don't need a kernel shim to correct the bootloader's
machine type?
