Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab0KJX2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:28:50 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45788 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411Ab0KJX2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:28:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X0Qv2C5UcszCJdjmO75ZIbvlYEiKNJzMoO0ZuH5Bzs4RUw4xdfAO6KNGa82+j1W0x1
         BoA857TXWBDaGZ9pwZFXQBscJJIbZurbg7h8IXCVRBIrnQrAnvPtfbCoFm2Cdxor1MpH
         2E/U7eHQq6DRDvayBZHA8xQ/ZuAvn3rbufeFk=
Date: Wed, 10 Nov 2010 15:28:41 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Trilok Soni <tsoni@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-arm-msm@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [RFC v1 PATCH 3/6] led: pmic8058: Add PMIC8058 leds driver
Message-ID: <20101110232840.GA2121@core.coreip.homeip.net>
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org>
 <1289393281-4459-4-git-send-email-tsoni@codeaurora.org>
 <4CDB0451.3090303@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDB0451.3090303@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 09:45:05PM +0100, Lars-Peter Clausen wrote:
> Trilok Soni wrote:
> > +
> > +static void led_kp_set(struct pmic8058_led_data *led, enum led_brightness value)
> > +{
> > +	int rc;
> > +	u8 level;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&led->value_lock, flags);
> This function is only ever called from within the workqueue so there is no need for
> locking.
> 

That is a common misconception, unfortunately. The same work may
be executing on several CPUs at the same time if it was scheduled on
multi-threaded work queue.

...

> > +	schedule_work(&led->work);

And sure enough, keventd is such workqueue.

Now, whether having the same work run simultaneously is OK or not is a
different question altogether...

-- 
Dmitry
