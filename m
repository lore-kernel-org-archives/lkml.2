Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab1KWMny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:43:54 -0500
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:37899 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750742Ab1KWMnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:43:52 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAAXpzE5tg6zW/2dsb2JhbABEqmqBBoFyAQEEATocIxAIAw44FCUDIS6HagK0MBKKUASUR5IM
Date: Wed, 23 Nov 2011 13:40:37 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Marc Vertes <marc.vertes@sigfox.com>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        HaraldWelte@viatech.com
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <20111123124037.GN23376@infomag.iguana.be>
References: <4ecb84b9.48rmEWqC3D6x18iE%marc.vertes@sigfox.com> <20111122112212.GD2734@pengutronix.de> <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com> <20111122173227.GK6624@sirena.org.uk> <20111122184051.GA30941@pengutronix.de> <4eccc3f0.iApQ//mCzaN3UsrB%marc.vertes@sigfox.com> <20111123104926.GB4063@pengutronix.de> <20111123121329.GM23376@infomag.iguana.be> <20111123122018.GA12227@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123122018.GA12227@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

> > Bottom line: Yes, there is hardware available that can only be pinged
> > and not be stopped, but No, Userspace needs the start/stop and ping
> > functionality so that a watchdog daemon can work correctly (which is
> > important because some watchdog daemons also do application testing.
> 
> Right, but if the hardware doesn't support this functionality it seems
> better to have the core deal with this rather than requiring the driver
> to implement empty operations.

As said, should indeed become part of the core, but the core needs to be
able to handle multiple devices and then this becomes more complex (because
some devices need and and other's don't).

Coming back to now: if the driver incorporates the timer (like all other
devices that can be started but not stopped once started do), then the start
and stop functions are not empty.
The timer (with the example that I prepared as part of the generic code) is
not so difficult and will be a good solution for the time being. (Unless
Dmitry Artamonow's comment about the fact that the watchdog could perhaps
be started and stopped is correct... This should be investigated first imho).

Kind regards,
Wim.

