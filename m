Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab2GXV3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 17:29:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab2GXV3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 17:29:38 -0400
Date: Tue, 24 Jul 2012 14:29:34 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH] ene_ub6250: Use macros for firmware names
Message-ID: <20120724212934.GA2180@kroah.com>
References: <1343161869-129765-1-git-send-email-tim.gardner@canonical.com>
 <20120724203448.GA1617@kroah.com>
 <500F0CD6.7080907@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500F0CD6.7080907@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 03:00:06PM -0600, Tim Gardner wrote:
> On 07/24/2012 02:34 PM, Greg Kroah-Hartman wrote:
> >On Tue, Jul 24, 2012 at 02:31:09PM -0600, Tim Gardner wrote:
> >>Advertise firmware files using MODULE_FIRMWARE macros.
> >>
> >>Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>Cc: linux-usb@vger.kernel.org
> >>Cc: usb-storage@lists.one-eyed-alien.net
> >>Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> >>---
> >>  drivers/usb/storage/ene_ub6250.c |   26 +++++++++++++++++++-------
> >>  1 file changed, 19 insertions(+), 7 deletions(-)
> >>
> >>diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
> >>index b28f2ad..3fec82f 100644
> >>--- a/drivers/usb/storage/ene_ub6250.c
> >>+++ b/drivers/usb/storage/ene_ub6250.c
> >>@@ -29,9 +29,21 @@
> >>  #include "protocol.h"
> >>  #include "debug.h"
> >>
> >>+#define SD_INIT1_FIRMWARE "ene-ub6250/sd_init1.bin"
> >>+#define SD_INIT2_FIRMWARE "ene-ub6250/sd_init2.bin"
> >>+#define SD_RW_FIRMWARE "ene-ub6250/sd_rdwr.bin"
> >>+#define MS_INIT_FIRMWARE "ene-ub6250/ms_init.bin"
> >>+#define MSP_RW_FIRMWARE "ene-ub6250/msp_rdwr.bin"
> >>+#define MS_RW_FIRMWARE "ene-ub6250/ms_rdwr.bin"
> >>+
> >>  MODULE_DESCRIPTION("Driver for ENE UB6250 reader");
> >>  MODULE_LICENSE("GPL");
> >>-
> >>+MODULE_FIRMWARE(SD_INIT1_FIRMWARE);
> >>+MODULE_FIRMWARE(SD_INIT2_FIRMWARE);
> >>+MODULE_FIRMWARE(SD_RW_FIRMWARE);
> >>+MODULE_FIRMWARE(MS_INIT_FIRMWARE);
> >>+MODULE_FIRMWARE(MSP_RW_FIRMWARE);
> >>+MODULE_FIRMWARE(MS_RW_FIRMWARE);
> >
> >Why do you need the #defines here at all?  What's wrong with just using
> >the file names in the MODULE_FIRMWARE() macro directly?  That cuts the
> >size of the patch in half :)
> >
> >thanks,
> >
> >greg k-h
> >
> 
> If the firmware file name ever changes, then you'll have to find and
> modify it in 2 places.

Oops, sorry, I missed the second place it was used in the file,
nevermind, time for more coffee...

greg k-h
