Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab0JSRQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 13:16:56 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48733 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab0JSRQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 13:16:55 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <akpm@linux-foundation.org>,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Simon Que <sque@ti.com>, "Krishnamoorthy\, Balaji T" <balajitk@ti.com>
Subject: Re: [PATCH 1/3] drivers: misc: add omap_hwspinlock driver
Organization: Deep Root Systems, LLC
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
	<1287387875-14168-2-git-send-email-ohad@wizery.com>
Date: Tue, 19 Oct 2010 10:16:51 -0700
In-Reply-To: <1287387875-14168-2-git-send-email-ohad@wizery.com> (Ohad
	Ben-Cohen's message of "Mon, 18 Oct 2010 09:44:33 +0200")
Message-ID: <8739s2xfuk.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ohad Ben-Cohen <ohad@wizery.com> writes:

> From: Simon Que <sque@ti.com>
>
> Add driver for OMAP's Hardware Spinlock module.
>
> The OMAP Hardware Spinlock module, initially introduced in OMAP4,
> provides hardware assistance for synchronization between the
> multiple processors in the device (Cortex-A9, Cortex-M3 and
> C64x+ DSP).

[...]

> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index b743312..ce4b7a6 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -390,6 +390,16 @@ config BMP085
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called bmp085.
>  
> +config OMAP_HWSPINLOCK
> +	bool "OMAP Hardware Spinlock module"

Should be tristate so it can also be built as a module by default.

e.g., when building multi-OMAP kernels, no reason or this to be
built-in.  It can then be loaded as a module on OMAP4 only.

Kevin
