Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab1FFRNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:13:13 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:35369 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab1FFRNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:13:06 -0400
Date: Mon, 6 Jun 2011 13:12:53 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Keith Packard <keithp@keithp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Regression: Borked display on second output with Intel G45 in 3.0-rc2
Message-ID: <20110606171253.GA2925@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After upgrading to 3.0-rc2, my second display is no longer working
correctly on a desktop with an Intel G45 graphics chip.  The system has
two displays, one connected by HDMI and the other by VGA.

Both displays work fine in the console; the troubles begin after
starting X.  It *looks* as if one of the displays is still scanning out
from the old framebuffer: what I see on the VGA monitor after starting X
is a black screen with a console cursor at the top -- this is just like
an empty VT except that the cursor is not blinking.  If I switch to VT 1
and then back to X, the display contains all the bootup text that was on
VT 1.  In any case, the mouse cursor works properly on the display.
There are no unusual messages in dmesg or the Xorg log in any case.

If I fiddle around with the xrandr tool (e.g. do an xrandr --output VGA1
--same-as HDMI1 && xrandr --output VGA1 --right-of VGA1) , it's possible
to get both displays showing the right thing.  But then if I switch back
to the console, I end up with one display showing the console text and
the other is still showing my X session!  (In this instance, the VGA was
working and the HDMI was showing the wrong thing).

This is a regression from 2.6.39, but that's not the whole story: this
problem appears to have been introduced very briefly late in the 2.6.39
-rc cycle and subsequently fixed on mainline.  It then reappeared during
the 3.0 merge window.  Unfortunately, this fact seems to make it
impossible to bisect to a specific commit.

What I do know is that the problem was originally introduced by
49183b2818de ("drm/i915: Only enable the plane after setting the fb
base (pre-ILK)").  It was subsequently fixed by 982b2035d9d7 ("Revert
"drm/i915: Only enable the plane after setting the fb base (pre-ILK)"").
The problem was reintroduced by 98b98d316349 ("Merge branch 'drm-core-next'
of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6").
Unfortunately, I cannot be more specific than that because it appears
that the entire drm side of that merge consists of 'bad' commits and git
bisect gets very confused.

Let me know if you need any more info,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
