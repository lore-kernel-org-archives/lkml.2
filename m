Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab2DWFaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 01:30:04 -0400
Received: from mail.southpole.se ([193.12.106.18]:45152 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab2DWFaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 01:30:03 -0400
Message-ID: <1335158999.5139.47.camel@jerome.southpole.se>
Subject: Re: [PATCH ] leds: add new transient trigger for one shot timer
 support
From: Jonas Bonn <jonas@southpole.se>
To: NeilBrown <neilb@suse.de>
Cc: shuahkhan@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Date: Mon, 23 Apr 2012 07:29:59 +0200
In-Reply-To: <20120423115610.2da4d4d7@notabene.brown>
References: <1333310039.2879.4.camel@lorien2> <1334064283.10826.6.camel@ted>
	 <1334507752.2723.3.camel@lorien2> <1334894674.3051.18.camel@lorien2>
	 <1334983269.2435.90.camel@jerome.southpole.se>
	 <1335138687.2882.20.camel@lorien2> <20120423115610.2da4d4d7@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 59000-07996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2012-04-23 at 11:56 +1000, NeilBrown wrote:
> I wonder if we should allow control of the brightness during the "on" time as
> well.
> You could set the brightness after enabling the timer, but awkward pauses or
> races could then leave the "led" permanently on.

echo transient > trigger
echo 200 > duration
echo 1 > activate
echo 100 > brightness

Worst case, the brightness doesn't get set and you get a 'bright' LED
until it expires... but at least it does expire!

> 
> Possibly we could hook into led_set_brightness() and restart the timer
> whenever the brightness was set - and remember the setting.

An easy way to do this might be to check the brightness setting at the
time the timer expires and save this value.  Next time the LED is
activated, we use this brightness setting instead of FULL_ON.  It would
be nice to keep this trigger self-contained and not have to hook into
led_set_brightness

You make interesting point about using the brightness property as the
actual timer trigger, though.  That's pretty elegant, but it does
require hooking into led_set_brightness.

/Jonas

