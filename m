Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab1IEUIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 16:08:52 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:55937 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab1IEUIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 16:08:43 -0400
X-Greylist: delayed 968 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Sep 2011 16:08:42 EDT
Subject: Re: [PATCH] leds: ledtrig-timer: fix broken sysfs delay handling
From: Richard Purdie <richard.purdie@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Johan Hovold <jhovold@gmail.com>, Johannes Berg <johannes.berg@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <201109051955.43420.f.fainelli@gmail.com>
References: <1315236783-513-1-git-send-email-jhovold@gmail.com>
	 <201109051955.43420.f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Sep 2011 20:54:50 +0100
Message-ID: <1315252490.1243.24.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-05 at 19:55 +0200, Florian Fainelli wrote:
> On Monday 05 September 2011 17:33:03 Johan Hovold wrote:
> > Fix regression introduced by commit
> > 5ada28bf76752e33dce3d807bf0dfbe6d1b943ad (led-class: always implement
> > blinking) which broke sysfs delay handling by not storing the updated
> > value. Consequently it was only possible to set one of the delays
> > through the sysfs interface as the other delay was automatically
> > restored to it's default value. Reading the parameters always gave the
> > defaults.
> > 
> > Cc: stable@kernel.org
> > Signed-off-by: Johan Hovold <jhovold@gmail.com>
> 
> Acked-by: Florian Fainelli <florian@openwrt.org>

Acked-by: Richard Purdie <rchard.purdie@linuxfoundation.org>

> > ---
> >  drivers/leds/ledtrig-timer.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
> > index d87c9d0..328c64c 100644
> > --- a/drivers/leds/ledtrig-timer.c
> > +++ b/drivers/leds/ledtrig-timer.c
> > @@ -41,6 +41,7 @@ static ssize_t led_delay_on_store(struct device *dev,
> > 
> >  	if (count == size) {
> >  		led_blink_set(led_cdev, &state, &led_cdev->blink_delay_off);
> > +		led_cdev->blink_delay_on = state;
> >  		ret = count;
> >  	}
> > 
> > @@ -69,6 +70,7 @@ static ssize_t led_delay_off_store(struct device *dev,
> > 
> >  	if (count == size) {
> >  		led_blink_set(led_cdev, &led_cdev->blink_delay_on, &state);
> > +		led_cdev->blink_delay_off = state;
> >  		ret = count;
> >  	}
> 


