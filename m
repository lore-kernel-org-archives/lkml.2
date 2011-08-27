Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab1H0Uod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 16:44:33 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:58279 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab1H0Uob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 16:44:31 -0400
MIME-Version: 1.0
Date: Sat, 27 Aug 2011 22:44:30 +0200
Message-ID: <CAJuji_EeLBCB4qpbCQLGFgqAqsWJ97qKYPK8b7hDa91Xr50Tmg@mail.gmail.com>
Subject: Changes to include/linux/input.h are no longer taken into account
From: Marcel Korpel <marcel.lists@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Up until recently, in order to be able to use the zoom slider on my MS
Natural Ergonomic Keyboard 4000 I used a patched version of
include/linux/input.h, in which a few definitions were changed so
several special keys produced keycodes <= 255, like

#define KEY_ZOOMIN		0x0f6	/* AC Zoom In == 246 */
#define KEY_ZOOMOUT		0x0f7	/* AC Zoom Out == 247  */

Now X is able to process these keycodes.

Earlier this month, I upgraded the kernel and made sure that input.h
still contained these changed values. However, when I use showkey I
get the following output

keycode 418 press
keycode 418 release
keycode 419 press
keycode 419 release

instead of the lower values I provided. I flipped through the latest
kernel changes, but was not able to find a change that might have
influenced the keycodes, only one change about the inclusion order
inside linux/input.h [1]. I am currently using commit
d31bf2883542cd3414674238f94123bd1d9c0b9f.

I know that the actual problem resides in the way how X handles
keycodes [2] and it can (also) be circumvented using a patched
xf86-input-evdev [3], but I still think this case is a bug.

Kind regards, Marcel

[1] http://lkml.indiana.edu/hypermail//linux/kernel/1107.3/02089.html
[2] https://bugs.freedesktop.org/show_bug.cgi?id=11227
[3] http://www.thenautilus.net/SW/xf86-input-evdev/
