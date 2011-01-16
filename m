Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1APXtO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 18:49:14 -0500
Received: from lechat.rtp-net.org ([88.191.19.38]:43508 "EHLO
	lechat.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab1APXtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 18:49:12 -0500
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: rpurdie@rpsys.net, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] leds: add keyboard num/caps lock trigger
Organization: RtpNet
References: <20110113125921.818344418@rtp-net.org>
	<20110113131323.GJ5995@const.bordeaux.inria.fr>
Date: Mon, 17 Jan 2011 00:54:05 +0100
In-Reply-To: <20110113131323.GJ5995@const.bordeaux.inria.fr> (Samuel
	Thibault's message of "Thu, 13 Jan 2011 14:13:23 +0100")
Message-ID: <87aaj01k2q.fsf@lechat.rtp-net.org>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault <samuel.thibault@ens-lyon.org> writes:

> Hello,

Hi,
>
>
> Arnaud Patard, le Thu 13 Jan 2011 13:59:13 +0100, a écrit :
>> Implement a led trigger which enable/disable a led according
>> to keyboard leds events.
>
> This is already being implemented in a more generic and useful way,
> also permitting to use the keyboard leds for other triggers, see the
> leds-route-kbd-leds-through-the-generic-leds-layer.patch in the mm tree,
> and the “route kbd LEDs through the generic LEDs layer” thread here.

I've download the patch at [1] and after a quick runtime test, got no
success. When booting with the LEDS_INPUT set to y, the machine is
hanging. I didn't have a serial console at hand so no log for now. I've
then tried it as module, and it didn't work too. No freeze, but led
state did not change.
Moreover, I found a bug. The kbd_update_leds_helper() change is
wrong. It should use !!(leds & (1<<VC_*)) and not !!(leds & VC_*).

btw, my use case/problem is different than yours. I've a arm system
where the keyboard is usb hid one and the led I'm trying to control a
led connected on a gpio.

Arnaud

[1] http://userweb.kernel.org/~akpm/mmotm/broken-out/leds-route-kbd-leds-through-the-generic-leds-layer.patch
