Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab1GDNLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 09:11:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37479 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756941Ab1GDNLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 09:11:48 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "Girdwood, Liam" <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>
Subject: Re: Re: [PATCH v6 08/18] mfd: twl6040: Add initial support
Date: Mon, 4 Jul 2011 16:11:48 +0300
Message-ID: <7536276.uh7gaa9vHu@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <20110704114844.GA3021@sortiz-mobl>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com> <1308663556-29120-9-git-send-email-peter.ujfalusi@ti.com> <20110704114844.GA3021@sortiz-mobl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Monday 04 July 2011 13:48:44 Samuel Ortiz wrote:
> Hi Peter,
> 
> On Tue, Jun 21, 2011 at 04:39:06PM +0300, Peter Ujfalusi wrote:
> > +int twl6040_is_powered(struct twl6040 *twl6040)
> > +{
> > +	return twl6040->power_count;
> > +}
> > +EXPORT_SYMBOL(twl6040_is_powered);
> 
> Do we really need to export this one ?

No, we don't.
At the end we do not need this function at all either.
I'm going to remove it.
 
> > +static inline int twl6040_get_rev(struct twl6040 *twl6040)
> > +{
> > +	return twl6040->rev;
> > +}

No need for this either, I'll remove it.

> > +
> > +static inline int twl6040_request_irq(struct twl6040 *twl6040, int irq,
> > +				      irq_handler_t handler,
> > +				      unsigned long irqflags,
> > +				      const char *name,
> > +				      void *data)
> > +{
> > +	if (!twl6040->irq_base)
> > +		return -EINVAL;
> > +
> > +	return request_threaded_irq(twl6040->irq_base + irq, NULL, handler,
> > +				    irqflags, name, data);
> > +}
> > +
> > +static inline void twl6040_free_irq(struct twl6040 *twl6040, int irq,
> > +				    void *data)
> > +{
> > +	if (!twl6040->irq_base)
> > +		return;
> > +
> > +	free_irq(twl6040->irq_base + irq, data);
> > +}
> 
> I don't see the value of those 3 inline functions. Removing them would make
> the code actually more understandable (especially for the 2nd one).

The twl6040_request_irq is also used by the ASoC codec driver, and the vibra 
driver, but if you think it is better to replace those as well, I will do it 
right away.

-- 
Péter
