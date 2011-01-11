Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab1AKER0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 23:17:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754177Ab1AKERT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 23:17:19 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 10 Jan 2011 20:16:57 -0800
Message-ID: <AANLkTinW8Yp1K1w+G+BgLa-fPaFANkGsRjqH_W8N+9VL@mail.gmail.com>
Subject: Re: [git pull] drm for rc1
To: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 2:59 PM, Dave Airlie <airlied@linux.ie> wrote:
> Highlights:
> core/drivers: add support for high precision vblank timestamps
> radeon: pageflipping support, Gen2 PCIE support
> nouveau: reworked VRAM and VM support
> intel: better ILK/SNB powersaving support, Full GTT support

Lowlights: it's broken.

I get millions of messages like:

  ...
  [ 8482.000414] [drm:i915_hangcheck_ring_idle] *ERROR* Hangcheck
timer elapsed... render ring idle [waiting on 30938, at 30938], missed
IRQ?
  [ 8485.918124] [drm:i915_hangcheck_ring_idle] *ERROR* Hangcheck
timer elapsed... render ring idle [waiting on 31068, at 31068], missed
IRQ?
  [ 8487.926963] [drm:i915_hangcheck_ring_idle] *ERROR* Hangcheck
timer elapsed... render ring idle [waiting on 31129, at 31129], missed
IRQ?
  ...

and everything is very choppy. I assume it's the power saving thing
that broke again, but that's just a total random guess, I have nothing
to actually back that up with.

It worked fine after boot, but those problems began at 8287.139375
(about two hours after boot - it may have coincided with screen saver,
but who knows?)  and have been happening constantly since. The machine
is not really usable, I'm writing this with annoying 2-second pauses
every once in a while.

This is a regular Core i5-670 with up-to-date Fedora-14, fwiw. Not my
sandybridge.

          Linus
