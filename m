Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab1BTCUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 21:20:20 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:44815 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab1BTCUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 21:20:19 -0500
Message-ID: <92f5b87a3559ed7f1b7c46b7497c1ad5.squirrel@webmail.greenhost.nl>
In-Reply-To: <20110219182511.GA3977@viiv.ffwll.ch>
References: <3f9bbd0924f54f6241cc16293fbcbbb4.squirrel@webmail.greenhost.nl>
    <20110219182511.GA3977@viiv.ffwll.ch>
Date: Sun, 20 Feb 2011 03:20:15 +0100 (CET)
Subject: Re: [BUG] drm/i915 Screen corruption introduced by 
     a00b10c360b35d6431a94cb
From: "Indan Zupancic" <indan@nul.nu>
To: "Indan Zupancic" <indan@nul.nu>, "Chris Wilson" <chris@chris-wilson.co.uk>,
        "LKML" <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: f0eed3f1d89bc5fb772880ef8d54351a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, February 19, 2011 19:25, Daniel Vetter wrote:
> Hi Indan,
>
> Please provide the usual details about your system (especially what gpu
> this is on). Also, screenshots of what typical corruptions look like can
> help a lot in tracking down such things.

Sorry, I plainly forgot to mention that. I'm on my Thinkpad X40 with gen 2
hardware, 855GM.

I uploaded a screenshot of Firefox to:
http://img406.imageshack.us/img406/9159/31827167.png

It happens a lot when scrolling in FF on pages with images, pageup or pagedown
don't exhibit it. Text gets corrupted as well, but in a less predictable way.
It must be something that FF does that triggers it easily, I haven't managed
to get it with other programs yet, though I do see some corruption in the
window decoration too sometimes (which is Fluxbox). Scrolling horizontally
doesn't show the same behaviour. The corruptions seems to be happening on
the right side of a surface/window.

Forcing a refresh makes it go away again (e.g. switching to another window or
opening another window on top of it. Moving a window doesn't though). I get
it with and without xcompmgr running.

Okay, interesting titbit: For text corruption, the stripes are one pixel high
for the default font size, no corruption for smaller sizes than the default,
two pixel lines for 1 ctrl+ bigger than the default, 3 pixels for +2 etc.
With bigger sizes (>=5) I get less corruption to the left of the text, but
more in the text itself. The distance between the lines continues to increase,
but the stripes thickness goes back to 1 pixel.

Perhaps an off-by-one error somewhere?

> I've created two quick patches to check a few theories, please test them
> (both patches independently and both together). Patches attached.

Tried with both applied, doesn't change anything.

Greetings,

Indan


