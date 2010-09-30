Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab0I3R3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 13:29:17 -0400
Received: from kroah.org ([198.145.64.141]:50615 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab0I3R3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 13:29:16 -0400
Date: Thu, 30 Sep 2010 04:51:23 -0700
From: Greg KH <greg@kroah.com>
To: pavan_savoy@ti.com
Cc: gregkh@suse.de, alan@lxorguk.ukuu.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:staging:ti-st: mv ti_wilink_st header
Message-ID: <20100930115123.GB2779@kroah.com>
References: <1285777522-13709-1-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285777522-13709-1-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 12:25:22PM -0400, pavan_savoy@ti.com wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> Greg,
> 
> How is the movement of drivers done out of staging?
> Should I submit patches like these, which move individual files without
> breaking the build during anytime of movement?

Yes.

> In few following days I plan to submit patches to move the ST headers sources
> out.
> ti_wilink_st.h -> include/linux/
> st_core.c, st_kim.c and st_ll.c -> drivers/misc/
> Makefile and Kconfig changes to drivers/misc/Kconfig and drivers/misc/Makefile
> bt_drv.c -> drivers/bluetooth/

Yes, that sounds great.

But, the bluetooth patch should go to the bluetooth maintainer for his
review, I'll need the ack from him before I can apply it.

Oh, this patch looks nice, but I found one problem:

> --- a/drivers/staging/ti-st/ti_wilink_st.h
> +++ /dev/null
> -#ifndef TI_WILINK_ST_H
> -#define TI_WILINK_ST_H
> -
> -/* TODO:
> - * Move the following to tty.h upon acceptance
> - */
> -#define N_TI_WL	22	/* Ldisc for TI's WL BT, FM, GPS combo chips */

We need to do that now, before you move this file.

Then, you can drop this:

> -#ifdef __KERNEL__

As it will not be needed, right?

Care to send me a patch that does this first?

thanks,

greg k-h
