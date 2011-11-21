Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab1KULFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 06:05:43 -0500
Received: from mga14.intel.com ([143.182.124.37]:53633 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955Ab1KULFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 06:05:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,546,1315206000"; 
   d="scan'208";a="77503043"
Date: Mon, 21 Nov 2011 19:05:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Keith Packard <keithp@keithp.com>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] drm/i915: hot removal notification to HDMI audio
 driver
Message-ID: <20111121110538.GB6519@localhost>
References: <20111116132004.299754849@intel.com>
 <20111116132221.374839261@intel.com>
 <20111116133548.GA23804@localhost>
 <20111118093740.GA2799@localhost>
 <86aa7tmigr.fsf@sumi.keithp.com>
 <20111121015809.GA25148@localhost>
 <s5haa7plv4l.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5haa7plv4l.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 04:47:38PM +0800, Takashi Iwai wrote:
> At Mon, 21 Nov 2011 09:58:09 +0800,
> Wu Fengguang wrote:
> > 
> > On Sat, Nov 19, 2011 at 01:46:44AM +0800, Keith Packard wrote:
> > > On Fri, 18 Nov 2011 17:37:40 +0800, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > 
> > > > However when in X, ->mode_set won't be called at all.  Only
> > > > ->get_modes and ->detect are called...
> > > 
> > > The desktop software will call mode_set when it configures the
> > > monitor. Otherwise, it's not being used (and so shouldn't have audio
> > > routed to it by default).
> > 
> > Keith, I experimented playing HDMI audio in X, and during the time
> > unplug and plug the monitor. The HDMI audio/graphics all continue to
> > work when plugged in the monitor again. Here is the dmesg showed for
> > the plug event, no ->mode_set is called at all...
> 
> Which desktop system are you using?  At hotplug/unplugging, the kernel
> drm issues a udev event, X Intel driver receives it and updates
> Xrandr.  Then it's supposed that a daemon like gnome-settings-daemon
> receives Xrandr notification and changes the modes appropriately.
> Without such a background task, there will be no mode change.

Ah I got it. I'm running debian+fluxbox w/o those fancy features...

Thanks,
Fengguang
