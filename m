Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab0CWPUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:20:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47778 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754486Ab0CWPUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:20:43 -0400
Date: Tue, 23 Mar 2010 15:24:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: pavan_savoy@ti.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] drivers:misc: sources for ST core
Message-ID: <20100323152433.43ce1d0e@lxorguk.ukuu.org.uk>
In-Reply-To: <1269292756-7469-4-git-send-email-pavan_savoy@ti.com>
References: <1269292756-7469-1-git-send-email-pavan_savoy@ti.com>
	<1269292756-7469-2-git-send-email-pavan_savoy@ti.com>
	<1269292756-7469-3-git-send-email-pavan_savoy@ti.com>
	<1269292756-7469-4-git-send-email-pavan_savoy@ti.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Use the existing debug macros


> +/* function pointer pointing to either,
> + * st_kim_recv during registration to receive fw download responses
> + * st_int_recv after registration to receive proto stack responses
> + */
> +void (*st_recv) (const unsigned char *data, long count);

What if you have multiple devices at once one in each state ?
Why is this global ?

> +	if (unlikely(st_gdata == NULL || st_gdata->tty == NULL)) {

Again shouldn't be using globals and needs to support multiple devices.
See the tty_struct - there is a field for an ldisc pointer, stuff
st_gdata in there at open time and pass tty around ?


> +		ST_DRV_ERR("tty unavailable to perform write");
> +		return ST_ERR_FAILURE;
> +	}
> +	tty = st_gdata->tty;

Explain the locking on this NULL test - what stops it becoming NULL
between the if and the assignment ?


I think this code needs a fair bit of work at this point - locking,
supporting multiple devices at once etc.

Staging perhaps ?

