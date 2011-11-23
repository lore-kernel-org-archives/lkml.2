Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1KWUe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 15:34:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57726 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab1KWUe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 15:34:27 -0500
Date: Wed, 23 Nov 2011 21:35:42 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Daniel Vetter <daniel@ffwll.ch>, rajesh.sankaran@intel.com,
        Keith Packard <keithp@keithp.com>, Matthew Garrett <mjg@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: By default, enable RC6 on IVB and SNB when
 reasonable
Message-ID: <20111123203542.GI3864@phenom.ffwll.local>
Mail-Followup-To: David Woodhouse <dwmw2@infradead.org>,
	rajesh.sankaran@intel.com, Keith Packard <keithp@keithp.com>,
	Matthew Garrett <mjg@redhat.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1321684889-18691-1-git-send-email-keithp@keithp.com>
 <20111122201531.GD5547@srcf.ucam.org>
 <861uszfrah.fsf@sumi.keithp.com>
 <20111123102643.GB3864@phenom.ffwll.local>
 <1322056914.15493.158.camel@shinybook.infradead.org>
 <20111123143931.GE3864@phenom.ffwll.local>
 <1322060623.15493.168.camel@shinybook.infradead.org>
 <20111123154128.GG3864@phenom.ffwll.local>
 <1322062985.15493.176.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322062985.15493.176.camel@shinybook.infradead.org>
X-Operating-System: Linux phenom 3.1.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 03:43:05PM +0000, David Woodhouse wrote:
> On Wed, 2011-11-23 at 16:41 +0100, Daniel Vetter wrote:
> > Hm, that comment confuses me a bit. I've always thought that igfx_off only
> > instantiates a identity mapping and leaves the dmar unit on. Is that
> > wrong? 
> 
> It's completely off. If a DMAR unit has *only* graphics devices behind
> it (as the one for the built-in graphics does, because it's a whole
> boatload of speshul case for integration with the GTT), we just don't
> enable it at all. See the second for_each_drhd_unit() loop in
> init_no_remapping_devices().

That explanation confused me even more. So I've rechecked with
intel_iommu=igfx_off and already thought I've made a decent fool of
myself because I couldn't readily hang it. Turns out it's just much harder
to hang with that. So I think moving around the tlb flushing for other
dmar nodes to align with the idled igfx isn't a great solution, simply
because I can't reliably tell whether it fixes anything.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
