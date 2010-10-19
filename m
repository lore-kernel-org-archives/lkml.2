Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab0JSPzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:55:47 -0400
Received: from kroah.org ([198.145.64.141]:59737 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab0JSPzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:55:45 -0400
Date: Tue, 19 Oct 2010 08:46:27 -0700
From: Greg KH <greg@kroah.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Simon Que <sque@ti.com>, "Krishnamoorthy, Balaji T" <balajitk@ti.com>
Subject: Re: [PATCH 1/3] drivers: misc: add omap_hwspinlock driver
Message-ID: <20101019154627.GC4589@kroah.com>
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

On Mon, Oct 18, 2010 at 09:44:33AM +0200, Ohad Ben-Cohen wrote:
> +#else /* !CONFIG_OMAP_HWSPINLOCK */
> +
> +static inline struct omap_hwspinlock *omap_hwspinlock_request(void)
> +{
> +	return ERR_PTR(-ENOSYS);
> +}

One note, do you really want to fail if this option isn't built into the
kernel, yet you have a driver that is asking for it?  Shouldn't you
instead just silently succeed, and let the code path get compiled away?

We did that for debugfs, after learning the pain that procfs had with
its api for "is not built".  Doing it the way you are requires the user
to always test for -ENOSYS, when in reality, if that is returned,
there's nothing the driver can do about it, so it should just not worry
about it.

Just something to think about.

thanks,

greg k-h
