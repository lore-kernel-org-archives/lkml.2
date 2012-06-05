Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab2FEURp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 16:17:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57634 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab2FEURo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 16:17:44 -0400
Date: Wed, 6 Jun 2012 05:17:38 +0900
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] clean up headers for light drivers : backlights, leds and
 iio-light
Message-ID: <20120605201738.GC27297@kroah.com>
References: <A874F61F95741C4A9BA573A70FE3998FAD86@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FAD86@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 03:43:08PM +0000, Kim, Milo wrote:
> I'd like to suggest some clean up idea for headers under include/linux.
> Light device drivers are exist under 'drivers/leds' and 'drivers/video/backlight'.
> (and iio light drivers are ongoing in staging directory)
> At this moment, there is no specific directory for light driver, some headers are located in include/linux.
> Furthermore, new light drivers may be added into include/linux again and again.

Why do any of these need .h files in include/linux/ in the first place?

> So my suggestion is 
> 
> - create new directory for light driver : include/linux/light
> - move driver headers into this directory
> - change header declaration per each driver source
> 
> Here is the cleanup list of light drivers.
> 
> (leds and backlight)
> include/linux/apple_bl.h
> include/linux/atmel_pwm.h
> include/linux/backlight.h
> include/linux/led-lm3530.h
> include/linux/leds-bd2802.h
> include/linux/leds.h
> include/linux/leds-lm3556.h
> include/linux/leds-lp3944.h
> include/linux/leds-lp5521.h
> include/linux/leds-lp5523.h
> include/linux/leds-pca9532.h
> include/linux/leds_pwm.h
> include/linux/leds-regulator.h
> include/linux/leds-tca6507.h
> include/linux/lp855x.h
> include/linux/pwm_backlight.h

Lots of those can move to include/linux/platform_data/ today, which
would clean up things a lot.  Care to do that first and see what is left
over and is really needed here?

thanks,

greg k-h
