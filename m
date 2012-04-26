Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606Ab2DZQ7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 12:59:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56391 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab2DZQ7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 12:59:42 -0400
Date: Thu, 26 Apr 2012 19:00:39 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: [pull] drm-intel-fixes for 3.4
Message-ID: <20120426170039.GF5156@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>
References: <20120426153501.GC5156@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120426153501.GC5156@phenom.ffwll.local>
X-Operating-System: Linux phenom 3.2.0-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 05:35:01PM +0200, Daniel Vetter wrote:
> Hi Dave,
> 
> Nothing major here and imo can wait a bit if you don't have anything
> important in drm-fixes yet:
> - VGA load-detect fix. This bug seems to be as old as the load-detect code
>   (2.6.30), but needs stupid userspace (upowerd trying to detect
>   connectors on dpms-off outputs) to actually kill the machine. And
>   obviously a machine without VGA-hotplug, otherwise we don't do load
>   detect.
> - 2 interger overflow fixes for unpriviledged ioctls from Xi Wang.

A tested-by for a regression fix just arrived, so I've thrown that in, too:
- Fix SDVO regression for low-res (pixelclock < 100MHz) digital outputs,
  introduce in 2.6.36.

Cheers, Daniel

The following changes since commit 66f75a5d028beaf67c931435fdc3e7823125730c:

  Linux 3.4-rc4 (2012-04-21 14:47:52 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~danvet/drm-intel drm-intel-fixes

for you to fetch changes up to 6651819b4b4fc3caa6964c5d825eb4bb996f3905:

  drm/i915: handle input/output sdvo timings separately in mode_set (2012-04-26 18:56:26 +0200)

----------------------------------------------------------------
Daniel Vetter (2):
      drm/i915: fixup load-detect on enabled, but not active pipe
      drm/i915: handle input/output sdvo timings separately in mode_set

Xi Wang (2):
      drm/i915: fix integer overflow in i915_gem_execbuffer2()
      drm/i915: fix integer overflow in i915_gem_do_execbuffer()

 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    8 ++++++-
 drivers/gpu/drm/i915/intel_crt.c           |   29 +++++++++---------------
 drivers/gpu/drm/i915/intel_sdvo.c          |   34 +++++++++++++++-------------
 3 files changed, 36 insertions(+), 35 deletions(-)
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
