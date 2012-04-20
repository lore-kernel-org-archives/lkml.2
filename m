Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab2DTHVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 03:21:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:56776 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab2DTHVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 03:21:40 -0400
Message-ID: <1334906476.3197.11.camel@pasglop>
Subject: Multitouch regression in 3.3 on thinkpad X220 clickpad
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Daniel Drake <dsd@laptop.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        "X.Org Devel List" <xorg-devel@lists.freedesktop.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Fri, 20 Apr 2012 17:21:16 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks !

So Peter and I have been discussing a problem I observed on my brand new
ThinkPad X220 and it's multitouch "clickpad". I've been digging a bit
more today and bisected the regression to:

commit 7968a5dd492ccc38345013e534ad4c8d6eb60ed1
Input: synaptics - add support for Relative mode

Without that commit, I can draw two "traces" when using two fingers in
mtview (after removing the device from X), each follow one finger.

With that commit applied, this doesn't work anymore: it appears to be
unable to track more than one finger. IE. If i put a finger on the
touchpad, I can draw, but a second finger is then ignored (or causes one
or two spots in a random place to appear but that's about it).

Now other multitouch operations such as two finger scrolling seem to
work in X. I'm not familiar with the inner workings of the input layer
or the synaptic touchpads. I'll dig a bit more this week-end if I have
time, but it would save me plenty of that precious time if you guys
could hint me at things to look at :-)

I have a couple more bits of interesting info.

If I boot with a "bad" driver. rmmod it. insmod a "good" one (one build
from the same kernel tree set to the commit right before the one above)
then things work fine. The interesting bit is that if I then rmmod it
and insmod the "bad" one again ... it still works. So it looks like it
might have something to do with how the touchpad is initialized.

Some more info about the touchpad itself from dmesg:

psmouse serio1: synaptics: Touchpad model: 1, fw: 8.0, id: 0x1e2b1, caps: 0xd001a3/0x940300/0x120c00
psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input13

Let me know if there's any other info of value I can collect. 

Cheers,
Ben.


