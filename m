Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab2FNHXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 03:23:35 -0400
Received: from linux-sh.org ([111.68.239.195]:43191 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab2FNHXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 03:23:34 -0400
Date: Thu, 14 Jun 2012 16:23:23 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2][resend] gpio: pcf857x: enable gpio_to_irq()
 support
Message-ID: <20120614072322.GC22007@linux-sh.org>
References: <877gw2uis5.wl%kuninori.morimoto.gx@renesas.com>
 <87d352qymy.wl%kuninori.morimoto.gx@renesas.com>
 <87aa06qykw.wl%kuninori.morimoto.gx@renesas.com>
 <20120614061519.GB22007@linux-sh.org>
 <878vfqqsnw.wl%kuninori.morimoto.gx@renesas.com>
 <877gvaqsfz.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gvaqsfz.wl%kuninori.morimoto.gx@renesas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 12:10:59AM -0700, Kuninori Morimoto wrote:
> +	for (i = 0; i < gpio->chip.ngpio; i++)
> +		if (change & BIT(i))
> +			generic_handle_irq(irq_find_mapping(gpio->irq_domain, i));
> +
You can probably get away with using for_each_set_bit() as well, which
would simplify this a bit.

Also, do you not have to worry about masking the parent IRQ while
iterating through the dispatch loop?
