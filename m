Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab2DTQp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:45:58 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52323 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752432Ab2DTQp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:45:57 -0400
Date: Fri, 20 Apr 2012 18:45:53 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Purdie <rpurdie@rpsys.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 3/4] leds: add LM3533 LED driver
Message-ID: <20120420164553.GA12376@localhost>
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
 <1334935826-12527-4-git-send-email-jhovold@gmail.com>
 <201204201610.15758.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204201610.15758.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 04:10:15PM +0000, Arnd Bergmann wrote:
> On Friday 20 April 2012, Johan Hovold wrote:
> > Add sub-driver for the LEDs in National Semiconductor / TI LM3533
> > lighting power chips.
> > 
> > The chip provides 256 brightness levels, hardware accelerated blinking
> > as well as ambient-light-sensor and pwm input control.
> > 
> > Signed-off-by: Johan Hovold <jhovold@gmail.com>
> 
> I notice that there is already driver for lm3530, which sounds related.
> Is there an opportunity to share code between these, or are they completely
> different devices?

Unfortunately not. They are really very different devices despite
similar naming and terminology.

> > +
> > +#define show_ctrlbank_attr(_name)					\
> > +static ssize_t show_##_name(struct device *dev,				\
> > +				struct device_attribute *attr,		\
> > +				char *buf)				\
> > +{									\
> > +	struct led_classdev *led_cdev = dev_get_drvdata(dev);		\
> > +	struct lm3533_led *led = to_lm3533_led(led_cdev);		\
> > +	u8 val;								\
> > +	int ret;							\
> > +									\
> > +	ret = lm3533_ctrlbank_get_##_name(&led->cb, &val);		\
> > +	if (ret)							\
> > +		return ret;						\
> > +									\
> > +	return scnprintf(buf, PAGE_SIZE, "%d\n", val);			\
> > +}
> 
> IMHO this macro adds more in terms of complexity than it saves in terms
> of lines of code, and it would be better to open-code the two instances.
> If you need more than two or three instances, I would recommend creating
> keying the number off of the attribute pointer, either by comparing the
> pointer or by adding a data structure derived from device_attribute and
> using container_of to get at the other data.

Agreed. I'll simply open-code them for now, and do the same with the
equivalent instances in the backlight driver.

Thanks,
Johan
