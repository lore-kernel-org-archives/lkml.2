Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905Ab2FGU7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:59:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54961 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932511Ab2FGU7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:59:14 -0400
Date: Thu, 7 Jun 2012 16:59:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Randy Dunlap <rdunlap@xenotime.net>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Lockwood <lockwood@android.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: Re: linux-next: Tree for Jun 7 (staging/ccg #2)
In-Reply-To: <4FD10A30.50707@xenotime.net>
Message-ID: <Pine.LNX.4.44L0.1206071646360.1185-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2012, Randy Dunlap wrote:

> on x86_64:
> 
>   CC [M]  drivers/staging/ccg/ccg.o
> In file included from drivers/staging/ccg/../../usb/gadget/f_mass_storage.c:311:0,
>                  from drivers/staging/ccg/ccg.c:52:
> drivers/staging/ccg/../../usb/gadget/storage_common.c: In function 'fsg_lun_open':
> drivers/staging/ccg/../../usb/gadget/storage_common.c:686:3: error: implicit declaration of function 'bdev_logical_block_size'
> drivers/staging/ccg/../../usb/gadget/storage_common.c:687:3: error: implicit declaration of function 'blksize_bits'
> In file included from drivers/staging/ccg/ccg.c:52:0:
> drivers/staging/ccg/../../usb/gadget/f_mass_storage.c: In function 'fsg_main_thread':
> drivers/staging/ccg/../../usb/gadget/f_mass_storage.c:2624:2: error: implicit declaration of function 'set_fs'
> drivers/staging/ccg/../../usb/gadget/f_mass_storage.c:2624:2: error: implicit declaration of function 'get_ds'

The problems above are caused by the fact that 
drivers/staging/ccg/Kconfig does not make USB_G_CGG dependent on BLOCK.

> In file included from drivers/staging/ccg/ccg.c:59:0:
> drivers/staging/ccg/../../usb/gadget/f_fs.c: At top level:
> drivers/staging/ccg/../../usb/gadget/f_fs.c:40:0: warning: "pr_vdebug" redefined
> drivers/staging/ccg/../../usb/gadget/u_serial.c:138:0: note: this is the location of the previous definition

This could be fixed by adding a #ifndef guard to f_fs.c and u_serial.c.  
It's a little awkward to combine independent source files this way.

Alan Stern

