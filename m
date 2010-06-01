Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab0FAWve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 18:51:34 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:59360 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918Ab0FAWvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 18:51:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19461.36591.729312.846067@pilspetsen.it.uu.se>
Date: Wed, 2 Jun 2010 00:51:27 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: David Miller <davem@davemloft.net>
Cc: mikpe@it.uu.se, linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [2.6.35-rc1 regression] sysfs: cannot create duplicate
 filename ... XVR-600 related?
In-Reply-To: <20100601.153105.90813554.davem@davemloft.net>
References: <19461.26166.427857.612983@pilspetsen.it.uu.se>
	<20100601.153105.90813554.davem@davemloft.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:
 > From: Mikael Pettersson <mikpe@it.uu.se>
 > Date: Tue, 1 Jun 2010 21:57:42 +0200
 > 
 > > Booting 2.6.35-rc1 on a Sun Blade 2500 Red, I'm greeted with:
 > 
 > I know about the problem and will look at it soon hopefully, I see it
 > on some of my sparc64 boxes too.
 > 
 > You'll also have better luck reporting this to the proper mailing
 > list, which is sparclinux@vger.kernel.org, added to the CC:

I wasn't sure if this was a generic bug or a SPARC-specific one.
If I had suspected it was SPARC-specific I'd certainly have chosen
the sparclinux ML as the primary recipient.  FWIW, one reply I
received indicated it was a known generic bug.

 > > ------------[ cut here ]------------
 > > WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0x74/0x90()
 > > sysfs: cannot create duplicate filename '/devices/root/f0079a58/pci0003:00/0003:00:02.0/slot'
 > > Modules linked in:
 > > Call Trace:
 > >  [0000000000458e20] warn_slowpath_fmt+0x2c/0x3c
 > >  [0000000000501dac] sysfs_add_one+0x74/0x90
 > >  [0000000000502cd4] sysfs_do_create_link+0xf0/0x184
 > >  [000000000055a62c] pci_create_sysfs_dev_files+0x304/0x428
 > >  [000000000074c6f8] pci_sysfs_init+0x20/0x6c
 > >  [0000000000426acc] do_one_initcall+0x44/0x164
 > >  [000000000073a32c] kernel_init+0x1a0/0x238
 > >  [000000000042aea4] kernel_thread+0x30/0x48
 > >  [0000000000640efc] rest_init+0x18/0x88
 > > ---[ end trace 8093a3146373dac8 ]---
 > > 
 > > (There are no interesting messages before or after this one.)
 > > 
 > > The device at 003:00:02.0 is a Sun XVR-600 graphics card, driven by
 > > drivers/video/sunxvr500.c.  There was no such warning in 2.6.34 or
 > > earlier kernels.
