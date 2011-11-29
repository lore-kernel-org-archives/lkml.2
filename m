Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab1K2RVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 12:21:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49092 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab1K2RVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 12:21:32 -0500
Date: Tue, 29 Nov 2011 18:22:53 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH 2/2] drm/i915: properly clflush pwrites to phys objects
Message-ID: <20111129172253.GD11090@phenom.ffwll.local>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, stable@kernel.org
References: <1322579369-26954-1-git-send-email-daniel.vetter@ffwll.ch>
 <1322579369-26954-2-git-send-email-daniel.vetter@ffwll.ch>
 <c55c5d$185nps@AZSMGA002.ch.intel.com>
 <20111129161652.GD5667@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129161652.GD5667@phenom.ffwll.local>
X-Operating-System: Linux phenom 3.1.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 05:16:52PM +0100, Daniel Vetter wrote:
> On Tue, Nov 29, 2011 at 03:35:54PM +0000, Chris Wilson wrote:
> > On Tue, 29 Nov 2011 16:09:29 +0100, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > > Usually results in (rare) cursor corruptions on platforms
> > > requiring physically addressed cursors.
> > 
> > So the phys cursor pages are set to WC upon creation, are we just
> > missing the mb()? Or more likely the CPUs don't have PAT and we are
> > being lazy in not detecting the error.
> 
> Yes, on reconsidering the tested-by is from a pentium m, which has working
> pat, and we do a wbinvd in the i8xx chipset flush, so I don't know anymore
> how this patch actually works.
> 
> But it seems to indeed fix the issue for at least one reporter and cursor
> update is about as far away from a perf critical path as possible, so who
> cares about such minor quibbles, it works ;-)

After some irc discussion with Dave Airlie I'll now try whether a simple
wmb(); to flush the wc cache isn't good enough. Will take at least a week
to run by testers and gathe feedback, though.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
