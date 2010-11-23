Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab0KWX41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:56:27 -0500
Received: from ns.mindbit.ro ([80.86.127.26]:51075 "EHLO ns.mindbit.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137Ab0KWX40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:56:26 -0500
X-Greylist: delayed 1937 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Nov 2010 18:56:19 EST
Subject: Re: [PATCH v2 2/4] drivers: hwspinlock: add OMAP implementation
From: Ionut Nicu <ionut.nicu@mindbit.ro>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>, Simon Que <sque@ti.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>
In-Reply-To: <1290526740-27624-3-git-send-email-ohad@wizery.com>
References: <1290526740-27624-1-git-send-email-ohad@wizery.com>
	 <1290526740-27624-3-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Organization: MindBit
Date: Wed, 24 Nov 2010 01:23:27 +0200
Message-ID: <1290554607.3647.12.camel@atlantis.mindbit.ro>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On Tue, 2010-11-23 at 17:38 +0200, Ohad Ben-Cohen wrote:
> From: Simon Que <sque@ti.com>
> 
> Add hwspinlock support for the OMAP4 Hardware Spinlock device.
> 

<snip>

> +
> +	io_base = ioremap(res->start, resource_size(res));
> +	if (!io_base) {
> +		ret = -ENOMEM;
> +		goto free_state;
> +	}
> +
> +	/* Determine number of locks */
> +	i = readl(io_base + SYSSTATUS_OFFSET);
> +	i >>= SPINLOCK_NUMLOCKS_BIT_OFFSET;
> +
> +	/* exactly one of the four least significant bits must be 1 */
> +	if (!i || !is_power_of_2(i) || i > 8) {
> +		ret = -EINVAL;
> +		goto iounmap_base;
> +	}
> +

At iounmap_base you unmap state->io_base, but that's set only after this
check. You should probably iounmap(io_base).

Regards,
Ionut.


