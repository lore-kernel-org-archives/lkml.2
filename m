Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab3AFSFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 13:05:00 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:58118 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074Ab3AFSE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 13:04:57 -0500
Date: Sun, 6 Jan 2013 19:06:52 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Josh Boyer <jwboyer@gmail.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: "Hangcheck timer elapsed... GPU hung" in 3.8.0-rc2
Message-ID: <20130106180652.GQ5737@phenom.ffwll.local>
Mail-Followup-To: "J. Bruce Fields" <bfields@fieldses.org>,
	Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
References: <20130103204624.GA2533@fieldses.org>
 <CA+5PVA6PSsWGVAvSkdZXgoPaaroTuC0LvJ6-3mo1aU9LEUA1Sw@mail.gmail.com>
 <20130103231123.GD3238@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130103231123.GD3238@fieldses.org>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 06:11:23PM -0500, J. Bruce Fields wrote:
> On Thu, Jan 03, 2013 at 04:16:24PM -0500, Josh Boyer wrote:
> > On Thu, Jan 3, 2013 at 3:46 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> > > I got a crash after a few minutes of running 3.8.0-rc2, was able to
> > > switch to a vt and look at dmesg:
> > >
> > >   [  490.962545] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
> > >   [  490.963019] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
> > >   [  492.961446] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
> > >   [  492.965613] [drm:i915_reset] *ERROR* GPU hanging too fast, declaring wedged!
> > >   [  492.965621] [drm:i915_reset] *ERROR* Failed to reset chip.
> > >
> > > Previously I was on 3.6.10-2.fc17.x86_64, which didn't have any such
> > > problem.
> > 
> > I'm not questioning that you haven't seen that error in F17, but we have
> > had quite a few bug reports with similar error messages for a while now.
> > Apparently there are lots of ways GPUs can get hung, so they might be
> > different from what you're seeing.  Just wanted to point out that it
> > might not be a new 3.8 change that caused it.
> 
> OK, sure.  It reproduced very quickly after the upgrade, so I assumed it
> was a regression.
> 
> I'm running 3.7.0 now which hasn't shown any problem.
> 
> I'll try a newer kernel again to see if it's really that easy for me to
> reproduce.

If you hit this again (even better if you have a way to reproduce) please
grab the i915_error_state file from debugfs and file a bug on
bugs.freedesktop.org against DRM - DRI (Intel). We do know of a few recent
issues introduced around 3.7 kernels, preliminary patches are floating
around. The error state should be good enough to decide whether you're
hitting the same issues.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
