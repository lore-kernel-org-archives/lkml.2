Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab2BOXSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 18:18:43 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:36682 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab2BOXSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 18:18:41 -0500
Date: Thu, 16 Feb 2012 00:18:53 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [BUG] Intel HD Graphic QM57 chipset: Dell U3011 monitor turns to
 power saving mode
Message-ID: <20120215231853.GE26578@phenom.ffwll.local>
Mail-Followup-To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
References: <20120121185621.GA31106@Krystal>
 <86ehuskc4j.fsf@sumi.keithp.com>
 <20120122174829.GA8789@Krystal>
 <20120215201652.GA20425@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215201652.GA20425@Krystal>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 03:16:52PM -0500, Mathieu Desnoyers wrote:
> * Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> > Hi Keith,
> > 
> > * Keith Packard (keithp@keithp.com) wrote:
> > > On Sat, 21 Jan 2012 13:56:21 -0500, Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > > 
> > > > Dell U3011 monitor turns to power saving mode when resolution set to 2560 x 1600
> > > > (intermittent)
> > > > 
> > > > Reproduced with:
> > > > Linux 2.6.38-1-amd64 (Debian kernel)
> > > > Linux 3.1.0-1-amd64  (Debian kernel)
> > > > Linux 3.2.0-1-amd64  (Debian kernel)
> > > > 
> > > > The computer is a Lenovo X201 Tablet (Intel QM57 chipset), on a X200
> > > > docking station. The docking station uses a DisplayPort cable to connect
> > > > to the monitor.  I tried upgrading my Bios from 1.34/1.13 to 1.38/1.14
> > > > (latest), which did not fix the problem. I cannot use anything else
> > > > than DisplayPort in this case to connect the monitor at 2560 x 1600,
> > > > because this resolution requires either the bandwidth provided by a
> > > > dual-link DVI (which I cannot connect in my docking station), or
> > > > DisplayPort.
> > > 
> > > I use this same monitor, and have run it with an X200 in the past.
> > > 
> > > Can you capture a dmesg output with the kernel parameter drm.debug=0xe
> > > set? That will let us see the DP link training adventure and see what's
> > > broken. If you can, separate traces of working and non-working tries
> > > would be nice.
> > > 
> > > And, of course, trying 3.3-rc1 would be helpful as that's what any
> > > test patches would be developed on top of.
> > 
> > I've compiled and launched a 3.3-rc1 kernel for the following tests. The
> > dmesg log follows.
> > 
> > FWIW, when I get the screen to run, if I launch this 1080p video with
> > either mplayer or vlc (http://www.bigbuckbunny.org/index.php/download/,
> > 1920x1080, mp4 format) in full screen, I get an horizontal line of blur
> > at about 7/8 of the screen (from the top) when there is a lot of
> > movement in the movie.  This looks like a vertical refresh sync issue
> > and/or too small buffers for double(/triple)-buffering. I'm aware that
> > this is a separate issue, but it might help the current investigation.
> > The xrandr -q --verbose gives "+HSync -VSync" for the monitor, even
> > though its EDID (taken with get-edid/parse-edid) specifies "Flags
> > "-HSync" "+VSync"". So hsync and vsync +/- seems to be mixed up.
> 
> Another piece of information on this issue: I tried the monitor with an
> Apple PowerBook running MacOS X, and the monitor works flawlessly
> (monitor always brought up, and the same video works without glitch with
> vlc).
> 
> I also simplified my routine that successfully bring the monitor into a
> working state: running 5 to 20 times the following script ends up doing
> the trick:
> 
> xrandr --output DP1 --off
> sleep 1
> xrandr --output DP1 --mode 2560x1600
> 
> Please let me know if I can provide more information on the issue than
> the detailed logs (success/fail) below. I would also like to know if
> there is a knob somewhere in the Intel driver I could play with to
> provide more time for the screen to send its EDID information. Based on
> this info: http://www.intel.com/support/graphics/sb/CS-028366.htm, Intel
> provide a modified Windows driver that might target this kind of issue,
> and I assume they possibly let more time than the spec requires for the
> screen to send EDID info.

Well, we unfortunately have a bunch of dp link training issues left. But
currently I'm not aware of any patches that might help. The best way
forward is likely to file a bugzilla on bugs.freedesktop.org with all the
information you've already gathered (against DRI, DRM/Intel) so that this
won't get lost.

Thanks, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
