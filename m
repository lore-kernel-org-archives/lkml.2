Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933431Ab2C3Pcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:32:53 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63589 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab2C3Pcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:32:43 -0400
Date: Fri, 30 Mar 2012 17:33:14 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 0/8 v7] fix gmbus writes and related issues
Message-ID: <20120330153314.GA25659@phenom.ffwll.local>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Benson Leung <bleung@chromium.org>,
	Yufeng Shen <miletus@chromium.org>
References: <1333108003-6341-1-git-send-email-djkurtz@chromium.org>
 <1333111775_156407@CP5-2952>
MIME-Version: 1.0
In-Reply-To: <1333111775_156407@CP5-2952>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 01:49:17PM +0100, Chris Wilson wrote:
> On Fri, 30 Mar 2012 19:46:35 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> > This patchset addresses a couple of issues with the i915 gmbus
> > implementation.
> > 
> > v7 adds a final patch to switch to using DRM_ERROR for reporting timeouts.
> > 
> > Daniel Kurtz (8):
> >   drm/i915/intel_i2c: handle zero-length writes
> >   drm/i915/intel_i2c: use double-buffered writes
> >   drm/i915/intel_i2c: always wait for IDLE before clearing NAK
> >   drm/i915/intel_i2c: use WAIT cycle, not STOP
> >   drm/i915/intel_i2c: use INDEX cycles for i2c read transactions
> >   drm/i915/intel_i2c: reuse GMBUS2 value read in polling loop
> >   drm/i915/intel_i2c: remove POSTING_READ() from gmbus transfers
> >   drm/i915/intel_i2c: use DRM_ERROR on timeouts
> 
> The only two I am still dubious about is 4/8: use WAIT cycle, not STOP,
> and 8/8: use DRM_ERROR on timeouts, the rest are
> Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
> 
> The last is a little debatable, as i2c can be called from userspace (and
> other modules) and we have not verified that the adapters we set up
> correspond to devices conditions. So I think it is still possible under
> normal conditions to hit the error path, so would prefer to keep the log
> level as INFO.

I have to admit that I've suggested this patch. We might need to drop it
before release, but I also want to have a few pointless bug about void
error messages and I'd like to figure out whether gmbus now really works.
Easiest way for that is to throw an annoying error message into dmesg when
it doesn't.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
