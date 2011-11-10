Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934511Ab1KJNa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:30:58 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44205 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180Ab1KJNa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:30:56 -0500
Date: Thu, 10 Nov 2011 17:30:52 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] s3c-adc-battery: Add naive POWER_SUPPLY_PROP_PRESENT
 implementation
Message-ID: <20111110133052.GA31381@oksana.dev.rtsoft.ru>
References: <201111100956.43979.heiko@sntech.de>
 <1320923106.2594.0.camel@anarsoul-laptop.Home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1320923106.2594.0.camel@anarsoul-laptop.Home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 02:05:06PM +0300, Vasily Khoruzhick wrote:
> On Thu, 2011-11-10 at 09:56 +0100, Heiko Stübner wrote:
> > Userspace programs like upower seem to depend on the presence of the
> > POWER_SUPPLY_PROP_PRESENT property.
> > 
> > The real presence of the battery cannot be sensed and all other
> > routines of s3c-adc-battery simply expect it to be present.
> > 
> > Therefore we simply return 1, unless the battery struct is not present at all.
> 
> Looks OK for me,
> 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> Acked-by: Vasily Khoruzhick <anarsoul@gmail.com>

I disagree. If the driver behaves like the hardware does not support
hot-pluggable cells, then present property is not necessary.

Upowerd should look at the 'present' only if it is there; and if it
is not, cells assumed to be always present.

[..]
> >  	if (!bat) {
> > +		if (psp == POWER_SUPPLY_PROP_PRESENT) {
> > +			val->intval = 0;
> > +			return 0;
> > +		}
> > +
> >  		dev_err(psy->dev, "%s: no battery infos ?!\n", __func__);

And in this case that dev_err() tells that either hardware does not
support hot-pluggable cells, or driver does not handle this case; which
is actually the same from the userspace point of view.

So, the problem is in upowerd, not this driver.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
