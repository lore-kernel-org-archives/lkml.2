Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1BTKzb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 05:55:31 -0500
Received: from cable-static-49-187.intergga.ch ([157.161.49.187]:49636 "EHLO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005Ab1BTKza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 05:55:30 -0500
X-Spam-ASN: 
X-Spam-Spammy: 0.965-+--H*r:mail.ffwll.ch, 0.912-9--advertised,
	0.874-+--H*F:D*ffwll.ch
X-Spam-Hammy: 0.000-+--H*Ad:U*dri-devel, 0.000-+--HCc:D*freedesktop.org,
	0.000-+--HCc:D*lists.freedesktop.org
Date: Sun, 20 Feb 2011 11:55:15 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Indan Zupancic <indan@nul.nu>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: [BUG] drm/i915 Screen corruption introduced by
 a00b10c360b35d6431a94cb
Message-ID: <20110220105514.GB3514@viiv.ffwll.ch>
Mail-Followup-To: Indan Zupancic <indan@nul.nu>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <3f9bbd0924f54f6241cc16293fbcbbb4.squirrel@webmail.greenhost.nl>
 <20110219182511.GA3977@viiv.ffwll.ch>
 <92f5b87a3559ed7f1b7c46b7497c1ad5.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <92f5b87a3559ed7f1b7c46b7497c1ad5.squirrel@webmail.greenhost.nl>
X-Operating-System: Linux viiv 2.6.38-rc5-00035-g3077686 
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Sun, Feb 20, 2011 at 03:20:15AM +0100, Indan Zupancic wrote:
> > I've created two quick patches to check a few theories, please test them
> > (both patches independently and both together). Patches attached.
> 
> Tried with both applied, doesn't change anything.

I've just noticed that one of the patches (the 2nd one) doesn't work as
advertised. Please retest with the attached one.

Yours, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

--qDbXVdCdHGoSgWSk
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="for-indan-2.patch"

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 17bd766..d275c96 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -762,9 +762,6 @@ static int i915_getparam(struct drm_device *dev, void *data,
 	case I915_PARAM_HAS_BLT:
 		value = HAS_BLT(dev);
 		break;
-	case I915_PARAM_HAS_RELAXED_FENCING:
-		value = 1;
-		break;
 	case I915_PARAM_HAS_COHERENT_RINGS:
 		value = 1;
 		break;

--qDbXVdCdHGoSgWSk--
