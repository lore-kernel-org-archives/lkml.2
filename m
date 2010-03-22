Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab0CVVhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:37:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:40876 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575Ab0CVVhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:37:15 -0400
Date: Mon, 22 Mar 2010 14:34:58 -0700
From: Greg KH <gregkh@suse.de>
To: pavan_savoy@ti.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] drivers:misc: sources for ST core
Message-ID: <20100322213458.GB420@suse.de>
References: <1269292756-7469-1-git-send-email-pavan_savoy@ti.com> <1269292756-7469-2-git-send-email-pavan_savoy@ti.com> <1269292756-7469-3-git-send-email-pavan_savoy@ti.com> <1269292756-7469-4-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269292756-7469-4-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 04:19:13PM -0500, pavan_savoy@ti.com wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> Texas Instruments BT, FM and GPS combo chips/drivers
> make use of a single TTY to communicate with the chip.
> This module constitutes the core logic, TTY ldisc driver
> and the exported symbols for registering/unregistering of
> the protocol drivers such as BT/FM/GPS.
> 
> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> ---
>  drivers/misc/ti-st/st_core.c | 1057 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/misc/ti-st/st_core.h |   92 ++++
>  2 files changed, 1149 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/ti-st/st_core.c
>  create mode 100644 drivers/misc/ti-st/st_core.h
> 
> diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
> new file mode 100644
> index 0000000..1cb7c0a
> --- /dev/null
> +++ b/drivers/misc/ti-st/st_core.c
> @@ -0,0 +1,1057 @@
> +/*
> + *  Shared Transport Line discipline driver Core
> + *	This hooks up ST KIM driver and ST LL driver
> + *  Copyright (C) 2009 Texas Instruments
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/tty.h>
> +
> +/* understand BT, FM and GPS for now */
> +#include <net/bluetooth/bluetooth.h>
> +#include <net/bluetooth/hci_core.h>
> +#include <net/bluetooth/hci.h>
> +#include "fm.h"
> +/*
> + * packet formats for fm and gps
> + * #include "gps.h"
> + */
> +#include "st_core.h"
> +#include "st_kim.h"
> +#include "st_ll.h"
> +#include "st.h"
> +
> +/* all debug macros go in here */
> +#define ST_DRV_ERR(fmt, arg...)  printk(KERN_ERR "(stc):"fmt"\n" , ## arg)
> +#if defined(DEBUG)		/* limited debug messages */
> +#define ST_DRV_DBG(fmt, arg...)  printk(KERN_INFO "(stc):"fmt"\n" , ## arg)
> +#define ST_DRV_VER(fmt, arg...)
> +#elif defined(VERBOSE)		/* very verbose */
> +#define ST_DRV_DBG(fmt, arg...)  printk(KERN_INFO "(stc):"fmt"\n" , ## arg)
> +#define ST_DRV_VER(fmt, arg...)  printk(KERN_INFO "(stc):"fmt"\n" , ## arg)
> +#else /* error msgs only */
> +#define ST_DRV_DBG(fmt, arg...)
> +#define ST_DRV_VER(fmt, arg...)
> +#endif

NO!

Please use the existing debug macros (dev_printk and friends) and do not
roll your own.

thanks,

greg k-h
