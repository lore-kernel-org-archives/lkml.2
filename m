Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab2DHUU5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 16:20:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36661 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756019Ab2DHUUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 16:20:55 -0400
Message-ID: <1333916453.1801.2.camel@joe2Laptop>
Subject: Re: [PATCH] leds: simple_strtoul-cleanup
From: Joe Perches <joe@perches.com>
To: shuahkhan@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, rpurdie@linux.intel.com
Date: Sun, 08 Apr 2012 13:20:53 -0700
In-Reply-To: <1333916003.2845.6.camel@lorien2>
References: <1333916003.2845.6.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-08 at 14:13 -0600, Shuah Khan wrote:
> led-class.c and ledtri-timer.c still use simple_strtoul(). 
> Change leds to use kstrtoul() instead of obsolete simple_strtoul().
[]
> @@ -44,23 +44,19 @@ static ssize_t led_brightness_store(struct device *dev,
>  		struct device_attribute *attr, const char *buf, size_t size)
[] 
> diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
> @@ -31,21 +31,18 @@ static ssize_t led_delay_on_store(struct device *dev,
>  		struct device_attribute *attr, const char *buf, size_t size)
[]
>  static ssize_t led_delay_off_show(struct device *dev,
[]
> +out:
> +	return size;

These now don't return -EINVAL, is that a problem
for any caller?

