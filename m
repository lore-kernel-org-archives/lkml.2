Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1HaVId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:08:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60035 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab1HaVIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:08:32 -0400
Date: Wed, 31 Aug 2011 14:08:26 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Marcel Korpel <marcel.lists@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Changes to include/linux/input.h are no longer taken into account
Message-ID: <20110831210825.GA32646@core.coreip.homeip.net>
References: <CAJuji_EeLBCB4qpbCQLGFgqAqsWJ97qKYPK8b7hDa91Xr50Tmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuji_EeLBCB4qpbCQLGFgqAqsWJ97qKYPK8b7hDa91Xr50Tmg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

On Sat, Aug 27, 2011 at 10:44:30PM +0200, Marcel Korpel wrote:
> Hi,
> 
> Up until recently, in order to be able to use the zoom slider on my MS
> Natural Ergonomic Keyboard 4000 I used a patched version of
> include/linux/input.h, in which a few definitions were changed so
> several special keys produced keycodes <= 255, like
> 
> #define KEY_ZOOMIN		0x0f6	/* AC Zoom In == 246 */
> #define KEY_ZOOMOUT		0x0f7	/* AC Zoom Out == 247  */
> 
> Now X is able to process these keycodes.
> 
> Earlier this month, I upgraded the kernel and made sure that input.h
> still contained these changed values. However, when I use showkey I
> get the following output
> 
> keycode 418 press
> keycode 418 release
> keycode 419 press
> keycode 419 release
> 
> instead of the lower values I provided. I flipped through the latest
> kernel changes, but was not able to find a change that might have
> influenced the keycodes, only one change about the inclusion order
> inside linux/input.h [1]. I am currently using commit
> d31bf2883542cd3414674238f94123bd1d9c0b9f.
> 
> I know that the actual problem resides in the way how X handles
> keycodes [2] and it can (also) be circumvented using a patched
> xf86-input-evdev [3], but I still think this case is a bug.
> 

Make sure udev does not load a custom map for this device for you.

Thanks.

-- 
Dmitry
