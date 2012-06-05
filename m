Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab2FETSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 15:18:35 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60553 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2FETSe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 15:18:34 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20120605191853.GD4704@phenom.ffwll.local>
References: <20120605191853.GD4704@phenom.ffwll.local>
Date: Tue, 5 Jun 2012 21:18:33 +0200
X-Google-Sender-Auth: -8Nym-av2n9UqIttE2Kw_K6a98w
Message-ID: <CAKMK7uEoFo7mBnJoQAUQM82Y_b8Bq3OUny4+tW8jxRhuaD+4sw@mail.gmail.com>
Subject: Re: [PULL] drm-intel-fixes
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Meh, I've forgotten to cc the appropriate set of lists.
-Daniel

On Tue, Jun 5, 2012 at 9:18 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> Hi Dave
>
> A few fixes for 3.5. Most of them make corner-cases a bit more robust
> (hotplug for b0rked kvm switches, driver init/reset/resume), almost all of
> them are cc stable. The tip patch fixes up pageflip on the 3rd crtc for
> ivb. No, don't ask how much our QA and testing needs to suck so that we
> happily ship with totally broken pageflip. And to add insult to injury
> pageflip was broken across much many machines :(
>
> On the upside we now have an automated i-g-t test for this and pageflips
> should really work everywhere now ...
>
> Yours, Daniel
>
> The following changes since commit 1c780f2cfec8b533b9cfda77209b4e3e7adaddbf:
>
>  drm/udl: remove unused variables. (2012-05-29 13:47:59 +0100)
>
> are available in the git repository at:
>
>  git://people.freedesktop.org/~danvet/drm-intel drm-intel-fixes
>
> for you to fetch changes up to cb05d8dedefa3066bf5d74ef88c6ca6cf4bd1c87:
>
>  drm/i915: fix up ivb plane 3 pageflips (2012-06-05 21:05:21 +0200)
>
> ----------------------------------------------------------------
> Chris Wilson (3):
>      drm/i915: Reset last_retired_head when resetting ring
>      drm/i915/crt: Do not rely upon the HPD presence pin
>      drm/i915: Mark the ringbuffers as being in the GTT domain
>
> Daniel Vetter (2):
>      drm/i915: hold forcewake around ring hw init
>      drm/i915: fix up ivb plane 3 pageflips
>
>  drivers/gpu/drm/i915/i915_drv.c         |   13 +++++++++----
>  drivers/gpu/drm/i915/i915_drv.h         |    3 +++
>  drivers/gpu/drm/i915/i915_reg.h         |    8 ++++++++
>  drivers/gpu/drm/i915/intel_crt.c        |    8 +++++---
>  drivers/gpu/drm/i915/intel_display.c    |   19 ++++++++++++++++++-
>  drivers/gpu/drm/i915/intel_ringbuffer.c |   21 ++++++++++++++++++---
>  6 files changed, 61 insertions(+), 11 deletions(-)



-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch
