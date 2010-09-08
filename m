Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab0IHCfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 22:35:22 -0400
Received: from kroah.org ([198.145.64.141]:36383 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756537Ab0IHCfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 22:35:20 -0400
Date: Tue, 7 Sep 2010 19:30:19 -0700
From: Greg KH <greg@kroah.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 27/30] staging: Bulk convert the semaphore mess
Message-ID: <20100908023019.GA25440@kroah.com>
References: <20100907124636.880953480@linutronix.de> <20100907125057.278833764@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100907125057.278833764@linutronix.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 02:33:47PM -0000, Thomas Gleixner wrote:
> init_MUTEX(_LOCKED) and DECLARE_MUTEX are going away. Bulk convert
> staging users.

I don't think you actually built this change:

> --- linux-2.6.orig/drivers/staging/comedi/drivers/usbdux.c
> +++ linux-2.6/drivers/staging/comedi/drivers/usbdux.c
> @@ -315,7 +315,7 @@ struct usbduxsub {
>   */
>  static struct usbduxsub usbduxsub[NUMUSBDUX];
>  
> -static DECLARE_MUTEX(start_stop_sem);
> +static DEFINE_SEMAPHORE(start_stop_sem);
>  
>  /*
>   * Stops the data acquision

I don't see DEFINE_SEMAPHORE() in Linus's tree, what should we use
instead?

thanks,

greg k-h
