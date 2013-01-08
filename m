Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab3AHOhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 09:37:13 -0500
Received: from fieldses.org ([174.143.236.118]:36666 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401Ab3AHOhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 09:37:12 -0500
Date: Tue, 8 Jan 2013 09:37:10 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: "Hangcheck timer elapsed... GPU hung" in 3.8.0-rc2
Message-ID: <20130108143710.GA16343@fieldses.org>
References: <20130103204624.GA2533@fieldses.org>
 <CA+5PVA6PSsWGVAvSkdZXgoPaaroTuC0LvJ6-3mo1aU9LEUA1Sw@mail.gmail.com>
 <20130103231123.GD3238@fieldses.org>
 <20130106180652.GQ5737@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130106180652.GQ5737@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2013 at 07:06:52PM +0100, Daniel Vetter wrote:
> On Thu, Jan 03, 2013 at 06:11:23PM -0500, J. Bruce Fields wrote:
> > On Thu, Jan 03, 2013 at 04:16:24PM -0500, Josh Boyer wrote:
> > > On Thu, Jan 3, 2013 at 3:46 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> > > > I got a crash after a few minutes of running 3.8.0-rc2, was able to
> > > > switch to a vt and look at dmesg:
> > > >
> > > >   [  490.962545] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
> > > >   [  490.963019] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
> > > >   [  492.961446] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
> > > >   [  492.965613] [drm:i915_reset] *ERROR* GPU hanging too fast, declaring wedged!
> > > >   [  492.965621] [drm:i915_reset] *ERROR* Failed to reset chip.
> > > >
> > > > Previously I was on 3.6.10-2.fc17.x86_64, which didn't have any such
> > > > problem.
> > > 
> > > I'm not questioning that you haven't seen that error in F17, but we have
> > > had quite a few bug reports with similar error messages for a while now.
> > > Apparently there are lots of ways GPUs can get hung, so they might be
> > > different from what you're seeing.  Just wanted to point out that it
> > > might not be a new 3.8 change that caused it.
> > 
> > OK, sure.  It reproduced very quickly after the upgrade, so I assumed it
> > was a regression.
> > 
> > I'm running 3.7.0 now which hasn't shown any problem.
> > 
> > I'll try a newer kernel again to see if it's really that easy for me to
> > reproduce.
> 
> If you hit this again (even better if you have a way to reproduce)

Unfortunately I wasn't able to reproduce after working a couple more
hours on 3.8 again.  However:

> please grab the i915_error_state file from debugfs

As I said in the original mail, I've already done that:

	http://fieldses.org/~bfields/3.8-hang/

> and file a bug on
> bugs.freedesktop.org against DRM - DRI (Intel).

Would it still be useful for me to file a bug?  (Just going through the
new-account confirmation dance now.)

--b.

> We do know of a few recent
> issues introduced around 3.7 kernels, preliminary patches are floating
> around. The error state should be good enough to decide whether you're
> hitting the same issues.
> 
> Thanks, Daniel
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
