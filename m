Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab1HHUZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 16:25:45 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:44587 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753212Ab1HHUZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 16:25:44 -0400
Date: Mon, 8 Aug 2011 13:25:31 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 2/4] drm/i915: Leave LVDS registers unlocked
Message-ID: <20110808132531.540e7605@jbarnes-desktop>
In-Reply-To: <yunliv31wk3.fsf@aiko.keithp.com>
References: <1312653248-3487-1-git-send-email-keithp@keithp.com>
	<1312653248-3487-3-git-send-email-keithp@keithp.com>
	<20110808093010.487c4559@jbarnes-desktop>
	<yunr54vu4lr.fsf@aiko.keithp.com>
	<20110808114954.23b62dd3@jbarnes-desktop>
	<yunobzz1xz8.fsf@aiko.keithp.com>
	<20110808130128.06654f54@jbarnes-desktop>
	<yunliv31wk3.fsf@aiko.keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Aug 2011 13:24:12 -0700
Keith Packard <keithp@keithp.com> wrote:

> On Mon, 8 Aug 2011 13:01:28 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > On Mon, 08 Aug 2011 12:53:31 -0700
> > Keith Packard <keithp@keithp.com> wrote:
> > 
> > > On Mon, 8 Aug 2011 11:49:54 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > 
> > > > Yep, it's safe and possible to do on pre-PCH as well.  For panel
> > > > fitting we do need to do an actual power cycle when going from
> > > > non-native back to native iirc, but we can still leave them unlocked so
> > > > we don't have to worry about the lock/unlock sequence everywhere.
> > > 
> > > Hidden in the unlock patch was a call to intel_lvds_disable from
> > > intel_lvds_prepare -- that *always* turns off the LVDS for mode
> > > setting. Do we care enough about LVDS mode setting performance that we
> > > should try leave the optimization in place that doesn't turn off the
> > > backlight when switching between modes?
> > 
> > We hate flicker right?  But generally yes it's safer to just turn it
> > off all the time.
> 
> I'll leave the optimization in place then; it's been there for a while
> so at least it shouldn't cause any regressions.
> 
> How about this? Has the advantage of not lying in the commit message
> anymore.
> 
> From 092719152aa5a235d6678798a34dc784d5cec2ad Mon Sep 17 00:00:00 2001
> From: Keith Packard <keithp@keithp.com>
> Date: Sat, 6 Aug 2011 10:33:12 -0700
> Subject: [PATCH 2/5] drm/i915: Leave LVDS registers unlocked
> 
> There's no reason to relock them; it just makes operations more
> complex. This fixes DPMS where the panel registers were locked making
> the disable not work.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>

Yeah looks like a nice improvement.

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
