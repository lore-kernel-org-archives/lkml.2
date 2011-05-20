Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab1ETRpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 13:45:50 -0400
Received: from smtp17.mail.ru ([94.100.176.154]:38465 "EHLO smtp17.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757036Ab1ETRps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 13:45:48 -0400
Date: Fri, 20 May 2011 21:45:46 +0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Paul Parsons <lost.distance@yahoo.com>, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH] ds2760_battery: Fix rated capacity of the hx4700 1800mAh
 battery
Message-ID: <20110520174546.GA27734@rainbow>
References: <E1QEM6f-0000Db-K0@outmx05.plus.net>
 <20110520154724.GB18099@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520154724.GB18099@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:47 Fri 20 May     , Anton Vorontsov wrote:
> On Mon, Apr 25, 2011 at 01:45:40PM +0000, Paul Parsons wrote:

[snip]

> > --- clean-2.6.39-rc4/drivers/power/ds2760_battery.c	2011-03-15 01:20:32.000000000 +0000
> > +++ linux-2.6.39-rc4/drivers/power/ds2760_battery.c	2011-04-25 13:06:29.344976841 +0100
> > @@ -86,7 +86,11 @@ static int rated_capacities[] = {
> >  	920,	/* NEC */
> >  	1440,	/* Samsung */
> >  	1440,	/* BYD */
> > +#ifdef CONFIG_MACH_H4700
> > +	1800,	/* HP iPAQ hx4700 3.7V 1800mAh (359113-001) */
> > +#else
> >  	1440,	/* Lishen */
> > +#endif
> >  	1440,	/* NEC */
> 
> Note that this is OK as a temporary fix, but in general such fixups
> should be done via platform data. So, it would be great if you could
> prepare another patch on top of this one, which would do things in
> a proper way.

BTW, hx4700 also have extended batteries. I personally have one that rated
3600mAh with my hx4700. Sadly I dropped it on the floor some time ago and
battery lock got broken, so I currently can't use it. But I hope to fix it
some day.

It looks like this one, but made by PALMEXX (Part No.359113-001):
http://www.amazon.com/Li-Ion-359113-001-Battery-hx4700-hx4705/dp/B000VN7QMQ

-- 
Best regards,
Dmitry "MAD" Artamonow

