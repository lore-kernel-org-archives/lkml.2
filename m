Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab0GZRsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 13:48:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab0GZRsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 13:48:37 -0400
Date: Mon, 26 Jul 2010 10:43:14 -0700
From: Greg KH <gregkh@suse.de>
To: "David A. Ranch" <dranch@trinnet.net>
Cc: Greg KH <greg@kroah.com>, bryder@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] small FTDI USB serial driver update
Message-ID: <20100726174314.GC17741@suse.de>
References: <4C4B826E.8050009@trinnet.net>
 <20100725045859.GA7631@kroah.com>
 <4C4C4BD8.7040008@trinnet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4C4BD8.7040008@trinnet.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 25, 2010 at 07:36:08AM -0700, David A. Ranch wrote:
> 
> Hello Greg,
> 
> Thanks for getting back to me!  I didn't know what you meant by
> "Sign-off" but I just researched it per
> http://lwn.net/Articles/139918 (please let me know if that post
> doesn't apply anymore).  This will be my first kernel patch.  Let's
> try again:

Close, but it's a bit off.  Try looking at the version in the kernel
tree that you are patching against (should be 2.6.34 or newer).

> 
> Reason for patch:
> -----------------
> This patch is for a US Interface, Inc. "Navigator" USB device.
> Specifically, it's a HAM Radio USB sound modem that also
> incorporates three pairs of unique FTDI serial ports.  The standard
> Linux FTDI serial driver will only recognize the first two serial
> ports of an unknown FDTI derived device and this patch adds in
> recognition to these specific new IDs.
> 
> 
> Diffs are against a vanilla 2.6.34

The Signed-off-by: line should go here.

> 
> 
> --- ftdi_sio_ids.h.orig 2010-07-25 07:17:44.000000000 -0700
> +++ ftdi_sio_ids.h      2010-07-25 07:20:46.000000000 -0700

 need a full path to the driver, something like:
 	a/drivers/usb/serial/ftdi_sio_ids.h.orig


> @@ -40,6 +40,13 @@
> 
>  #define FTDI_NXTCAM_PID                0xABB8 /* NXTCam for
> Mindstorms NXT */
> 
> +/* US Interface Navigator (http://www.usinterface.com/). */
> +/* Submitted by David Ranch */
> +#define FTDI_USINT_CAT_PID     0xB810  /* Navigator CAT and 2nd PTT
> lines */

The patch is line-wrapped and can't be applied.

> +#define FTDI_USINT_WKEY_PID    0xB811  /* Navigator WKEY and FSK lines */
> +#define FTDI_USINT_RS232_PID   0xB812  /* Navigator RS232 and
> CONFIG lines */
> +
> +
>  /* OOCDlink by Joern Kaipf <joernk@web.de>
>   * (http://www.joernonline.de/dw/doku.php?id=start&idx=projects:oocdlink)
> */
>  #define FTDI_OOCDLINK_PID      0xbaf8  /* Amontec JTAGkey */
> 
> 
> 
> --- ftdi_sio.c.orig     2010-07-25 07:21:10.000000000 -0700
> +++ ftdi_sio.c  2010-07-25 07:24:21.000000000 -0700
> @@ -162,6 +162,9 @@ static struct usb_device_id id_table_com
>         { USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_5_PID) },
>         { USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_6_PID) },

Your email client stripped off the tabs and converted them to spaces,
making the patch impossible to apply.

Care to redo it all and try again?

thanks,

greg k-h
