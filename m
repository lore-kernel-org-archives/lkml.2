Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab1DGLZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 07:25:57 -0400
Received: from gra-lx1.iram.es ([150.214.224.41]:35236 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab1DGLZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 07:25:56 -0400
Date: Thu, 7 Apr 2011 13:25:48 +0200
From: Gabriel Paubert <paubert@iram.es>
To: Dave Airlie <airlied@gmail.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg KH <greg@kroah.com>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Revert 737a3bb9416ce2a7c7a4170852473a4fcc9c67e8 ?
Message-ID: <20110407112548.GA30805@iram.es>
References: <20110404235259.GA30132@iram.es> <20110406084101.GB13963@pengutronix.de> <BANLkTimAJ-s_3A3L1YGfoFLmd4bpu2jWVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimAJ-s_3A3L1YGfoFLmd4bpu2jWVA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Dave,

> This is the old DRM driver for radeon, which relies on userspace to
> start X then calls the kernel

Actually, even the old DRM driver occasionally hangs on this machine,
I suspect a missing barrier, but I might be completely off base.

The system is up, only X uses 100% of one core and according to
gdb X is there:

(gdb) info stack
#0  0x0fbafb08 in ioctl () from /lib/libc.so.6
#1  0x0f7be1c8 in drmDMA () from /usr/lib/libdrm.so.2
#2  0x0f65330c in ?? () from /usr/lib/xorg/modules/drivers/radeon_drv.so
#3  0x0f65380c in ?? () from /usr/lib/xorg/modules/drivers/radeon_drv.so
#4  0x0f6f89b8 in ?? () from /usr/lib/xorg/modules/drivers/radeon_drv.so
#5  0x0f562538 in ?? () from /usr/lib/xorg/modules/libexa.so
#6  0x0f56298c in ?? () from /usr/lib/xorg/modules/libexa.so
#7  0x0f56351c in ?? () from /usr/lib/xorg/modules/libexa.so
#8  0x0f55fba0 in ?? () from /usr/lib/xorg/modules/libexa.so
#9  0x0f56ab18 in ?? () from /usr/lib/xorg/modules/libexa.so
#10 0x0f56b810 in ?? () from /usr/lib/xorg/modules/libexa.so
#11 0x100f168c in ?? ()
#12 0x100df0fc in CompositePicture ()
#13 0x0f56a748 in ?? () from /usr/lib/xorg/modules/libexa.so
#14 0x100dee08 in CompositeTrapezoids ()
#15 0x100eb318 in ?? ()
#16 0x100e3ae8 in ?? ()
#17 0x1004a1f0 in ?? ()
#18 0x1001d0d4 in ?? ()
#19 0x0faea63c in ?? () from /lib/libc.so.6
#20 0x0faea800 in __libc_start_main () from /lib/libc.so.6
#21 0x00000000 in ?? ()


I don't know how to get more details.

	Regards,
	Gabriel
