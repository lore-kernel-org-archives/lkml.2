Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab1ALWlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 17:41:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:9475 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405Ab1ALWlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 17:41:07 -0500
Message-Id: <b7da2f$q4bsoi@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,314,1291622400"; 
   d="scan'208";a="876999442"
Date: Wed, 12 Jan 2011 22:40:58 +0000
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] drm intel only fixes
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
In-Reply-To: <AANLkTi=80ccp1LtcXw1zO-7Rp58_+9yw-tebkJr67g9M@mail.gmail.com>
References: <alpine.DEB.2.00.1101120601100.6210@skynet.skynet.ie> <AANLkTimgs8UfGWk5PCZi4PM5SsvejJd5Y4bb3nHGyZy2@mail.gmail.com> <20110112114649.5365d518@jbarnes-desktop> <AANLkTinSygbLm=nmXy_Wf2ENV8WcQqCc0BKAAOsysvZd@mail.gmail.com> <AANLkTimSKOa8XavLn_RsLZ2scZ=ujdYahcTkeJ2pxBFq@mail.gmail.com> <AANLkTi=80ccp1LtcXw1zO-7Rp58_+9yw-tebkJr67g9M@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011 14:24:17 -0800, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, Jan 12, 2011 at 1:28 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Oh, and I'm also seeing corruption on my sandybridge machine. No video
> > involved, the gdm login screen is already corrupted this way. Similar
> > odd shifted lines etc, so I'd assume it's related.
> 
> Hmm. I bisected it down to
> 
>   commit 6fe4f14044f181e146cdc15485428f95fa541ce8
>   Author: Chris Wilson <chris@chris-wilson.co.uk>
>   Date:   Mon Jan 10 17:35:37 2011 +0000
> 
>       drm/i915/execbuffer: Reorder binding of objects to favour restrictions
> 
> on my sandybridge machine.  Chris?

Wow. That should have had zero visible impact upon the rendering. All it
should have done is reorder the sequence in which we pin the buffers into
the GTT before applying the relocations, just to allow some pathological
execbuffers.

Just the SNB machine?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
