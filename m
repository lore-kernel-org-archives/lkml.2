Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab0FXEqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 00:46:30 -0400
Received: from relay1.mail.timico.net ([62.121.20.91]:40738 "EHLO
	relay.timico.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab0FXEq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 00:46:29 -0400
X-Greylist: delayed 735 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jun 2010 00:46:29 EDT
From: Jon Povey <Jon.Povey@racelogic.co.uk>
To: Ryan Mallon <ryan@bluewatersys.com>, David Brownell <david-b@pacbell.net>
CC: David Brownell <dbrownell@users.sourceforge.net>,
       "gregkh@suse.de" <gregkh@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "ext-jani.1.nikula@nokia.com" <ext-jani.1.nikula@nokia.com>,
       =?Windows-1252?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Class: urn:content-classes:message
Date: Thu, 24 Jun 2010 05:46:11 +0100
Subject: RE: [RFC PATCH] Rework gpio cansleep (was Re: gpiolib and
 sleepinggpios)
Thread-Topic: [RFC PATCH] Rework gpio cansleep (was Re: gpiolib and
 sleepinggpios)
Thread-Index: AcsTCLPXm1J/0xM8TquwQCBaimfGuQATck8g
Message-ID: <70E876B0EA86DD4BAF101844BC814DFE08E0855B97@Cloud.RL.local>
In-Reply-To: <4C225CB2.6090407@bluewatersys.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryan Mallon wrote:

> If we strip my patch back to just introducing gpio_request_cansleep,
> which would be used in any driver where all of the calls are
> gpio_(set/get)_cansleep, and make gpio_request only allow non-sleeping
> gpios then incorrect use of gpios would be caught at request time and
> returned to the caller as an error.

It seems like a good idea to catch these at request time. There is support in the API for this already (gpio_cansleep), but driver writers are not steered towards checking and thinking in these ways by the current API or documentation. Perhaps a documentation change with some cut and paste boilerplate would be enough, but I think some API enforcement/encouragement would be helpful.

I think this agrees with you, Ryan:

gpio_request_cansleep would be the same as current gpio_request
gpio_request changes to error if this is a sleepy gpio.

Imagine a situation where GPIOs are being assigned and passed around between drivers in some dynamic way, or some way unpredictable to the driver writer. In development only non-sleeping GPIOs have been seen and everything is fine. One day someone feeds it a GPIO on an I2C expander and the driver crashes.
If gpio_request had this built-in check the driver could gracefuly fail to load instead with an appropriate error message.

--
Jon Povey
jon.povey@racelogic.co.uk

Racelogic is a limited company registered in England. Registered number 2743719 .
Registered Office Unit 10, Swan Business Centre, Osier Way, Buckingham, Bucks, MK18 1TB .

The information contained in this electronic mail transmission is intended by Racelogic Ltd for the use of the named individual or entity to which it is directed and may contain information that is confidential or privileged. If you have received this electronic mail transmission in error, please delete it from your system without copying or forwarding it, and notify the sender of the error by reply email so that the sender's address records can be corrected. The views expressed by the sender of this communication do not necessarily represent those of Racelogic Ltd. Please note that Racelogic reserves the right to monitor e-mail communications passing through its network


