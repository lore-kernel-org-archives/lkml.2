Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143Ab2DKUDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:03:45 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50909 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932951Ab2DKUDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:03:43 -0400
Date: Wed, 11 Apr 2012 22:04:34 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 4/8 v7] drm/i915/intel_i2c: use WAIT cycle, not STOP
Message-ID: <20120411200434.GS4296@phenom.ffwll.local>
Mail-Followup-To: Daniel Kurtz <djkurtz@chromium.org>,
	Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Benson Leung <bleung@chromium.org>,
	Yufeng Shen <miletus@chromium.org>
References: <1333108003-6341-1-git-send-email-djkurtz@chromium.org>
 <1333108003-6341-5-git-send-email-djkurtz@chromium.org>
 <20120410103746.GH4115@phenom.ffwll.local>
 <20120410104147.GI4115@phenom.ffwll.local>
 <CAGS+omAjDPxs1qR-EwzKhjE9c5J26fZinv6+5RFz1RyAsfStmw@mail.gmail.com>
 <20120410150304.GJ4115@phenom.ffwll.local>
 <CAGS+omD9dTTK4gRERy406nLFEMfqC=hw6ZFe3_V9yacSR2r9Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGS+omD9dTTK4gRERy406nLFEMfqC=hw6ZFe3_V9yacSR2r9Sw@mail.gmail.com>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 02:16:45AM +0800, Daniel Kurtz wrote:
> On Tue, Apr 10, 2012 at 11:03 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> > - atm the debug output is too noisy. I think we can leave the fallback to
> >  gpio bitbanging at info (or maybe error) level, but all the other
> >  messages should be tuned down to DRM_DEBUG_KMS - these can easily be hit
> >  when userspace tries to probe the i2c with nothing connected or if the
> >  driver code tries to do the same. See:
> >  https://bugs.freedesktop.org/show_bug.cgi?id=48248
> 
> OK...  we can change the logging level.
> However, the log in the bug to which you link seems to indicate a more
> serious issue in this case.  It says to me that something on his
> system is trying to talk to the disabled dpc i2c port 5 times every 10
> seconds.  Each time it fails due with a time out, and each timeout
> takes 50ms.  I would argue that the INFO message here is pointing out
> that the hotplug code might want to check the corresponding
> PORT_ENABLED bit before attempting a read over a particular DP/HDMI
> gmbus port.  Perhaps I am mistaken, but if there was really nothing on
> the bus, shouldn't that be a NAK, not a timeout?

The issue is that there's no hotplug, so we run a polling loop which
checks every 10s whether anything is connected. Part of that is trying to
read an edid. I dunno exactly why we don't get a NAK but a timeout.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
