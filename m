Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab2CXTc0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 15:32:26 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37322 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab2CXTcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 15:32:24 -0400
Date: Sat, 24 Mar 2012 20:33:08 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Daniel Kurtz <djkurtz@chromium.org>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>, Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH 00/10 v2] fix gmbus writes and related issues
Message-ID: <20120324193308.GB18786@phenom.ffwll.local>
Mail-Followup-To: Daniel Kurtz <djkurtz@chromium.org>,
	Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Benson Leung <bleung@chromium.org>,
	Yufeng Shen <miletus@chromium.org>,
	Sameer Nanda <snanda@chromium.org>
References: <1331318904-20577-1-git-send-email-djkurtz@chromium.org>
 <20120318182204.GH4286@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120318182204.GH4286@phenom.ffwll.local>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 07:22:05PM +0100, Daniel Vetter wrote:
> On Sat, Mar 10, 2012 at 02:48:14AM +0800, Daniel Kurtz wrote:
> > This patchset addresses a couple of issues with the i915 gmbus implementation:
> >  * fixes misassigned pin port pair for HDMI-D
> >  * fixes write transactions when they are the only transaction requested
> >    (including large >4-byte writes) by terminating every transaction with a
> >    WAIT cycle.
> >  * returns -ENXIO and -ETIMEDOUT as appropriate so upper layers can handled
> >    i2c transaction failures
> >  * optimizes the typical read transaction case by using the INDEX cycle
> >  * turns on the GMBUS interrupt whenever possible to dramatically improve
> >    throughput by eliminating the very slow polling loop.
> > 
> > The patchset should apply cleanly onto linus/master.
> > It is inspired by, but completely supercedes, a similar patch submitted
> > recently by Benson Leung (bleung@chromium.org).
> > I'd be happy to rebase on a different tree if necessary.
> > 
> > v2 of the patchset address review comments from Chris Wilson (thanks for the
> > review, Chris!), and adds the interrupt patch.  There weren't any review
> > comments for patches 5, 7, or 8 of the first set.  Hopefully they will get
> > more love the second time around :).
> 
> Oops, still catching up - I've commented on the first thread. Please
> resubmit on top of drm-intel-next-queued and I'll have a look. Also,
> please cc me so I don't miss them.

I've pushed aout a few more changes to intel_i2c.c in my
drm-intel-next-queued branch. Generally I like these patches, so please
rebase and resubmit.

Thanks, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
