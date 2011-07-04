Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab1GDLsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 07:48:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:15191 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab1GDLsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 07:48:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,471,1304319600"; 
   d="scan'208";a="26062143"
Date: Mon, 4 Jul 2011 13:48:44 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: [PATCH v6 08/18] mfd: twl6040: Add initial support
Message-ID: <20110704114844.GA3021@sortiz-mobl>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
 <1308663556-29120-9-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308663556-29120-9-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tue, Jun 21, 2011 at 04:39:06PM +0300, Peter Ujfalusi wrote:
> +int twl6040_is_powered(struct twl6040 *twl6040)
> +{
> +	return twl6040->power_count;
> +}
> +EXPORT_SYMBOL(twl6040_is_powered);
Do we really need to export this one ?

> +static inline int twl6040_get_rev(struct twl6040 *twl6040)
> +{
> +	return twl6040->rev;
> +}
> +
> +static inline int twl6040_request_irq(struct twl6040 *twl6040, int irq,
> +				      irq_handler_t handler,
> +				      unsigned long irqflags,
> +				      const char *name,
> +				      void *data)
> +{
> +	if (!twl6040->irq_base)
> +		return -EINVAL;
> +
> +	return request_threaded_irq(twl6040->irq_base + irq, NULL, handler,
> +				    irqflags, name, data);
> +}
> +
> +static inline void twl6040_free_irq(struct twl6040 *twl6040, int irq,
> +				    void *data)
> +{
> +	if (!twl6040->irq_base)
> +		return;
> +
> +	free_irq(twl6040->irq_base + irq, data);
> +}
I don't see the value of those 3 inline functions. Removing them would make
the code actually more understandable (especially for the 2nd one).

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
