Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab0IWWfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:35:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752747Ab0IWWfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:35:46 -0400
Date: Thu, 23 Sep 2010 15:35:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Richard Purdie <rpurdie@rpsys.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] led-class: always implement blinking
Message-Id: <20100923153512.3bad01d8.akpm@linux-foundation.org>
In-Reply-To: <1285163638.3684.61.camel@jlt3.sipsolutions.net>
References: <1282296102.3785.28.camel@jlt3.sipsolutions.net>
	<20100921124419.6b88f7f6.akpm@linux-foundation.org>
	<1285098497.12764.18.camel@jlt3.sipsolutions.net>
	<1285104248.1290.551.camel@rex>
	<1285148716.3684.11.camel@jlt3.sipsolutions.net>
	<1285163638.3684.61.camel@jlt3.sipsolutions.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010 15:53:58 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> Currently, blinking LEDs can be awkward because it is
> not guaranteed that all LEDs implement blinking. The
> trigger that wants it to blink then needs to implement
> its own timer solution.
> 
> Rather than require that, add led_blink_set() API that
> triggers can use. This function will attempt to use hw
> blinking, but if that fails implements a timer for it.
> To stop blinking again, brightness_set() also needs to
> be wrapped into API that will stop the software blink.
> 
> As a result of this, the timer trigger becomes a very
> trivial one, and hopefully we can finally see triggers
> using blinking as well because it's always easy to use.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> v2: - update documentation
>     - use documented way of turning blinking off
>       by setting brightness to 0 rather than by
>       setting delays to (0, 0)
>     - add API to start blinking, set brightness
>       (the latter will also stop sw blinking)
> v3: - make LEDS_CLASS a bool rather than tristate
>       because LEDS_TRIGGERS now depends on symbols
>       it exports

`make oldconfig' says

boolean symbol LEDS_CLASS tested for 'm'? test forced to 'n'
