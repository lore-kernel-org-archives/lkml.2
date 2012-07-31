Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab2GaMNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 08:13:06 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59423 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab2GaMNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 08:13:05 -0400
Date: Tue, 31 Jul 2012 14:14:52 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH can-next v3 1/2] can: add tx/rx LED trigger support
Message-ID: <20120731121452.GC30417@gmail.com>
References: <1343676041-29572-1-git-send-email-fabio.baltieri@gmail.com>
 <50179B81.3040907@grandegger.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50179B81.3040907@grandegger.com>
X-Operating-System: Linux balto-eee 3.5.0-balto-eee-07086-g6f8d3bf GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 10:46:57AM +0200, Wolfgang Grandegger wrote:
> Hi Fabio,
> 
> On 07/30/2012 09:20 PM, Fabio Baltieri wrote:
> > This patch implements the functions to add two LED triggers, named
> > <ifname>-tx and <ifname>-rx, to a canbus device driver.
> > 
> > Triggers are called from specific handlers by each CAN device driver and
> > can be disabled altogether with a Kconfig option.
> > 
> > The implementation keeps the LED on when the interface is UP and blinks
> > the LED on network activity at a configurable rate.
> > 
> > This only supports can-dev based drivers, as it uses some support field
> > in the can_priv structure.
> > 
> > Supported drivers should call can_led_init(), can_led_exit() and
> > can_led_event() as needed.
> > 
> > Supported events are:
> > - CAN_LED_EVENT_OPEN: turn on tx/rx LEDs
> > - CAN_LED_EVENT_STOP: turn off tx/rx LEDs
> > - CAN_LED_EVENT_TX: trigger tx LED blink
> > - CAN_LED_EVENT_RX: trigger tx LED blink
> > 
> > Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> > Cc: Wolfgang Grandegger <wg@grandegger.com>
> > Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
> > ---
> > 
> > Hi all!
> > 
> > This is the v3 of my CAN LED trigger patch.  It's a major refactoring of the v2
> > that was discussed about three months ago concluding with the idea that
> > implementing the oneshot triggering code in the LED framework would be a better
> > solution.
> > 
> > This is the old thread for reference:
> > http://marc.info/?l=linux-can&m=133521499002898&w=2
> > 
> > So, generic oneshot trigger code is now merged in mainline (see 5bb629c), and
> > these are the changes in the v3:
> 
> Nice, thanks for your patience (and not giving up).

Thanks to you for the review... no intention of giving up, I'm learning
a lot from this! ;-)

Fabio
