Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab2LQJei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 04:34:38 -0500
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:23149 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751269Ab2LQJeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 04:34:37 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEFAOrmzlBthYXF/2dsb2JhbABFhju0LINKF3OCHgEBBSMzIxALGAICJgICFCUkiCqnPZIVgSKLO4MwMmEDlgmQSYJ0
Date: Mon, 17 Dec 2012 10:34:14 +0100
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Bernd Krumboeck <krumboeck@universalnet.at>
Cc: Fabio Baltieri <fabio.baltieri@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] can: add tx/rx LED trigger support
Message-ID: <20121217093414.GA17341@vandijck-laurijssen.be>
Mail-Followup-To: Bernd Krumboeck <krumboeck@universalnet.at>,
	Fabio Baltieri <fabio.baltieri@gmail.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
	Wolfgang Grandegger <wg@grandegger.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	linux-kernel@vger.kernel.org
References: <1355656113-9562-1-git-send-email-fabio.baltieri@gmail.com>
 <1355656113-9562-2-git-send-email-fabio.baltieri@gmail.com>
 <50CEC9B0.3040503@universalnet.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50CEC9B0.3040503@universalnet.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 08:28:48AM +0100, Bernd Krumboeck wrote:
> Hello Fabio!
> 
> Am 2012-12-16 12:08, schrieb Fabio Baltieri:
> >This patch implements the functions to add two LED triggers, named
> ><ifname>-tx and <ifname>-rx, to a canbus device driver.
> >
> >Triggers are called from specific handlers by each CAN device driver and
> >can be disabled altogether with a Kconfig option.
> >
> >The implementation keeps the LED on when the interface is UP and blinks
> >the LED on network activity at a configurable rate.
> >
> >This only supports can-dev based drivers, as it uses some support field
> >in the can_priv structure.
> >
> >Supported drivers should call devm_can_led_init() and can_led_event() as
> >needed.
> >
> >Cleanup is handled automatically by devres, so no *_exit function is
> >needed.
> >
> >Supported events are:
> >- CAN_LED_EVENT_OPEN: turn on tx/rx LEDs
> >- CAN_LED_EVENT_STOP: turn off tx/rx LEDs
> >- CAN_LED_EVENT_TX: trigger tx LED blink
> >- CAN_LED_EVENT_RX: trigger tx LED blink
> 
> Why there is no patch for any usb can device?
> 
> Can this be done in a more general way, except patching every driver?

There must be a way.
Up to this series, there were a few minor problems:
* determine if a CAN device is can_dev based
* led trigger calls.

After this series, I think it's possible to make this functionality generic.
But up to then, this per-driver code is a working model.

Kind regards,
Kurt
