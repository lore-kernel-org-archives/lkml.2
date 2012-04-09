Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab2DIO0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 10:26:08 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:25623 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab2DIO0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 10:26:06 -0400
Message-ID: <1333981564.2871.1.camel@lorien2>
Subject: Re: [PATCH] leds: simple_strtoul-cleanup
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Joe Perches <joe@perches.com>
Cc: shuahkhan@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, rpurdie@linux.intel.com
Date: Mon, 09 Apr 2012 08:26:04 -0600
In-Reply-To: <1333916453.1801.2.camel@joe2Laptop>
References: <1333916003.2845.6.camel@lorien2>
	 <1333916453.1801.2.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-08 at 13:20 -0700, Joe Perches wrote:
> On Sun, 2012-04-08 at 14:13 -0600, Shuah Khan wrote:
> > led-class.c and ledtri-timer.c still use simple_strtoul(). 
> > Change leds to use kstrtoul() instead of obsolete simple_strtoul().
> []
> > @@ -44,23 +44,19 @@ static ssize_t led_brightness_store(struct device *dev,
> >  		struct device_attribute *attr, const char *buf, size_t size)
> [] 
> > diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
> > @@ -31,21 +31,18 @@ static ssize_t led_delay_on_store(struct device *dev,
> >  		struct device_attribute *attr, const char *buf, size_t size)
> []
> >  static ssize_t led_delay_off_show(struct device *dev,
> []
> > +out:
> > +	return size;
> 
> These now don't return -EINVAL, is that a problem
> for any caller?

I looked at the other _store() interfaces in leds - there is no
consistent EINVAL return. However, it would be an easy change to make to
have these return EINVAL in case of error like they used to. I can send
an updated patch.

-- Shuah

