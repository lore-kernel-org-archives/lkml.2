Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab1DALou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 07:44:50 -0400
Received: from cable-static-216-94.intergga.ch ([87.102.216.94]:40310 "EHLO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab1DALot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 07:44:49 -0400
X-Spam-ASN: 
X-Spam-Spammy: 0.966-+--H*r:mail.ffwll.ch, 0.875-+--H*F:D*ffwll.ch
X-Spam-Hammy: 0.000-+--HCc:D*freedesktop.org,
	0.000-+--HCc:D*lists.freedesktop.org, 0.000-+--KMS
Date: Fri, 1 Apr 2011 13:44:30 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Disable all outputs early, before
 KMS takeover
Message-ID: <20110401114429.GA3526@viiv.ffwll.ch>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	intel-gfx@lists.freedesktop.org, Pekka Enberg <penberg@kernel.org>,
	linux-kernel@vger.kernel.org
References: <AANLkTi=VqkYjdiDLJvM-OfmBSGx-EkRkt=4XCDEnvZsU@mail.gmail.com>
 <1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk>
X-Operating-System: Linux viiv 2.6.38-08569-g16c29da 
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 11:46:29AM +0100, Chris Wilson wrote:
> If the outputs are active and continuing to access the GATT when we
> teardown the PTEs, then there is a potential for us to hang the GPU.
> The hang tends to be a PGTBL_ER with either an invalid host access or
> an invalid display plane fetch.

This patch seems to fix resume flakiness (that recently developed
complete reliability in hanging the gpu) on my i855gm. Captured
error_states look as described here. Latest -staging merged into latest
-linus is now again fully reliable at s/r.

Tested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
