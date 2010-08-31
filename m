Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab0HaLLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 07:11:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41386 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757159Ab0HaLLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 07:11:23 -0400
Date: Tue, 31 Aug 2010 12:11:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Onkalo Samu <samu.p.onkalo@nokia.com>
Cc: ext Alan Cox <alan@lxorguk.ukuu.org.uk>,
        ext Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH 1/3] drivers: misc: ak8974 / ami305 magnetometer driver
Message-ID: <20100831111120.GE20849@rakim.wolfsonmicro.main>
References: <1282910083-8629-1-git-send-email-samu.p.onkalo@nokia.com>
 <1282910083-8629-2-git-send-email-samu.p.onkalo@nokia.com>
 <20100827133109.1eb974ed@lxorguk.ukuu.org.uk>
 <1282928353.2194.27.camel@noppispoppis.nmp.nokia.com>
 <20100827185343.GA6626@opensource.wolfsonmicro.com>
 <1283151300.16404.18.camel@4fid08082>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283151300.16404.18.camel@4fid08082>
X-Cookie: glibido:
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 09:55:00AM +0300, Onkalo Samu wrote:

> Misc-char-device + sysfs interface:
> -----------------------------------
> PM related issues can be nicely handled with char device.
> It doesn't matter if there are one or several users. However
> char device with binary data format is not that handy in scripts.
> Same is true for input device. 

You could always have a char device with a text mode interface, I guess.

> Do you have any suggestions what could be the best way to handle this?

Not really without knowing more about how the device will be used and
the costs associated with powering it up and down - it's all a question
of tradeoffs depending on things like how fast userspace needs a
response and the expected usage patterns (many accesses in quick
succession, occasional widely spaced accesses...).
