Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab0FNVlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:41:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:50032 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843Ab0FNVlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:41:40 -0400
Date: Mon, 14 Jun 2010 14:41:22 -0700
From: Greg KH <gregkh@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu,
       khali@linux-fr.org
Subject: Re: [PATCH 12/12] usb: use IRQ watching
Message-ID: <20100614214122.GA21064@suse.de>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
 <1276443098-20653-13-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276443098-20653-13-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 13, 2010 at 05:31:38PM +0200, Tejun Heo wrote:
> Ask IRQ subsystem to watch HCD IRQ line after initialization.  This at
> least keeps USB ports which are occupied on initialization working and
> eases bug reporting and debugging.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  drivers/usb/core/hcd.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index 12742f1..383875f 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -2270,6 +2270,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
>  					"request interrupt %d failed\n", irqnum);
>  			goto err_request_irq;
>  		}
> +		watch_irq(irqnum, hcd);

So if there's a routing problem, it turns into a polled interrupt?  Do
we really want that?  I wonder how long people will run without
realizing that there are problems with their system if their devices
still work.

Other than that minor comment, it all looks good to me.

thanks,

greg k-h
