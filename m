Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0FWWx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 18:53:58 -0400
Received: from mail2.shareable.org ([80.68.89.115]:56746 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0FWWx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 18:53:57 -0400
Date: Wed, 23 Jun 2010 23:53:45 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux kernel <linux-kernel@vger.kernel.org>,
       ext-jani.1.nikula@nokia.com,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] Rework gpio cansleep (was Re: gpiolib and sleeping gpios)
Message-ID: <20100623225345.GD7058@shareable.org>
References: <191168.5104.qm@web180308.mail.gq1.yahoo.com> <4C21955D.1020502@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C21955D.1020502@bluewatersys.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryan Mallon wrote:
> On 06/23/2010 04:37 PM, David Brownell wrote:
> I'm not. Some gpios, such as those on io expanders, may sleep in their
> implementations of the gpio_(set/get) functions.

I'm having a hard time figuring out where some GPIOs I'm using fit
into this picture.

I have some hardware that is currently using a 2.4.26 kernel, but I
look from time to time at forward-porting all the drivers to 2.6.recent.

It has an I2C driven GPIO expander, with a watchdog reset chip hanging
off the expander.

The watchdog is kept alive off the back end of a timer BH, which means
the I2C GPIO routines are written to be safe in BH context (which
isn't sleepable), but they can't be used in IRQ context because the
necessary spin_lock_irqsave() would turn off interrupts for too long
for other subsystems to function properly.

How should I flag those GPIO routines in your scheme?  They're safe to
use in some non-sleeping contexts, but not safe in irq context.

Thanks,
-- Jamie
