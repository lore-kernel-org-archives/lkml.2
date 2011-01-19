Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab1ASKex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 05:34:53 -0500
Received: from smtp.nokia.com ([147.243.1.48]:47997 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab1ASKew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 05:34:52 -0500
Date: Wed, 19 Jan 2011 12:33:23 +0200
From: Heikki Krogerus <heikki.krogerus@nokia.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Felipe Balbi <balbi@ti.com>, Tejun Heo <tj@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Hema HK <hemahk@ti.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Ruirui <ruirui.r.yang@tieto.com>,
        David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] usb otg: use atomic notifier instead of blocking
 notifier
Message-ID: <20110119103323.GC4693@hedu-HP-Z800-Workstation>
References: <20110119092011.GA23624@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119092011.GA23624@darkstar>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 05:20:11PM +0800, ext Yang Ruirui wrote:
> --- linux-2.6.orig/include/linux/usb/otg.h      2011-01-17 09:39:11.000000000 +0800
> +++ linux-2.6/include/linux/usb/otg.h   2011-01-19 16:38:06.649546989 +0800
> @@ -74,7 +74,7 @@ struct otg_transceiver {
>         void __iomem                    *io_priv;
> 
>         /* for notification of usb_xceiv_events */
> -       struct blocking_notifier_head   notifier;
> +       struct atomic_notifier_head     notifier;
> 
>         /* to pass extra port status to the root hub */
>         u16                     port_status;
> @@ -234,13 +234,13 @@ otg_start_srp(struct otg_transceiver *ot
>  static inline int
>  otg_register_notifier(struct otg_transceiver *otg, struct notifier_block *nb)
>  {
> -       return blocking_notifier_chain_register(&otg->notifier, nb);
> +       return atomic_notifier_chain_register(&otg->notifier, nb);
>  }
> 
>  static inline void
>  otg_unregister_notifier(struct otg_transceiver *otg, struct notifier_block *nb)
>  {
> -       blocking_notifier_chain_unregister(&otg->notifier, nb);
> +       atomic_notifier_chain_unregister(&otg->notifier, nb);
>  }
> 
>  /* for OTG controller drivers (and maybe other stuff) */

Is drivers/power/twl4030_charger.c ready for atomic notifiers?

-- 
heikki
