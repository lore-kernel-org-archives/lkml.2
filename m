Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab1AWWzi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 17:55:38 -0500
Received: from solo.fdn.fr ([80.67.169.19]:47262 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab1AWWzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 17:55:37 -0500
Date: Sun, 23 Jan 2011 23:55:33 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: rpurdie@rpsys.net, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] leds: add keyboard num/caps lock trigger
Message-ID: <20110123225533.GB9863@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Arnaud Patard <arnaud.patard@rtp-net.org>, rpurdie@rpsys.net,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20110113125921.818344418@rtp-net.org> <20110113131323.GJ5995@const.bordeaux.inria.fr> <87aaj01k2q.fsf@lechat.rtp-net.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87aaj01k2q.fsf@lechat.rtp-net.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Arnaud Patard, le Mon 17 Jan 2011 00:54:05 +0100, a écrit :
> > This is already being implemented in a more generic and useful way,
> > also permitting to use the keyboard leds for other triggers, see the
> > leds-route-kbd-leds-through-the-generic-leds-layer.patch in the mm tree,
> > and the “route kbd LEDs through the generic LEDs layer” thread here.
> 
> I've download the patch at [1] and after a quick runtime test, got no
> success. When booting with the LEDS_INPUT set to y, the machine is
> hanging. I didn't have a serial console at hand so no log for now. I've
> then tried it as module, and it didn't work too. No freeze, but led
> state did not change.

Odd, in my memory it was working for me.

> Moreover, I found a bug. The kbd_update_leds_helper() change is
> wrong. It should use !!(leds & (1<<VC_*)) and not !!(leds & VC_*).

Indeed. This has actually disappeared in the version I'm working on from
the feedback provided by Dmitry.

> btw, my use case/problem is different than yours.

Yes, but my implementation fills both needs.

> I've a arm system where the keyboard is usb hid one and the led I'm
> trying to control a led connected on a gpio.

Then simply connect it to the new e.g. "input::numl" (or "vt::numl" as
per new name according to Dmitry's feedback) trigger provided by my
patch.

Samuel
