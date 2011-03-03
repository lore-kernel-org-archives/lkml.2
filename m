Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab1CCAnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 19:43:41 -0500
Received: from mail.elliptictech.com ([209.217.122.41]:37347 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab1CCAnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 19:43:40 -0500
Date: Wed, 2 Mar 2011 19:43:26 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paolo Ornati <ornati@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [2.6.38-rc6] G965: i915 Hangcheck timer elapsed... GPU hung (not
 reproducible)
Message-ID: <20110303004326.GA18486@elliptictech.com>
References: <20110227101041.6b864352@gmail.com>
 <20110302155648.421f0292.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302155648.421f0292.akpm@linux-foundation.org>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Feb 2011 10:10:41 +0100 Paolo Ornati <ornati@gmail.com> wrote:
> Today I got this while starting a video in SMplayer (MPlayer) with
> 2.6.38-rc6-00113-g4662db4:

> > [  830.880014] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
> > [  830.880736] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -11 (awaiting 174895 at 174857, next 174896)
> > [  830.881093] [drm:init_ring_common] *ERROR* render ring initialization failed ctl 00000000 head 00000000 tail 00000000 start 00000000
> > [  831.379079] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
> > [  831.399099] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling

I was experiencing intermittent hangs when starting mplayer earlier in
this release cycle (on both a desktop with a G45 and a laptop with a
GM45), but I haven't encountered them in quite a while.  I don't know if
they looked exactly like the above since all the hangs have been rotated
out of my logs :(.  I ended up concluding that it was actually a
regression in xf86-video-intel rather than the kernel (but no real way
of testing this), since there was a lot of Xv related churn in the
driver around the time I was having the issues.

So you might want to try again with the latest git xf86-video-intel and
see if it still happens.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
