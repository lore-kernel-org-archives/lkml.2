Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab0JVRAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 13:00:17 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:57181 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757933Ab0JVRAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 13:00:14 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1++sa2NNrSpJDJ6HabXu38a
Date: Fri, 22 Oct 2010 10:00:09 -0700
From: Tony Lindgren <tony@atomide.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Simon Que <sque@ti.com>, "Krishnamoorthy, Balaji T" <balajitk@ti.com>
Subject: Re: [PATCH 1/3] drivers: misc: add omap_hwspinlock driver
Message-ID: <20101022170008.GG9149@atomide.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
 <1287387875-14168-2-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287387875-14168-2-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ohad Ben-Cohen <ohad@wizery.com> [101018 00:41]:
> From: Simon Que <sque@ti.com>
> 
> Add driver for OMAP's Hardware Spinlock module.
> 
> The OMAP Hardware Spinlock module, initially introduced in OMAP4,
> provides hardware assistance for synchronization between the
> multiple processors in the device (Cortex-A9, Cortex-M3 and
> C64x+ DSP).

...

> +EXPORT_SYMBOL_GPL(omap_hwspin_trylock);
> +EXPORT_SYMBOL_GPL(omap_hwspin_lock_timeout);
> +EXPORT_SYMBOL_GPL(omap_hwspin_unlock);
> +EXPORT_SYMBOL_GPL(omap_hwspinlock_request);
> +EXPORT_SYMBOL_GPL(omap_hwspinlock_request_specific);
> +EXPORT_SYMBOL_GPL(omap_hwspinlock_free);
> +EXPORT_SYMBOL_GPL(omap_hwspinlock_get_id);

Please let's not add yet another omap specific layer that will
make it incrementally harder to have generic drivers.

Instead, we can do the omap specific locking in the
platform code and then the drivers can use the functions
passed in the platform_data if they're implemented.

Regards,

Tony
