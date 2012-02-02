Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551Ab2BBW2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:28:31 -0500
Received: from mail4.aviatnet.com ([192.147.115.31]:51997 "EHLO
	mail4.aviatnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932556Ab2BBW2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:28:30 -0500
Subject: Re: [PATCH v3] rtc: ds1307: generalise ram size and offset
From: Austin Boyle <Austin.Boyle@aviatnet.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
In-Reply-To: <1328143057.3159.34.camel@pc786-ubu.gnet.global.vpn>
References: <1326144071.3096.25.camel@pc786-ubu.gnet.global.vpn>
	 <20120111110650.GC2605@pengutronix.de>
	 <1326320516.3096.64.camel@pc786-ubu.gnet.global.vpn>
	 <20120119194541.GA32483@pengutronix.de>
	 <1328143057.3159.34.camel@pc786-ubu.gnet.global.vpn>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 3 Feb 2012 11:28:24 +1300
Message-ID: <1328221704.3159.50.camel@pc786-ubu.gnet.global.vpn>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.16.1.34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

I have been thinking about this some more but maybe I don't understand
the problem...

> > ... that nvram is static and we are changing it. Yeah, it is very unlikely but
> > if we have two RTC with different nvram sizes, one of them will not work correctly.
> I see the issue. Am I right that it would only occur when you have two
> I2C buses, each with one of the RTC chips supported by this driver?

On my system, it looks like each rtc would have it's own directory e.g.:
# ls /sys/class/rtc
rtc0
# cat /sys/class/rtc/rtc0/device/name
ds1388
# ls /sys/class/rtc/rtc0/device/
driver     modalias   name    nvram    rtc    subsystem     uevent

So if you have multiple RTCs, even of the same type, they would be in
rtc0, rtc1, rtc2

Since they each have their own nvram, does it matter if the size is
changed?

Cheers,
Austin.

