Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab1KUKU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:20:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:11623 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab1KUKU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:20:26 -0500
Message-Id: <aefc95$2ambkf@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="78327439"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [Intel-gfx] [PATCH 01/13] drm/i915: fall through pwrite_gtt_slow to the shmem slow path
To: Ben Widawsky <ben@bwidawsk.net>, Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
In-Reply-To: <20111120190918.2b138476@bwidawsk.net>
References: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch> <1320606840-21132-2-git-send-email-daniel.vetter@ffwll.ch> <20111120190918.2b138476@bwidawsk.net>
Date: Mon, 21 Nov 2011 10:20:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Nov 2011 19:09:18 -0800, Ben Widawsky <ben@bwidawsk.net> wrote:
> On Sun,  6 Nov 2011 20:13:48 +0100
> Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> 
> > The gtt_pwrite slowpath grabs the userspace memory with
> > get_user_pages. This will not work for non-page backed memory, like a
> > gtt mmapped gem object. Hence fall throuh to the shmem paths if we hit
> > -EFAULT in the gtt paths.
> > 
> > Now the shmem paths have exactly the same problem, but this way we
> > only need to rearrange the code in one write path.
> > 
> > v2: v1 accidentaly falls back to shmem pwrite for phys objects. Fixed.
> > 
> > Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> It would be nice if there was some way to notify users that pwriting a
> gtt mmapped address can be really damn slow. That's also the one
> behavior change this patch introduces. It's possible that some SW was
> expecting to get a, "fast path" and would deal with the -EFAULT if it
> didn't get it.

The behaviour change is intentional. Before this patch we would
deadlock...
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
